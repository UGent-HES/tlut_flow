################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../../../swReconfiguration/exorw32.c \
../../../swReconfiguration/locations.c \
../../../swReconfiguration/testReconfiguration.c \
../../../swReconfiguration/xhwicap_custom.c \
../../../swReconfiguration/xhwicap_getset_clb_7series.c \
../../../swReconfiguration/xhwicap_multiframe.c 

OBJS += \
./swReconfiguration/exorw32.o \
./swReconfiguration/locations.o \
./swReconfiguration/testReconfiguration.o \
./swReconfiguration/xhwicap_custom.o \
./swReconfiguration/xhwicap_getset_clb_7series.o \
./swReconfiguration/xhwicap_multiframe.o 

C_DEPS += \
./swReconfiguration/exorw32.d \
./swReconfiguration/locations.d \
./swReconfiguration/testReconfiguration.d \
./swReconfiguration/xhwicap_custom.d \
./swReconfiguration/xhwicap_getset_clb_7series.d \
./swReconfiguration/xhwicap_multiframe.d 


# Each subdirectory must supply rules for building sources it contributes
swReconfiguration/exorw32.o: ../../../swReconfiguration/exorw32.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/locations.o: ../../../swReconfiguration/locations.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/testReconfiguration.o: ../../../swReconfiguration/testReconfiguration.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/xhwicap_custom.o: ../../../swReconfiguration/xhwicap_custom.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/xhwicap_getset_clb_7series.o: ../../../swReconfiguration/xhwicap_getset_clb_7series.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/xhwicap_multiframe.o: ../../../swReconfiguration/xhwicap_multiframe.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../xor_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


