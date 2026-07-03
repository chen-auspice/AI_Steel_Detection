################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Utilities/lcd/Src/subdir.mk
-include Model/subdir.mk
-include Middlewares/ThreadX/Ports/subdir.mk
-include Middlewares/ThreadX/Execution_Profile_Kit/subdir.mk
-include Middlewares/ThreadX/Common/subdir.mk
-include Middlewares/STM32_VISION_MODELS_PP/subdir.mk
-include Middlewares/STM32_MW_ISP/isp/subdir.mk
-include Middlewares/STM32_MW_CAMERA/sensors/imx335/subdir.mk
-include Middlewares/STM32_MW_CAMERA/sensors/subdir.mk
-include Middlewares/STM32_MW_CAMERA/STM32_MW_CAMERA/subdir.mk
-include Middlewares/AI/Npu/ll_aton/subdir.mk
-include Middlewares/AI/Npu/Devices/STM32N6XX/subdir.mk
-include Drivers/STM32N6xx_HAL_Driver/subdir.mk
-include Drivers/CMSIS/subdir.mk
-include Drivers/BSP/UART/subdir.mk
-include Drivers/BSP/NORFlash/subdir.mk
-include Drivers/BSP/LED/subdir.mk
-include Drivers/BSP/LCD/subdir.mk
-include Drivers/BSP/HyperRAM/subdir.mk
-include Drivers/BSP/BUS/subdir.mk
-include Application/User/ThreadX/subdir.mk
-include Application/User/Startup/subdir.mk
-include Application/User/Core/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \


BUILD_ARTIFACT_NAME := AI_Steel_Detection_Appli
BUILD_ARTIFACT_EXTENSION := elf
BUILD_ARTIFACT_PREFIX :=
BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
AI_Steel_Detection_Appli.elf \

MAP_FILES += \
AI_Steel_Detection_Appli.map \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
AI_Steel_Detection_Appli.list \

OBJCOPY_BIN += \
AI_Steel_Detection_Appli.bin \


# All Target
all:
	+@$(MAKE) --no-print-directory main-build && $(MAKE) --no-print-directory post-build

# Main-build Target
main-build: AI_Steel_Detection_Appli.elf secondary-outputs

# Tool invocations
AI_Steel_Detection_Appli.elf AI_Steel_Detection_Appli.map: $(OBJS) $(USER_OBJS) D:\Data\CodeX\Firmware\STM32CubeIDE\Appli\STM32N647X0HXQ_ROMxspi2_RAMxspi1.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "AI_Steel_Detection_Appli.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m55 -T"D:\Data\CodeX\Firmware\STM32CubeIDE\Appli\STM32N647X0HXQ_ROMxspi2_RAMxspi1.ld" --specs=nosys.specs -Wl,-Map="AI_Steel_Detection_Appli.map" -Wl,--gc-sections -static -Wl,--cmse-implib -Wl,--out-implib=./secure_nsclib.o -L"D:\Data\CodeX\Firmware\Middlewares\STM32_MW_ISP\evision\Lib" -L"D:\Data\CodeX\Firmware\Middlewares\AI\Lib\GCC\ARMCortexM55" -u _printf_float -Wl,--no-warn-rwx-segments --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

AI_Steel_Detection_Appli.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "AI_Steel_Detection_Appli.list"
	@echo 'Finished building: $@'
	@echo ' '

AI_Steel_Detection_Appli.bin: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "AI_Steel_Detection_Appli.bin"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) AI_Steel_Detection_Appli.bin AI_Steel_Detection_Appli.elf AI_Steel_Detection_Appli.list AI_Steel_Detection_Appli.map default.size.stdout
	-@echo ' '

post-build:
	bash "../postbuild.sh" "D:\App\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.win32_2.2.0.202409170845\tools\bin"
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST) $(OBJCOPY_BIN)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified post-build

-include ../makefile.targets
