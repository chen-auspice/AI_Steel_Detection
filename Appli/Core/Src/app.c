/**
 ****************************************************************************************************
 * @file        app.c
 * @author      ALIENTEK / AI_Steel_Detection
 * @version     V1.1
 * @date        2026-05-25
 * @brief       带钢表面缺陷检测应用主流程
 *              (基于正点原子 STM32N647 AI 人体检测例程改造)
 *              - 摄像头 (IMX335) 通过 DCMIPP 双管道: pipe1 -> LCD, pipe2 -> 256x256 -> NPU
 *              - YOLOv8n 推理 (Neural-ART NPU) -> YOLOv8 后处理 -> 按类别置信阈值过滤 -> LCD 叠加框
 *              - 板载 PG6 LED 实现缺陷报警, PA3 为 LCD 背光控制脚不再用作报警输出
 * @license     Copyright (c) 2020-2032
 ****************************************************************************************************
 */

#include "app.h"
#include "app_config.h"
#include "app_utils.h"
#include "app_lcd.h"
#include "app_camera.h"
#include "app_bqueue.h"
#include "app_cpuload.h"
#include "app_postprocess.h"
#include "app_rgb_led.h"
#include "tx_api.h"
#include "cmw_camera.h"
#include "ll_aton_runtime.h"
#include <string.h>

/* 板载 LED1 = PE10 (低电平点亮)。PA3 是 LCD 背光控制脚,不能用于蜂鸣器。 */
#define ALARM_LED_PORT       GPIOE
#define ALARM_LED_PIN        GPIO_PIN_10
#define ALARM_LED_ON_STATE   GPIO_PIN_RESET
#define ALARM_LED_OFF_STATE  GPIO_PIN_SET
#define DISPLAY_CONF_THRESHOLD 0.55f

typedef struct {
    int32_t nb_detect;
    od_pp_outBuffer_t detects[AI_OBJDETECT_YOLOV8_PP_MAX_BOXES_LIMIT];
    uint32_t nn_period_ms;
    uint32_t inf_ms;
    uint32_t pp_ms;
    uint32_t disp_ms;
} app_display_info_t;

typedef struct {
    TX_SEMAPHORE update;
    TX_MUTEX lock;
    app_display_info_t info;
} app_display_t;

static TX_SEMAPHORE isp_semaphore;

static void app_camera_display_pipe_vsync_cb(void);
static void app_camera_display_pipe_frame_cb(void);
static void app_camera_nn_pipe_frame_cb(void);

static TX_THREAD nn_thread;
static UCHAR nn_thread_stack[4096];
static TX_THREAD pp_thread;
static UCHAR pp_thread_stack[4096];
static TX_THREAD dp_thread;
static UCHAR dp_thread_stack[4096];
static TX_THREAD isp_thread;
static UCHAR isp_thread_stack[4096];
static TX_THREAD key_thread;
static UCHAR key_thread_stack[2048];

static VOID nn_thread_entry(ULONG id);
static VOID pp_thread_entry(ULONG id);
static VOID dp_thread_entry(ULONG id);
static VOID isp_thread_entry(ULONG id);
static VOID key_thread_entry(ULONG id);

static app_display_t display;

LL_ATON_DECLARE_NAMED_NN_INSTANCE_AND_INTERFACE(Default);
static uint8_t nn_input_buffers[2][NN_WIDTH * NN_HEIGHT * NN_BPP] __attribute__((aligned(32))) __attribute__((section(".EXTRAM")));
static app_bqueue_t nn_input_queue;
static uint8_t nn_output_buffers[2][ALIGN_VALUE(NN_BUFFER_OUT_SIZE, 32)] __attribute__((aligned(32)));
static app_bqueue_t nn_output_queue;
static const char *nn_classes_table[NN_CLASSES] = NN_CLASSES_TABLE;
static const char *nn_classes_short_table[NN_CLASSES] = NN_CLASSES_CN_TABLE;

static app_cpuload_t cpuload;

