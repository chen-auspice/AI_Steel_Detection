/*---------------------------------------------------------------------------------------------
#  * Copyright (c) 2026 STMicroelectronics.
#  * All rights reserved.
#  *
#  * 后处理参数 - YOLOv8n int8 @ 256x256, NEU-DET 6 类
#  *--------------------------------------------------------------------------------------------*/

#ifndef __POSTPROCESS_CONF_H__
#define __POSTPROCESS_CONF_H__

#include "arm_math.h"

/* YOLOv8n @ 256x256 三个 head 总 anchor 数 = 32*32 + 16*16 + 8*8 = 1344 */
#define AI_OBJDETECT_YOLOV8_PP_NB_CLASSES        (6)
#define AI_OBJDETECT_YOLOV8_PP_TOTAL_BOXES       (1344)

/* INT8 输出反量化参数: network.c 中用户输出张量 Transpose_577_out_0 */
#define AI_OBJDETECT_YOLOV8_PP_SCALE             (0.00622096983715892f)
#define AI_OBJDETECT_YOLOV8_PP_ZERO_POINT        (-118)

#endif      /* __POSTPROCESS_CONF_H__  */