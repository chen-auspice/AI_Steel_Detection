################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack.c \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/txe_thread_secure_stack_allocate.c \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/txe_thread_secure_stack_free.c 

S_UPPER_SRCS += \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_misra.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_context_restore.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_context_save.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_interrupt_control.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_interrupt_disable.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_interrupt_restore.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_schedule.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack_allocate.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack_free.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack_initialize.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_stack_build.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_system_return.S \
D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_timer_interrupt.S 

OBJS += \
./Middlewares/ThreadX/Ports/tx_misra.o \
./Middlewares/ThreadX/Ports/tx_thread_context_restore.o \
./Middlewares/ThreadX/Ports/tx_thread_context_save.o \
./Middlewares/ThreadX/Ports/tx_thread_interrupt_control.o \
./Middlewares/ThreadX/Ports/tx_thread_interrupt_disable.o \
./Middlewares/ThreadX/Ports/tx_thread_interrupt_restore.o \
./Middlewares/ThreadX/Ports/tx_thread_schedule.o \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack.o \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack_allocate.o \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack_free.o \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack_initialize.o \
./Middlewares/ThreadX/Ports/tx_thread_stack_build.o \
./Middlewares/ThreadX/Ports/tx_thread_system_return.o \
./Middlewares/ThreadX/Ports/tx_timer_interrupt.o \
./Middlewares/ThreadX/Ports/txe_thread_secure_stack_allocate.o \
./Middlewares/ThreadX/Ports/txe_thread_secure_stack_free.o 

S_UPPER_DEPS += \
./Middlewares/ThreadX/Ports/tx_misra.d \
./Middlewares/ThreadX/Ports/tx_thread_context_restore.d \
./Middlewares/ThreadX/Ports/tx_thread_context_save.d \
./Middlewares/ThreadX/Ports/tx_thread_interrupt_control.d \
./Middlewares/ThreadX/Ports/tx_thread_interrupt_disable.d \
./Middlewares/ThreadX/Ports/tx_thread_interrupt_restore.d \
./Middlewares/ThreadX/Ports/tx_thread_schedule.d \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack_allocate.d \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack_free.d \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack_initialize.d \
./Middlewares/ThreadX/Ports/tx_thread_stack_build.d \
./Middlewares/ThreadX/Ports/tx_thread_system_return.d \
./Middlewares/ThreadX/Ports/tx_timer_interrupt.d 

C_DEPS += \
./Middlewares/ThreadX/Ports/tx_thread_secure_stack.d \
./Middlewares/ThreadX/Ports/txe_thread_secure_stack_allocate.d \
./Middlewares/ThreadX/Ports/txe_thread_secure_stack_free.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/ThreadX/Ports/tx_misra.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_misra.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_context_restore.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_context_restore.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_context_save.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_context_save.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_interrupt_control.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_interrupt_control.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_interrupt_disable.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_interrupt_disable.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_interrupt_restore.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_interrupt_restore.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_schedule.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_schedule.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_secure_stack.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack.c Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32N647xx -DBSP_UART_RX_DISABLE -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_HAS_PARALLEL_NETWORKS=0 -DTX_EXECUTION_PROFILE_ENABLE -DLL_ATON_PLATFORM=LL_ATON_PLAT_STM32N6 -DLL_ATON_OSAL=LL_ATON_OSAL_THREADX -DLL_ATON_SW_FALLBACK -c -I../../../Appli/Core/Inc -I../../../Secure_nsclib -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LED" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LCD" -I"D:/Data/CodeX/Firmware/Drivers/BSP/BUS" -I"D:/Data/CodeX/Firmware/Drivers/BSP/UART" -I"D:/Data/CodeX/Firmware/Drivers/CMSIS/DSP/Include" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/common/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/utility/execution_profile_kit" -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/isp/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/evision/Inc" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_ISP" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors/imx335" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/ll_aton" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/Devices/STM32N6XX" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_VISION_MODELS_PP/Inc" -I"D:/Data/CodeX/Firmware/Utilities/lcd" -I"D:/Data/CodeX/Firmware/Model" -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/ThreadX/Ports/tx_thread_secure_stack_allocate.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack_allocate.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_secure_stack_free.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack_free.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_secure_stack_initialize.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_secure_stack_initialize.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_stack_build.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_stack_build.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_thread_system_return.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_thread_system_return.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/tx_timer_interrupt.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/tx_timer_interrupt.S Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m55 -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_EXECUTION_PROFILE_ENABLE -c -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
Middlewares/ThreadX/Ports/txe_thread_secure_stack_allocate.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/txe_thread_secure_stack_allocate.c Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32N647xx -DBSP_UART_RX_DISABLE -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_HAS_PARALLEL_NETWORKS=0 -DTX_EXECUTION_PROFILE_ENABLE -DLL_ATON_PLATFORM=LL_ATON_PLAT_STM32N6 -DLL_ATON_OSAL=LL_ATON_OSAL_THREADX -DLL_ATON_SW_FALLBACK -c -I../../../Appli/Core/Inc -I../../../Secure_nsclib -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LED" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LCD" -I"D:/Data/CodeX/Firmware/Drivers/BSP/BUS" -I"D:/Data/CodeX/Firmware/Drivers/BSP/UART" -I"D:/Data/CodeX/Firmware/Drivers/CMSIS/DSP/Include" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/common/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/utility/execution_profile_kit" -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/isp/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/evision/Inc" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_ISP" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors/imx335" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/ll_aton" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/Devices/STM32N6XX" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_VISION_MODELS_PP/Inc" -I"D:/Data/CodeX/Firmware/Utilities/lcd" -I"D:/Data/CodeX/Firmware/Model" -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"
Middlewares/ThreadX/Ports/txe_thread_secure_stack_free.o: D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/src/txe_thread_secure_stack_free.c Middlewares/ThreadX/Ports/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -DUSE_HAL_DRIVER -DSTM32N647xx -DBSP_UART_RX_DISABLE -DTX_SINGLE_MODE_SECURE -DTX_INCLUDE_USER_DEFINE_FILE -DTX_HAS_PARALLEL_NETWORKS=0 -DTX_EXECUTION_PROFILE_ENABLE -DLL_ATON_PLATFORM=LL_ATON_PLAT_STM32N6 -DLL_ATON_OSAL=LL_ATON_OSAL_THREADX -DLL_ATON_SW_FALLBACK -c -I../../../Appli/Core/Inc -I../../../Secure_nsclib -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LED" -I"D:/Data/CodeX/Firmware/Drivers/BSP/LCD" -I"D:/Data/CodeX/Firmware/Drivers/BSP/BUS" -I"D:/Data/CodeX/Firmware/Drivers/BSP/UART" -I"D:/Data/CodeX/Firmware/Drivers/CMSIS/DSP/Include" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/ports/cortex_m55/gnu/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/common/inc" -I"D:/Data/CodeX/Firmware/Middlewares/ThreadX/utility/execution_profile_kit" -I"D:/Data/CodeX/Firmware/Appli/ThreadX/App" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/isp/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_ISP/evision/Inc" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_ISP" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_MW_CAMERA/sensors/imx335" -I"D:/Data/CodeX/Firmware/Appli/STM32_MW_CAMERA" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Inc" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/ll_aton" -I"D:/Data/CodeX/Firmware/Middlewares/AI/Npu/Devices/STM32N6XX" -I"D:/Data/CodeX/Firmware/Middlewares/STM32_VISION_MODELS_PP/Inc" -I"D:/Data/CodeX/Firmware/Utilities/lcd" -I"D:/Data/CodeX/Firmware/Model" -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Middlewares-2f-ThreadX-2f-Ports