/* 拍照识别模式 */
static volatile uint8_t photo_mode = 0;         /* 0=实时模式, 1=拍照模式 */
static volatile uint8_t photo_request = 0;      /* KEY0 已按下, 等待 NN 线程捕获帧 */
static volatile uint8_t photo_frame_ready = 0;  /* 拍照帧已准备好待推理 */
static volatile uint8_t photo_detect_done = 0;  /* 拍照推理完成 */
static uint8_t photo_buffer[NN_WIDTH * NN_HEIGHT * NN_BPP] __attribute__((aligned(32))) __attribute__((section(".EXTRAM")));

static uint8_t app_detection_is_valid(const od_pp_outBuffer_t *detect);
static float app_display_conf_threshold(int32_t class_index);
static void app_display_network_output(app_display_info_t *display_info);
static void app_alarm_set(uint8_t on);
#if NN_INPUT_U8_TO_S8_CONVERSION
static void app_convert_rgb_u8_to_s8(uint8_t *buffer, uint32_t length);
#endif

void app_run(void)
{
    app_lcd_init();
    app_bqueue_init(&nn_input_queue, 2, (uint8_t *[2]){nn_input_buffers[0], nn_input_buffers[1]});
    app_bqueue_init(&nn_output_queue, 2, (uint8_t *[2]){nn_output_buffers[0], nn_output_buffers[1]});
    app_cpuload_init(&cpuload);
    app_camera_init(app_camera_display_pipe_vsync_cb, app_camera_display_pipe_frame_cb, NULL, app_camera_nn_pipe_frame_cb);

    /* 报警初始关闭 */
    app_alarm_set(0);

    tx_semaphore_create(&isp_semaphore, NULL, 0);
    tx_semaphore_create(&display.update, NULL, 0);
    tx_mutex_create(&display.lock, NULL, TX_INHERIT);

    app_camera_display_pipe_start(app_lcd_get_bg_buffer(), CMW_MODE_CONTINUOUS);

    tx_thread_create(&nn_thread, "NN Thread", nn_thread_entry, 0, nn_thread_stack, sizeof(nn_thread_stack), TX_MAX_PRIORITIES - 3, TX_MAX_PRIORITIES - 3, 10, TX_AUTO_START);
    tx_thread_create(&pp_thread, "PP Thread", pp_thread_entry, 0, pp_thread_stack, sizeof(pp_thread_stack), TX_MAX_PRIORITIES - 2, TX_MAX_PRIORITIES - 2, 10, TX_AUTO_START);
    tx_thread_create(&dp_thread, "DP Thread", dp_thread_entry, 0, dp_thread_stack, sizeof(dp_thread_stack), TX_MAX_PRIORITIES - 2, TX_MAX_PRIORITIES - 2, 10, TX_AUTO_START);
    tx_thread_create(&isp_thread, "ISP Thread", isp_thread_entry, 0, isp_thread_stack, sizeof(isp_thread_stack), TX_MAX_PRIORITIES - 4, TX_MAX_PRIORITIES - 4, 10, TX_AUTO_START);
    tx_thread_create(&key_thread, "Key Thread", key_thread_entry, 0, key_thread_stack, sizeof(key_thread_stack), TX_MAX_PRIORITIES - 3, TX_MAX_PRIORITIES - 3, 10, TX_AUTO_START);
}

static void app_camera_display_pipe_vsync_cb(void)
{
    tx_semaphore_put(&isp_semaphore);
}

static void app_camera_display_pipe_frame_cb(void)
{
    if (!photo_mode)
    {
        app_lcd_switch_bg_buffer();
        app_camera_display_pipe_set_address(app_lcd_get_bg_buffer());
    }
    /* photo_mode 下不切换背景缓冲区, LCD 画面冻结 */
}

static void app_camera_nn_pipe_frame_cb(void)
{
    uint8_t *buffer;

    buffer = app_bqueue_get_free(&nn_input_queue, 0);
    if (buffer != NULL)
    {
        app_camera_nn_pipe_set_address(buffer);
        app_bqueue_put_ready(&nn_input_queue);
    }
}

#if NN_INPUT_U8_TO_S8_CONVERSION
/* UINT8 RGB888 → INT8: 每字节 ^= 0x80, 等价于 pixel - 128
 * 摄像头 0→-128, 128→0, 255→127, 符合模型量化约定 */
