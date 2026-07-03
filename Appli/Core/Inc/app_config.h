/**
 ****************************************************************************************************
 * @file        app_config.h
 * @author      ALIENTEK / AI_Steel_Detection
 * @version     V1.1
 * @date        2026-05-25
 * @brief       带钢表面缺陷检测应用配置 (基于正点原子人体检测例程改造)
 * @license     Copyright (c) 2020-2032
 ****************************************************************************************************
 */

#ifndef __APP_CONFIG_H
#define __APP_CONFIG_H

#include "stm32n6xx_hal.h"
#include "postprocess_conf.h"

/* LCD 显示分辨率 (4.3 寸 RGB 800x480) */
#define LCD_BG_WIDTH                            800
#define LCD_BG_HEIGHT                           480
#define LCD_FG_WIDTH                            LCD_BG_WIDTH
#define LCD_FG_HEIGHT                           LCD_BG_HEIGHT

#define DISPLAY_DELAY                           1
#define DISPLAY_BUFFER_NB                       (DISPLAY_DELAY + 2)

#define CAMERA_MIRROR_FLIP                      CMW_MIRRORFLIP_NONE

#define CPU_LOAD_HISTORY_DEPTH                  8

#define BQUEUE_MAX_BUFFERS                      2

/* YOLOv8n int8 输入: 256x256 RGB888 */
#define NN_WIDTH                                256
#define NN_HEIGHT                               256
#define NN_FORMAT                               DCMIPP_PIXEL_PACKER_FORMAT_RGB888_YUV444_1
#define NN_BPP                                  3

/* UINT8→INT8 输入零点偏移开关
 * 摄像头输出 UINT8 RGB888 (0~255), 模型期望 INT8 (zero_point=-128)
 * 开启后在推理前对每字节执行 ^= 0x80, 等价于 pixel - 128
 * 设为 0 可关闭转换, 用于 A/B 对比实验 */
#define NN_INPUT_U8_TO_S8_CONVERSION            1

/* 按键引脚定义 (ATK-DNN647) */
#define KEY0_PORT               GPIOC
#define KEY0_PIN                GPIO_PIN_6
#define KEY_UP_PORT             GPIOC
#define KEY_UP_PIN              GPIO_PIN_13
/* 按键消抖时间 (ms) */
#define KEY_DEBOUNCE_MS         30
/* YOLOv8 int8 输出张量: 1344 anchors x (4 box + 6 classes) = 13440 字节 */
#define NN_BUFFER_OUT_SIZE                      13440

/* 6 类带钢表面缺陷 (NEU-DET) */
#define NN_CLASSES                              6
#define NN_CLASSES_TABLE                        {"crazing","inclusion","patches","pitted_surface","rolled-in_scale","scratches"}
/* 检测框显示名 */
#define NN_CLASSES_CN_TABLE                     {"crazing","inclusion","patches","pit","scale","scratch"}

/* 后处理: YOLOv8 INT8 输入 / INT8 输出 */
#define POSTPROCESS_TYPE                        POSTPROCESS_OD_YOLO_V8_UI
#define AI_OBJDETECT_YOLOV8_PP_CONF_THRESHOLD   0.25f
#define AI_OBJDETECT_YOLOV8_PP_IOU_THRESHOLD    0.45f
#define AI_OBJDETECT_YOLOV8_PP_MAX_BOXES_LIMIT  20

#endif
