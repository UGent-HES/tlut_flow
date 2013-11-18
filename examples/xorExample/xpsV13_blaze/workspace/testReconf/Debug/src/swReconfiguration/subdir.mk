################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../../../swReconfiguration/swReconfiguration/exorw32.c \
../../../swReconfiguration/locations.c \
../../../swReconfiguration/testReconfiguration.c 

OBJS += \
./src/swReconfiguration/exorw32.o \
./src/swReconfiguration/locations.o \
./src/swReconfiguration/testReconfiguration.o 

C_DEPS += \
./src/swReconfiguration/exorw32.d \
./src/swReconfiguration/locations.d \
./src/swReconfiguration/testReconfiguration.d 


# Each subdirectory must supply rules for building sources it contributes
src/swReconfiguration/exorw32.o: ../../../swReconfiguration/exorw32.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../hello_world_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

src/swReconfiguration/locations.o: ../../../swReconfiguration/locations.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../hello_world_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

src/swReconfiguration/testReconfiguration.o: ../../../swReconfiguration/testReconfiguration.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../hello_world_bsp_0/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