static void app_convert_rgb_u8_to_s8(uint8_t *buffer, uint32_t length)
{
    uint32_t i;

    for (i = 0; i < length; i++)
    {
        buffer[i] ^= 0x80U;
    }
}
#endif

static VOID nn_thread_entry(ULONG id)
{
    uint32_t nn_out_len;
    uint32_t nn_in_len;
    uint8_t *nn_pipe_dst;
    uint8_t *capture_buffer;
    uint8_t *output_buffer;
    uint32_t nn_period[2];
    uint32_t nn_period_ms;
    uint32_t time_stamp;
    uint32_t inf_ms;

    nn_in_len = LL_Buffer_len(LL_ATON_Input_Buffers_Info_Default());
    nn_out_len = LL_Buffer_len(LL_ATON_Output_Buffers_Info_Default());

    nn_period[1] = HAL_GetTick();

    nn_pipe_dst = app_bqueue_get_free(&nn_input_queue, 0);

    app_camera_nn_pipe_start(nn_pipe_dst, CMW_MODE_CONTINUOUS);

    while (1)
    {
        if (photo_mode)
        {
            /* 拍照模式 */
            if (photo_frame_ready && !photo_detect_done)
            {
                /* 对拍照帧执行推理 */
                output_buffer = app_bqueue_get_free(&nn_output_queue, 1);

#if NN_INPUT_U8_TO_S8_CONVERSION
                app_convert_rgb_u8_to_s8(photo_buffer, nn_in_len);
                SCB_CleanDCache_by_Addr(photo_buffer, CACHE_ALIGNED_SIZE(nn_in_len));
#endif

                {
                    LL_ATON_User_IO_Result_t input_status;
                    LL_ATON_User_IO_Result_t output_status;

                    time_stamp = HAL_GetTick();
                    input_status = LL_ATON_Set_User_Input_Buffer_Default(0, photo_buffer, nn_in_len);
                    SCB_InvalidateDCache_by_Addr(output_buffer, CACHE_ALIGNED_SIZE(nn_out_len));
                    output_status = LL_ATON_Set_User_Output_Buffer_Default(0, output_buffer, nn_out_len);

                    if (input_status != LL_ATON_User_IO_NOERROR ||
                        output_status != LL_ATON_User_IO_NOERROR)
                    {
                        app_bqueue_put_free(&nn_output_queue);
                        photo_detect_done = 1;
                        continue;
                    }

                    LL_ATON_RT_Main(&NN_Instance_Default);
                    inf_ms = HAL_GetTick() - time_stamp;
                }

                app_bqueue_put_ready(&nn_output_queue);

                tx_mutex_get(&display.lock, TX_WAIT_FOREVER);
                display.info.inf_ms = inf_ms;
                display.info.nn_period_ms = 0;
                tx_mutex_put(&display.lock);

                photo_detect_done = 1;
            }
            else
            {
                /* 推理已完成或帧未就绪, 等待按键 */
                tx_thread_sleep(10);
            }
        }
        else
        {
            /* 实时模式: 正常摄像头推理 */
            nn_period[0] = nn_period[1];
            nn_period[1] = HAL_GetTick();
            nn_period_ms = nn_period[1] - nn_period[0];

            capture_buffer = app_bqueue_get_ready(&nn_input_queue);
            output_buffer = app_bqueue_get_free(&nn_output_queue, 1);

            /* DMA 写入后 CPU 读取前, 失效 D-Cache 避免读到旧数据 */
            SCB_InvalidateDCache_by_Addr(capture_buffer, CACHE_ALIGNED_SIZE(nn_in_len));

            /* KEY0 已按下: 捕获当前帧到 photo_buffer, 切换到拍照模式 */
            if (photo_request && !photo_frame_ready)
            {
                memcpy(photo_buffer, capture_buffer, nn_in_len);
                SCB_CleanDCache_by_Addr(photo_buffer, CACHE_ALIGNED_SIZE(nn_in_len));

                photo_request = 0;
                photo_frame_ready = 1;
                photo_detect_done = 0;
                photo_mode = 1;

                app_bqueue_put_free(&nn_input_queue);
                app_bqueue_put_free(&nn_output_queue);
                continue;
            }

#if NN_INPUT_U8_TO_S8_CONVERSION
            app_convert_rgb_u8_to_s8(capture_buffer, nn_in_len);
            SCB_CleanDCache_by_Addr(capture_buffer, CACHE_ALIGNED_SIZE(nn_in_len));
#endif

            {
                LL_ATON_User_IO_Result_t input_status;
                LL_ATON_User_IO_Result_t output_status;

                time_stamp = HAL_GetTick();
                input_status = LL_ATON_Set_User_Input_Buffer_Default(0, capture_buffer, nn_in_len);
                SCB_InvalidateDCache_by_Addr(output_buffer, CACHE_ALIGNED_SIZE(nn_out_len));
                output_status = LL_ATON_Set_User_Output_Buffer_Default(0, output_buffer, nn_out_len);

                if (input_status != LL_ATON_User_IO_NOERROR ||
                    output_status != LL_ATON_User_IO_NOERROR)
                {
                    app_bqueue_put_free(&nn_input_queue);
                    app_bqueue_put_free(&nn_output_queue);
                    continue;
                }

                LL_ATON_RT_Main(&NN_Instance_Default);
                inf_ms = HAL_GetTick() - time_stamp;
            }

            app_bqueue_put_free(&nn_input_queue);
            app_bqueue_put_ready(&nn_output_queue);

            tx_mutex_get(&display.lock, TX_WAIT_FOREVER);
            display.info.inf_ms = inf_ms;
            display.info.nn_period_ms = nn_period_ms;
            tx_mutex_put(&display.lock);
        }
    }
}

