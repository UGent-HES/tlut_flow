################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
xorTest_0.elf.size \

ELFCHECK += \
xorTest_0.elf.elfcheck \


# All Target
all: xorTest_0.elf secondary-outputs

# Tool invocations
xorTest_0.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: PowerPC gcc linker
	powerpc-eabi-gcc -Wl,-T -Wl,../src/lscript.ld -L../../xorTest_bsp_0/ppc440_0/lib -mcpu=440 -o"xorTest_0.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

xorTest_0.elf.size: xorTest_0.elf
	@echo Invoking: PowerPC Print Size
	powerpc-eabi-size xorTest_0.elf  |tee "xorTest_0.elf.size"
	@echo Finished building: $@
	@echo ' '

xorTest_0.elf.elfcheck: xorTest_0.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck xorTest_0.elf -hw ../../xor_design/system.xml -pe ppc440_0  |tee "xorTest_0.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) xorTest_0.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
