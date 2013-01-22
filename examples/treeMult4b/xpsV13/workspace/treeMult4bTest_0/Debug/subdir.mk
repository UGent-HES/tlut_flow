################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../../../swReconfiguration/locations.c \
../../../swReconfiguration/main.c \
../../../swReconfiguration/treeMult4b.c 

OBJS += \
./locations.o \
./main.o \
./treeMult4b.o 

C_DEPS += \
./locations.d \
./main.d \
./treeMult4b.d 


# Each subdirectory must supply rules for building sources it contributes
locations.o: ../../../swReconfiguration/locations.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../treeMult4bTest_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

main.o: ../../../swReconfiguration/main.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../treeMult4bTest_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

treeMult4b.o: ../../../swReconfiguration/treeMult4b.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../treeMult4bTest_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