static VOID pp_thread_entry(ULONG id)
{
    yolov8_pp_static_param_t pp_params;
    uint8_t *output_buffer;
    od_pp_out_t pp_output;
    uint32_t nn_pp[2];
    int32_t i;
    int32_t detect_count;
    float class_threshold;
    int32_t best_class;
    float best_conf;
    static int32_t last_rgb_class = -2;

    app_postprocess_init(&pp_params);
    app_rgb_led_init();

    while (1)
    {
        output_buffer = app_bqueue_get_ready(&nn_output_queue);
        pp_output.pOutBuff = NULL;

        nn_pp[0] = HAL_GetTick();
        app_postprocess_run((void *[]){(void *)output_buffer}, 1, &pp_output, &pp_params);
        nn_pp[1] = HAL_GetTick();

        tx_mutex_get(&display.lock, TX_WAIT_FOREVER);
        display.info.nb_detect = 0;
        detect_count = 0;
        if (pp_output.pOutBuff != NULL)
        {
            for (i = 0; i < pp_output.nb_detect && detect_count < AI_OBJDETECT_YOLOV8_PP_MAX_BOXES_LIMIT; i++)
            {
                if (app_detection_is_valid(&pp_output.pOutBuff[i]))
                {
                    class_threshold = app_display_conf_threshold(pp_output.pOutBuff[i].class_index);
                    if (pp_output.pOutBuff[i].conf >= class_threshold)
                    {
                        display.info.detects[detect_count] = pp_output.pOutBuff[i];
                        detect_count++;
                    }
                }
            }
        }
        display.info.nb_detect = detect_count;
        display.info.pp_ms = nn_pp[1] - nn_pp[0];

        /* RGBLED 联动: 选置信度最高的类别, 变化时才刷新 */
        best_class = -1;
        best_conf = 0.0f;
        for (i = 0; i < detect_count; i++)
        {
            if (display.info.detects[i].conf > best_conf)
            {
                best_conf = display.info.detects[i].conf;
                best_class = display.info.detects[i].class_index;
            }
        }
        if (best_class != last_rgb_class)
        {
            last_rgb_class = best_class;
            app_rgb_led_show_class(best_class);
        }

        tx_mutex_put(&display.lock);
        app_bqueue_put_free(&nn_output_queue);
        tx_semaphore_ceiling_put(&display.update, 1);
    }
}

