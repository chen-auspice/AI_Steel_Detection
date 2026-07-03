################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
D:/Data/CodeX/Firmware/Drivers/BSP/LED/led.c 

OBJS += \
./Drivers/BSP/LED/led.o 

C_DEPS += \
./Drivers/BSP/LED/led.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/BSP/LED/led.o: D:/Data/CodeX/Firmware/Drivers/BSP/LED/led.c Drivers/BSP/LED/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32N647xx -DBSP_UART_RX_DISABLE -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_HAS_PARALLEL_NETWORKS=0 -DTX_EXECUTION_PROFILE_ENABLE -DLL_ATON_PLATFORM=LL_ATON_PLAT_STM32N6 -DLL_ATON_OSAL=LL_ATON_OSAL_THREADX -DLL_ATON_SW_FALLBACK -c -I../../../Appli/Core/Inc -I../../../Secure_nsclib -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LED" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LCD" -I"D:/Data/CodeX/Firmware/Drivers/BSP/BUS" -I"D:/Data/CodeX/Firmware/Drivers/BSP/UART" -I"D:/Data/CodeX/Firmware/Drivers/CMSIS/DSP/Include" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/common/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/utility/execution_profile_kit" -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/isp/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/evision/Inc" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_ISP" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors/imx335" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/ll_aton" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/Devices/STM32N6XX" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_VISION_MODELS_PP/Inc" -I"D:/Data/CodeX/Firmware/Utilities/lcd" -I"D:/Data/CodeX/Firmware/Model" -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-BSP-2f-LED

clean-Drivers-2f-BSP-2f-LED:
	-$(RM) ./Drivers/BSP/LED/led.cyclo ./Drivers/BSP/LED/led.d ./Drivers/BSP/LED/led.o ./Drivers/BSP/LED/led.su

.PHONY: clean-Drivers-2f-BSP-2f-LED

