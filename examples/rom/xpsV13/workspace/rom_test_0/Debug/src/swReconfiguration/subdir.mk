################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../../../swReconfiguration/locations.c \
../../../swReconfiguration/rom.c \
../../../swReconfiguration/testReconfiguration.c 

OBJS += \
./src/swReconfiguration/locations.o \
./src/swReconfiguration/rom.o \
./src/swReconfiguration/testReconfiguration.o 

C_DEPS += \
./src/swReconfiguration/locations.d \
./src/swReconfiguration/rom.d \
./src/swReconfiguration/testReconfiguration.d 


# Each subdirectory must supply rules for building sources it contributes
src/swReconfiguration/locations.o: ../../../swReconfiguration/locations.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_application_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

src/swReconfiguration/rom.o: ../../../swReconfiguration/rom.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_application_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

src/swReconfiguration/testReconfiguration.o: ../../../swReconfiguration/testReconfiguration.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_application_bsp_0/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