static VOID dp_thread_entry(ULONG id)
{
    uint32_t disp_ms = 0;
    app_display_info_t display_info;
    uint32_t time_stamp;

    while (1)
    {
        tx_semaphore_get(&display.update, TX_WAIT_FOREVER);
        tx_mutex_get(&display.lock, TX_WAIT_FOREVER);
        display_info = display.info;
        tx_mutex_put(&display.lock);
        display_info.disp_ms = disp_ms;

        /* 检测到任意缺陷 -> 触发声光报警, 否则关闭 */
        app_alarm_set(display_info.nb_detect > 0 ? 1 : 0);

        time_stamp = HAL_GetTick();
        app_display_network_output(&display_info);
        disp_ms = HAL_GetTick() - time_stamp;
    }
}

static VOID isp_thread_entry(ULONG id)
{
    while (1)
    {
        tx_semaphore_get(&isp_semaphore, TX_WAIT_FOREVER);

        app_camera_isp_update();
    }
}

/* 独立按键扫描线程 */
static VOID key_thread_entry(ULONG id)
{
    uint8_t key0_pressed = 0;
    uint8_t key_up_pressed = 0;

    while (1)
    {
        /* KEY0: 低电平有效, 实时模式下按下 → 请求拍照 */
        if (HAL_GPIO_ReadPin(KEY0_PORT, KEY0_PIN) == GPIO_PIN_RESET)
        {
            if (!key0_pressed)
            {
                key0_pressed = 1;
                if (!photo_mode)
                {
                    photo_request = 1;
                    photo_frame_ready = 0;
                    photo_detect_done = 0;
                }
            }
        }
        else
        {
            key0_pressed = 0;
        }

        /* KEY_UP: 高电平有效, 拍照模式下按下 → 返回实时模式 */
        if (HAL_GPIO_ReadPin(KEY_UP_PORT, KEY_UP_PIN) == GPIO_PIN_SET)
        {
            if (!key_up_pressed)
            {
                key_up_pressed = 1;
                if (photo_mode)
                {
                    photo_mode = 0;
                    photo_request = 0;
                    photo_frame_ready = 0;
                    photo_detect_done = 0;
                }
            }
        }
        else
        {
            key_up_pressed = 0;
        }

        tx_thread_sleep(1);
    }
}

static uint8_t app_clamp_point(int32_t *x, int32_t *y)
{
    int32_t xi;
    int32_t yi;

    xi = *x;
    yi = *y;

    if (*x < 0)
    {
        *x = 0;
    }

    if (*y < 0)
    {
        *y = 0;
    }

    if (*x >= LCD_BG_WIDTH)
    {
        *x = LCD_BG_WIDTH - 1;
    }

    if (*y >= LCD_BG_HEIGHT)
    {
        *y = LCD_BG_HEIGHT - 1;
    }

    return (xi != *x) || (yi != *y);
}

/* 6 类对应不同颜色, 让缺陷一眼可分 */
static uint32_t app_class_color(int32_t class_index)
{
    static const uint32_t color_table[NN_CLASSES] = {
        UTIL_LCD_COLOR_RED,        /* crazing */
        UTIL_LCD_COLOR_ORANGE,     /* inclusion */
        UTIL_LCD_COLOR_YELLOW,     /* patches */
        UTIL_LCD_COLOR_MAGENTA,    /* pitted_surface */
        UTIL_LCD_COLOR_CYAN,       /* rolled-in_scale */
        UTIL_LCD_COLOR_GREEN,      /* scratches */
    };
    if (class_index < 0 || class_index >= NN_CLASSES)
    {
        return UTIL_LCD_COLOR_WHITE;
    }
    return color_table[class_index];
}

static uint8_t app_detection_is_valid(const od_pp_outBuffer_t *detect)
{
    if (detect->class_index < 0 || detect->class_index >= NN_CLASSES)
    {
        return 0;
    }

    if (detect->conf < AI_OBJDETECT_YOLOV8_PP_CONF_THRESHOLD || detect->conf > 1.0f)
    {
        return 0;
    }

    if (detect->x_center < 0.0f || detect->x_center > 1.0f || detect->y_center < 0.0f || detect->y_center > 1.0f)
    {
        return 0;
    }

    if (detect->width <= 0.0f || detect->width > 1.0f || detect->height <= 0.0f || detect->height > 1.0f)
    {
        return 0;
    }

    return 1;
}

