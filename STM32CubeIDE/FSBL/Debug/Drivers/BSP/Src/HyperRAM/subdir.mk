################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM/hyperram.c 

OBJS += \
./Drivers/BSP/Src/HyperRAM/hyperram.o 

C_DEPS += \
./Drivers/BSP/Src/HyperRAM/hyperram.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/BSP/Src/HyperRAM/hyperram.o: D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM/hyperram.c Drivers/BSP/Src/HyperRAM/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N647xx -c -I../../../FSBL/Core/Inc -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Middlewares/ST/STM32_ExtMem_Manager -I../../../Middlewares/ST/STM32_ExtMem_Manager/boot -I../../../Middlewares/ST/STM32_ExtMem_Manager/sal -I../../../Middlewares/ST/STM32_ExtMem_Manager/nor_sfdp -I../../../Middlewares/ST/STM32_ExtMem_Manager/psram -I../../../Middlewares/ST/STM32_ExtMem_Manager/sdcard -I../../../Middlewares/ST/STM32_ExtMem_Manager/user -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-BSP-2f-Src-2f-HyperRAM

clean-Drivers-2f-BSP-2f-Src-2f-HyperRAM:
	-$(RM) ./Drivers/BSP/Src/HyperRAM/hyperram.cyclo ./Drivers/BSP/Src/HyperRAM/hyperram.d ./Drivers/BSP/Src/HyperRAM/hyperram.o ./Drivers/BSP/Src/HyperRAM/hyperram.su

.PHONY: clean-Drivers-2f-BSP-2f-Src-2f-HyperRAM

