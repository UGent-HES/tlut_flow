################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/kheyse/private/tlut_flow/examples/rom/xpsV13_XUPV5110T/swReconfiguration/locations.c \
/home/kheyse/private/tlut_flow/examples/rom/xpsV13_XUPV5110T/swReconfiguration/rom.c \
/home/kheyse/private/tlut_flow/examples/rom/xpsV13_XUPV5110T/swReconfiguration/testReconfiguration.c 

OBJS += \
./swReconfiguration/locations.o \
./swReconfiguration/rom.o \
./swReconfiguration/testReconfiguration.o 

C_DEPS += \
./swReconfiguration/locations.d \
./swReconfiguration/rom.d \
./swReconfiguration/testReconfiguration.d 


# Each subdirectory must supply rules for building sources it contributes
swReconfiguration/locations.o: /home/kheyse/private/tlut_flow/examples/rom/xpsV13_XUPV5110T/swReconfiguration/locations.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_V5110T_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

swReconfiguration/rom.o: /home/kheyse/private/tlut_flow/examples/rom/xpsV13_XUPV5110T/swReconfiguration/rom.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_V5110T_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

swReconfiguration/testReconfiguration.o: /home/kheyse/private/tlut_flow/examples/rom/xpsV13_XUPV5110T/swReconfiguration/testReconfiguration.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_V5110T_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


