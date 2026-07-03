/**
 ****************************************************************************************************
 * @file        app_rgb_led.c
 * @author      AI_Steel_Detection
 * @version     V1.0
 * @date        2026-06-26
 * @brief       D0~D9 级联 RGBLED (WS2812 兼容) 驱动
 *              PF1 单线串行, GRB 顺序, 800kHz, 软件 bit-bang
 ****************************************************************************************************
 */

#include "app_rgb_led.h"
#include "app_config.h"
#include "core_cm55.h"

/* WS2812 时序: 根据 SystemCoreClock 动态计算周期数 */
/* 纳秒转周期: cycles = ns * (SystemCoreClock / 1000000000) */
#define NS_TO_CYCLES(ns)    ((uint32_t)((uint64_t)(ns) * SystemCoreClock / 1000000000UL))

#define T0H_NS          350     /* 0 码高电平 ~350ns */
#define T0L_NS          800     /* 0 码低电平 ~800ns */
#define T1H_NS          700     /* 1 码高电平 ~700ns */
#define T1L_NS          600     /* 1 码低电平 ~600ns */
#define RESET_US        80      /* reset/latch low time >50us */

#define RGB_LED_PORT    GPIOF
#define RGB_LED_PIN     GPIO_PIN_1

/* 缺陷类别颜色表 (GRB 顺序) */
static const app_rgb_t class_colors[NN_CLASSES] = {
    {  0, 32,  0},    /* 0 crazing          红 */
    { 16, 32,  0},    /* 1 inclusion        橙 */
    { 32, 32,  0},    /* 2 patches          黄 */
    {  0, 32, 32},    /* 3 pitted_surface   紫 */
    { 32,  0, 32},    /* 4 rolled-in_scale  青 */
    { 32,  0,  0},    /* 5 scratches        绿 */
};

/* DWT 精确延时: 等待 N 个 CPU 周期 */
static inline void rgb_delay_cycles(uint32_t cycles)
{
    uint32_t start = DWT->CYCCNT;
    while ((DWT->CYCCNT - start) < cycles)
    {
        __NOP();
    }
}

/* 发送 1 bit 到 RGBLED */
static inline void rgb_send_bit(uint8_t bit)
{
    if (bit)
    {
        RGB_LED_PORT->BSRR = RGB_LED_PIN;           /* 拉高 */
        rgb_delay_cycles(NS_TO_CYCLES(T1H_NS));
        RGB_LED_PORT->BRR = RGB_LED_PIN;            /* 拉低 */
        rgb_delay_cycles(NS_TO_CYCLES(T1L_NS));
    }
    else
    {
        RGB_LED_PORT->BSRR = RGB_LED_PIN;           /* 拉高 */
        rgb_delay_cycles(NS_TO_CYCLES(T0H_NS));
        RGB_LED_PORT->BRR = RGB_LED_PIN;            /* 拉低 */
        rgb_delay_cycles(NS_TO_CYCLES(T0L_NS));
    }
}

/* 发送 1 字节, MSB first */
static void rgb_send_byte(uint8_t byte)
{
    rgb_send_bit(byte & 0x80);
    rgb_send_bit(byte & 0x40);
    rgb_send_bit(byte & 0x20);
    rgb_send_bit(byte & 0x10);
    rgb_send_bit(byte & 0x08);
    rgb_send_bit(byte & 0x04);
    rgb_send_bit(byte & 0x02);
    rgb_send_bit(byte & 0x01);
}

/* 等待 reset 时间 (>50µs) */
static void rgb_reset(void)
{
    RGB_LED_PORT->BRR = RGB_LED_PIN;
    rgb_delay_cycles(NS_TO_CYCLES(RESET_US * 1000UL));
}

void app_rgb_led_init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    __HAL_RCC_GPIOF_CLK_ENABLE();

    GPIO_InitStruct.Pin = RGB_LED_PIN;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
    HAL_GPIO_Init(RGB_LED_PORT, &GPIO_InitStruct);

    HAL_GPIO_WritePin(RGB_LED_PORT, RGB_LED_PIN, GPIO_PIN_RESET);

    /* 使能 DWT 周期计数器用于精确延时 */
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CYCCNT = 0;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;

    /* 初始化后全灭 */
    app_rgb_led_clear();
}

void app_rgb_led_show(const app_rgb_t leds[RGB_LED_COUNT])
{
    uint32_t primask;
    int32_t i;

    primask = __get_PRIMASK();
    __disable_irq();

    rgb_reset();

    for (i = 0; i < RGB_LED_COUNT; i++)
    {
        rgb_send_byte(leds[i].g);
        rgb_send_byte(leds[i].r);
        rgb_send_byte(leds[i].b);
    }

    rgb_reset();

    __set_PRIMASK(primask);
}

void app_rgb_led_clear(void)
{
    app_rgb_t leds[RGB_LED_COUNT] = {0};
    app_rgb_led_show(leds);
}

void app_rgb_led_show_class(int32_t class_index)
{
    app_rgb_t leds[RGB_LED_COUNT] = {0};
    int32_t count;
    int32_t i;

    if (class_index < 0 || class_index >= NN_CLASSES)
    {
        app_rgb_led_clear();
        return;
    }

    count = class_index + 1;
    if (count > RGB_LED_COUNT)
    {
        count = RGB_LED_COUNT;
    }

    /* D0 硬件异常时保持为占位灯, 类别显示从 D1 开始:
     * class 0 -> D1
     * class 1 -> D1, D2
     * ...
     */
    if (count > (RGB_LED_COUNT - 1))
    {
        count = RGB_LED_COUNT - 1;
    }

    for (i = 1; i <= count; i++)
    {
        leds[i] = class_colors[class_index];
    }

    app_rgb_led_show(leds);
}
