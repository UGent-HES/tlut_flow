################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/akulkarn/private/Desktop/git_try/tlut_flow/examples/xorExample/xpsV13_blaze_genesys/swReconfiguration/exorw32.c \
/home/akulkarn/private/Desktop/git_try/tlut_flow/examples/xorExample/xpsV13_blaze_genesys/swReconfiguration/locations.c \
/home/akulkarn/private/Desktop/git_try/tlut_flow/examples/xorExample/xpsV13_blaze_genesys/swReconfiguration/testReconfiguration.c 

OBJS += \
./swReconfiguration/exorw32.o \
./swReconfiguration/locations.o \
./swReconfiguration/testReconfiguration.o 

C_DEPS += \
./swReconfiguration/exorw32.d \
./swReconfiguration/locations.d \
./swReconfiguration/testReconfiguration.d 


# Each subdirectory must supply rules for building sources it contributes
swReconfiguration/exorw32.o: /home/akulkarn/private/Desktop/git_try/tlut_flow/examples/xorExample/xpsV13_blaze_genesys/swReconfiguration/exorw32.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_genesys_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

swReconfiguration/locations.o: /home/akulkarn/private/Desktop/git_try/tlut_flow/examples/xorExample/xpsV13_blaze_genesys/swReconfiguration/locations.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_genesys_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

swReconfiguration/testReconfiguration.o: /home/akulkarn/private/Desktop/git_try/tlut_flow/examples/xorExample/xpsV13_blaze_genesys/swReconfiguration/testReconfiguration.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_genesys_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


