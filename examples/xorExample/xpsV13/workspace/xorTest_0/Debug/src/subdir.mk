################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/exorw32.c \
../src/locations.c \
../src/testReconfiguration.c 

LD_SRCS += \
../src/lscript.ld 

OBJS += \
./src/exorw32.o \
./src/locations.o \
./src/testReconfiguration.o 

C_DEPS += \
./src/exorw32.d \
./src/locations.d \
./src/testReconfiguration.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xorTest_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


