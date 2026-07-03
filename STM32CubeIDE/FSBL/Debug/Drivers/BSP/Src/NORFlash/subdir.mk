################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/extmem_user_driver.c \
D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash.c \
D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash_by25fq128el.c \
D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash_mx25um25645g.c \
D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash_xspi.c 

OBJS += \
./Drivers/BSP/Src/NORFlash/extmem_user_driver.o \
./Drivers/BSP/Src/NORFlash/norflash.o \
./Drivers/BSP/Src/NORFlash/norflash_by25fq128el.o \
./Drivers/BSP/Src/NORFlash/norflash_mx25um25645g.o \
./Drivers/BSP/Src/NORFlash/norflash_xspi.o 

C_DEPS += \
./Drivers/BSP/Src/NORFlash/extmem_user_driver.d \
./Drivers/BSP/Src/NORFlash/norflash.d \
./Drivers/BSP/Src/NORFlash/norflash_by25fq128el.d \
./Drivers/BSP/Src/NORFlash/norflash_mx25um25645g.d \
./Drivers/BSP/Src/NORFlash/norflash_xspi.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/BSP/Src/NORFlash/extmem_user_driver.o: D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/extmem_user_driver.c Drivers/BSP/Src/NORFlash/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N647xx -c -I../../../FSBL/Core/Inc -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Middlewares/ST/STM32_ExtMem_Manager -I../../../Middlewares/ST/STM32_ExtMem_Manager/boot -I../../../Middlewares/ST/STM32_ExtMem_Manager/sal -I../../../Middlewares/ST/STM32_ExtMem_Manager/nor_sfdp -I../../../Middlewares/ST/STM32_ExtMem_Manager/psram -I../../../Middlewares/ST/STM32_ExtMem_Manager/sdcard -I../../../Middlewares/ST/STM32_ExtMem_Manager/user -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"
Drivers/BSP/Src/NORFlash/norflash.o: D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash.c Drivers/BSP/Src/NORFlash/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N647xx -c -I../../../FSBL/Core/Inc -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Middlewares/ST/STM32_ExtMem_Manager -I../../../Middlewares/ST/STM32_ExtMem_Manager/boot -I../../../Middlewares/ST/STM32_ExtMem_Manager/sal -I../../../Middlewares/ST/STM32_ExtMem_Manager/nor_sfdp -I../../../Middlewares/ST/STM32_ExtMem_Manager/psram -I../../../Middlewares/ST/STM32_ExtMem_Manager/sdcard -I../../../Middlewares/ST/STM32_ExtMem_Manager/user -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"
Drivers/BSP/Src/NORFlash/norflash_by25fq128el.o: D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash_by25fq128el.c Drivers/BSP/Src/NORFlash/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N647xx -c -I../../../FSBL/Core/Inc -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Middlewares/ST/STM32_ExtMem_Manager -I../../../Middlewares/ST/STM32_ExtMem_Manager/boot -I../../../Middlewares/ST/STM32_ExtMem_Manager/sal -I../../../Middlewares/ST/STM32_ExtMem_Manager/nor_sfdp -I../../../Middlewares/ST/STM32_ExtMem_Manager/psram -I../../../Middlewares/ST/STM32_ExtMem_Manager/sdcard -I../../../Middlewares/ST/STM32_ExtMem_Manager/user -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"
Drivers/BSP/Src/NORFlash/norflash_mx25um25645g.o: D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash_mx25um25645g.c Drivers/BSP/Src/NORFlash/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N647xx -c -I../../../FSBL/Core/Inc -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Middlewares/ST/STM32_ExtMem_Manager -I../../../Middlewares/ST/STM32_ExtMem_Manager/boot -I../../../Middlewares/ST/STM32_ExtMem_Manager/sal -I../../../Middlewares/ST/STM32_ExtMem_Manager/nor_sfdp -I../../../Middlewares/ST/STM32_ExtMem_Manager/psram -I../../../Middlewares/ST/STM32_ExtMem_Manager/sdcard -I../../../Middlewares/ST/STM32_ExtMem_Manager/user -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"
Drivers/BSP/Src/NORFlash/norflash_xspi.o: D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash/norflash_xspi.c Drivers/BSP/Src/NORFlash/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m55 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32N647xx -c -I../../../FSBL/Core/Inc -I../../../Drivers/STM32N6xx_HAL_Driver/Inc -I../../../Drivers/CMSIS/Device/ST/STM32N6xx/Include -I../../../Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I../../../Middlewares/ST/STM32_ExtMem_Manager -I../../../Middlewares/ST/STM32_ExtMem_Manager/boot -I../../../Middlewares/ST/STM32_ExtMem_Manager/sal -I../../../Middlewares/ST/STM32_ExtMem_Manager/nor_sfdp -I../../../Middlewares/ST/STM32_ExtMem_Manager/psram -I../../../Middlewares/ST/STM32_ExtMem_Manager/sdcard -I../../../Middlewares/ST/STM32_ExtMem_Manager/user -I../../../Drivers/CMSIS/Include -I"D:/Data/CodeX/Firmware/Drivers/BSP/NORFlash" -I"D:/Data/CodeX/Firmware/Drivers/BSP/HyperRAM" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -mcmse -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-BSP-2f-Src-2f-NORFlash

clean-Drivers-2f-BSP-2f-Src-2f-NORFlash:
	-$(RM) ./Drivers/BSP/Src/NORFlash/extmem_user_driver.cyclo ./Drivers/BSP/Src/NORFlash/extmem_user_driver.d ./Drivers/BSP/Src/NORFlash/extmem_user_driver.o ./Drivers/BSP/Src/NORFlash/extmem_user_driver.su ./Drivers/BSP/Src/NORFlash/norflash.cyclo ./Drivers/BSP/Src/NORFlash/norflash.d ./Drivers/BSP/Src/NORFlash/norflash.o ./Drivers/BSP/Src/NORFlash/norflash.su ./Drivers/BSP/Src/NORFlash/norflash_by25fq128el.cyclo ./Drivers/BSP/Src/NORFlash/norflash_by25fq128el.d ./Drivers/BSP/Src/NORFlash/norflash_by25fq128el.o ./Drivers/BSP/Src/NORFlash/norflash_by25fq128el.su ./Drivers/BSP/Src/NORFlash/norflash_mx25um25645g.cyclo ./Drivers/BSP/Src/NORFlash/norflash_mx25um25645g.d ./Drivers/BSP/Src/NORFlash/norflash_mx25um25645g.o ./Drivers/BSP/Src/NORFlash/norflash_mx25um25645g.su ./Drivers/BSP/Src/NORFlash/norflash_xspi.cyclo ./Drivers/BSP/Src/NORFlash/norflash_xspi.d ./Drivers/BSP/Src/NORFlash/norflash_xspi.o ./Drivers/BSP/Src/NORFlash/norflash_xspi.su

.PHONY: clean-Drivers-2f-BSP-2f-Src-2f-NORFlash