static float app_display_conf_threshold(int32_t class_index)
{
    static const float threshold_table[NN_CLASSES] = {
        0.25f,    /* crazing: weak class, keep recall */
        0.55f,    /* inclusion */
        0.55f,    /* patches */
        0.55f,    /* pitted_surface */
        0.45f,    /* rolled-in_scale */
        0.55f,    /* scratches */
    };

    if (class_index < 0 || class_index >= NN_CLASSES)
    {
        return DISPLAY_CONF_THRESHOLD;
    }

    return threshold_table[class_index];
}

/* NN 归一化坐标 (0~1) -> LCD 像素坐标映射
 * 模型输出坐标属于 NN 正方形 ROI 坐标系, 需映射到 LCD 宽屏坐标系 */
static void app_nn_norm_to_lcd(float nx, float ny, int32_t *lx, int32_t *ly)
{
    CMW_Manual_roi_area_t lcd_r;
    CMW_Manual_roi_area_t nn_r;
    float sensor_x;
    float sensor_y;

    app_camera_get_lcd_roi(&lcd_r);
    app_camera_get_nn_roi(&nn_r);

    /* NN 归一化坐标 -> 传感器坐标 */
    sensor_x = (float)nn_r.offset_x + nx * (float)nn_r.width;
    sensor_y = (float)nn_r.offset_y + ny * (float)nn_r.height;

    /* 传感器坐标 -> LCD 像素坐标 */
    *lx = (int32_t)((sensor_x - (float)lcd_r.offset_x) * (float)LCD_BG_WIDTH / (float)lcd_r.width);
    *ly = (int32_t)((sensor_y - (float)lcd_r.offset_y) * (float)LCD_BG_HEIGHT / (float)lcd_r.height);
}

static void app_display_detection(od_pp_outBuffer_t *detect)
{
    int32_t x0;
    int32_t y0;
    int32_t x1;
    int32_t y1;
    int32_t x0_raw;
    int32_t y0_raw;
    int32_t x1_raw;
    int32_t y1_raw;
    uint32_t color;

    /* 先将框的两个角点从 NN 归一化坐标映射到 LCD 像素坐标 */
    app_nn_norm_to_lcd(detect->x_center - detect->width / 2.0f,
                       detect->y_center - detect->height / 2.0f,
                       &x0_raw, &y0_raw);
    app_nn_norm_to_lcd(detect->x_center + detect->width / 2.0f,
                       detect->y_center + detect->height / 2.0f,
                       &x1_raw, &y1_raw);

    x0 = x0_raw;
    y0 = y0_raw;
    x1 = x1_raw;
    y1 = y1_raw;

    app_clamp_point(&x0, &y0);
    app_clamp_point(&x1, &y1);

    if (x1 <= x0 + 2 || y1 <= y0 + 2)
    {
        return;
    }

    color = app_class_color(detect->class_index);
    UTIL_LCD_SetTextColor(color);
    UTIL_LCD_DrawRect(x0, y0, x1 - x0, y1 - y0, color);
    UTIL_LCD_DrawRect(x0 + 1, y0 + 1, x1 - x0 - 2, y1 - y0 - 2, color);
    UTIL_LCDEx_PrintfAt(x0 + 2, y0 + 2, LEFT_MODE, "%s %d%%",
                        nn_classes_short_table[detect->class_index],
                        (int)(detect->conf * 100));
    UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_WHITE);
}

/* 在 LCD 上绘制 NN 有效观察区域边框 */
static void app_display_nn_roi_overlay(void)
{
    CMW_Manual_roi_area_t lcd_r;
    CMW_Manual_roi_area_t nn_r;
    int32_t x0;
    int32_t y0;
    int32_t x1;
    int32_t y1;

    app_camera_get_lcd_roi(&lcd_r);
    app_camera_get_nn_roi(&nn_r);

    /* NN ROI 四个角映射到 LCD 像素坐标 */
    x0 = (int32_t)(((float)nn_r.offset_x - (float)lcd_r.offset_x) * (float)LCD_BG_WIDTH / (float)lcd_r.width);
    y0 = (int32_t)(((float)nn_r.offset_y - (float)lcd_r.offset_y) * (float)LCD_BG_HEIGHT / (float)lcd_r.height);
    x1 = (int32_t)(((float)(nn_r.offset_x + nn_r.width) - (float)lcd_r.offset_x) * (float)LCD_BG_WIDTH / (float)lcd_r.width);
    y1 = (int32_t)(((float)(nn_r.offset_y + nn_r.height) - (float)lcd_r.offset_y) * (float)LCD_BG_HEIGHT / (float)lcd_r.height);

    app_clamp_point(&x0, &y0);
    app_clamp_point(&x1, &y1);

    UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_WHITE);
    UTIL_LCD_DrawRect(x0, y0, x1 - x0, y1 - y0, UTIL_LCD_COLOR_WHITE);
}