clean-Middlewares-2f-ThreadX-2f-Ports:
	-$(RM) ./Middlewares/ThreadX/Ports/tx_misra.d ./Middlewares/ThreadX/Ports/tx_misra.o ./Middlewares/ThreadX/Ports/tx_thread_context_restore.d ./Middlewares/ThreadX/Ports/tx_thread_context_restore.o ./Middlewares/ThreadX/Ports/tx_thread_context_save.d ./Middlewares/ThreadX/Ports/tx_thread_context_save.o ./Middlewares/ThreadX/Ports/tx_thread_interrupt_control.d ./Middlewares/ThreadX/Ports/tx_thread_interrupt_control.o ./Middlewares/ThreadX/Ports/tx_thread_interrupt_disable.d ./Middlewares/ThreadX/Ports/tx_thread_interrupt_disable.o ./Middlewares/ThreadX/Ports/tx_thread_interrupt_restore.d ./Middlewares/ThreadX/Ports/tx_thread_interrupt_restore.o ./Middlewares/ThreadX/Ports/tx_thread_schedule.d ./Middlewares/ThreadX/Ports/tx_thread_schedule.o ./Middlewares/ThreadX/Ports/tx_thread_secure_stack.cyclo ./Middlewares/ThreadX/Ports/tx_thread_secure_stack.d ./Middlewares/ThreadX/Ports/tx_thread_secure_stack.o ./Middlewares/ThreadX/Ports/tx_thread_secure_stack.su ./Middlewares/ThreadX/Ports/tx_thread_secure_stack_allocate.d ./Middlewares/ThreadX/Ports/tx_thread_secure_stack_allocate.o ./Middlewares/ThreadX/Ports/tx_thread_secure_stack_free.d ./Middlewares/ThreadX/Ports/tx_thread_secure_stack_free.o ./Middlewares/ThreadX/Ports/tx_thread_secure_stack_initialize.d ./Middlewares/ThreadX/Ports/tx_thread_secure_stack_initialize.o ./Middlewares/ThreadX/Ports/tx_thread_stack_build.d ./Middlewares/ThreadX/Ports/tx_thread_stack_build.o ./Middlewares/ThreadX/Ports/tx_thread_system_return.d ./Middlewares/ThreadX/Ports/tx_thread_system_return.o ./Middlewares/ThreadX/Ports/tx_timer_interrupt.d ./Middlewares/ThreadX/Ports/tx_timer_interrupt.o ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_allocate.cyclo ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_allocate.d ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_allocate.o ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_allocate.su ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_free.cyclo ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_free.d ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_free.o ./Middlewares/ThreadX/Ports/txe_thread_secure_stack_free.su

.PHONY: clean-Middlewares-2f-ThreadX-2f-Ports

