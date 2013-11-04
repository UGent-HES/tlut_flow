################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/locations.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/rom.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/testReconfiguration.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/xhwicap_custom.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/xhwicap_getset_clb_7series.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/xhwicap_multiframe.c 

OBJS += \
./swReconfiguration/locations.o \
./swReconfiguration/rom.o \
./swReconfiguration/testReconfiguration.o \
./swReconfiguration/xhwicap_custom.o \
./swReconfiguration/xhwicap_getset_clb_7series.o \
./swReconfiguration/xhwicap_multiframe.o 

C_DEPS += \
./swReconfiguration/locations.d \
./swReconfiguration/rom.d \
./swReconfiguration/testReconfiguration.d \
./swReconfiguration/xhwicap_custom.d \
./swReconfiguration/xhwicap_getset_clb_7series.d \
./swReconfiguration/xhwicap_multiframe.d 


# Each subdirectory must supply rules for building sources it contributes
swReconfiguration/locations.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/locations.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/rom.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/rom.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/testReconfiguration.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/testReconfiguration.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/xhwicap_custom.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/xhwicap_custom.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/xhwicap_getset_clb_7series.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/xhwicap_getset_clb_7series.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

swReconfiguration/xhwicap_multiframe.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/swReconfiguration/xhwicap_multiframe.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../rom_test_zynq_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


