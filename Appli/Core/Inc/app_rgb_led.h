/**
 ****************************************************************************************************
 * @file        app_rgb_led.h
 * @author      AI_Steel_Detection
 * @version     V1.0
 * @date        2026-06-26
 * @brief       D0~D9 级联 RGBLED (WS2812 兼容) 驱动, 通过 PF1 单线串行控制
 ****************************************************************************************************
 */

#ifndef __APP_RGB_LED_H
#define __APP_RGB_LED_H

#include "stm32n6xx_hal.h"

#define RGB_LED_COUNT   10

typedef struct {
    uint8_t g;
    uint8_t r;
    uint8_t b;
} app_rgb_t;

void app_rgb_led_init(void);
void app_rgb_led_show(const app_rgb_t leds[RGB_LED_COUNT]);
void app_rgb_led_clear(void);
void app_rgb_led_show_class(int32_t class_index);

#endif
