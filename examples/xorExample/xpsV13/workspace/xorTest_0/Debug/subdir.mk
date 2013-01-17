################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../../../swReconfiguration/exorw32.c \
../../../swReconfiguration/locations.c \
../../../swReconfiguration/testReconfiguration.c 

OBJS += \
./exorw32.o \
./locations.o \
./testReconfiguration.o 

C_DEPS += \
./exorw32.d \
./locations.d \
./testReconfiguration.d 


# Each subdirectory must supply rules for building sources it contributes
exorw32.o: ../../../swReconfiguration/exorw32.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xorTest_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

locations.o: ../../../swReconfiguration/locations.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xorTest_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

testReconfiguration.o: ../../../swReconfiguration/testReconfiguration.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xorTest_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


