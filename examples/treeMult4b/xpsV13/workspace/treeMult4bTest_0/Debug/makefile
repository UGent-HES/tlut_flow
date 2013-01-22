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
treeMult4bTest_0.elf.size \

ELFCHECK += \
treeMult4bTest_0.elf.elfcheck \


# All Target
all: treeMult4bTest_0.elf secondary-outputs

# Tool invocations
treeMult4bTest_0.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: PowerPC gcc linker
	powerpc-eabi-gcc -Wl,-T -Wl,../src/lscript.ld -L../../treeMult4bTest_bsp_0/ppc440_0/lib -mcpu=440 -o"treeMult4bTest_0.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

treeMult4bTest_0.elf.size: treeMult4bTest_0.elf
	@echo Invoking: PowerPC Print Size
	powerpc-eabi-size treeMult4bTest_0.elf  |tee "treeMult4bTest_0.elf.size"
	@echo Finished building: $@
	@echo ' '

treeMult4bTest_0.elf.elfcheck: treeMult4bTest_0.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck treeMult4bTest_0.elf -hw ../../xpsV13_hw_platform/system.xml -pe ppc440_0  |tee "treeMult4bTest_0.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) treeMult4bTest_0.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