static void app_display_network_output(app_display_info_t *display_info)
{
    float cpuload_one_second;
    uint8_t line_nb = 0;
    int32_t i;

    app_lcd_draw_area_update();

    UTIL_LCD_FillRect(0, 0, LCD_FG_WIDTH, LCD_FG_HEIGHT, 0x00000000);

    app_cpuload_update(&cpuload);
    app_cpuload_get_info(&cpuload, NULL, &cpuload_one_second, NULL);

    /* 顶部标题 */
    UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_YELLOW);
    UTIL_LCDEx_PrintfAt(0, LINE(0), CENTER_MODE, "Steel Surface Defect Detection");
    UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_WHITE);

    /* 右侧统计信息 */
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 2), RIGHT_MODE, "CPU load");
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 3), RIGHT_MODE, "%.1f%%", cpuload_one_second);
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 5), RIGHT_MODE, "Inference");
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 6), RIGHT_MODE, "%ums", display_info->inf_ms);
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 8), RIGHT_MODE, "FPS");
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 9), RIGHT_MODE, "%.2f",
                        display_info->nn_period_ms ? 1000.0 / display_info->nn_period_ms : 0.0);
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 11), RIGHT_MODE, "Defects");
    UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 12), RIGHT_MODE, "%u", (unsigned)display_info->nb_detect);

    /* 状态指示 */
    if (display_info->nb_detect > 0)
    {
        UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_RED);
        UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 14), RIGHT_MODE, "ALARM!");
    }
    else
    {
        UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_GREEN);
        UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 14), RIGHT_MODE, "PASS");
    }
    UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_WHITE);

    /* 模式指示 */
    if (photo_mode)
    {
        UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_YELLOW);
        UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 16), RIGHT_MODE, "PHOTO");
        UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 17), RIGHT_MODE, "KEY_UP:BACK");
    }
    else
    {
        UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_CYAN);
        UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 16), RIGHT_MODE, "LIVE");
        UTIL_LCDEx_PrintfAt(0, LINE(line_nb + 17), RIGHT_MODE, "KEY0:CAP");
    }
    UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_WHITE);

    /* 底部图例, 不使用 LINE(21+) 以免越过 480 像素后在左上角回卷闪烁 */
    UTIL_LCDEx_PrintfAt(0, 360, LEFT_MODE, "Classes:");
    for (i = 0; i < NN_CLASSES; i++)
    {
        UTIL_LCD_SetTextColor(app_class_color(i));
        UTIL_LCDEx_PrintfAt((i < 3) ? 0 : 210,
                            384 + ((i % 3) * 28),
                            LEFT_MODE, "[%d] %s", (int)i, nn_classes_table[i]);
    }
    UTIL_LCD_SetTextColor(UTIL_LCD_COLOR_WHITE);

    for (i = 0; i < display_info->nb_detect; i++)
    {
        app_display_detection(&display_info->detects[i]);
    }

    /* 绘制 NN 有效区域边框 */
    app_display_nn_roi_overlay();

    app_lcd_draw_area_commit();
}

/* GPIO 控制板载 PE10 LED1 实现缺陷报警
 * - PE10 LED1 低电平有效, GPIO 初始化在 main.c 中已完成
 * - PA3 是 LCD 背光控制脚, 当前不用于蜂鸣器或报警输出
 */
static void app_alarm_set(uint8_t on)
{
    HAL_GPIO_WritePin(ALARM_LED_PORT, ALARM_LED_PIN,
                      on ? ALARM_LED_ON_STATE : ALARM_LED_OFF_STATE);
}
