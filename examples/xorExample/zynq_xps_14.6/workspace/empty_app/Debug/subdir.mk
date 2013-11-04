################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/exorw32.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/locations.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/testReconfiguration.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/xhwicap_custom.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/xhwicap_getset_clb.c \
/home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/xhwicap_multiframe.c 

OBJS += \
./exorw32.o \
./locations.o \
./testReconfiguration.o \
./xhwicap_custom.o \
./xhwicap_getset_clb.o \
./xhwicap_multiframe.o 

C_DEPS += \
./exorw32.d \
./locations.d \
./testReconfiguration.d \
./xhwicap_custom.d \
./xhwicap_getset_clb.d \
./xhwicap_multiframe.d 


# Each subdirectory must supply rules for building sources it contributes
exorw32.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/exorw32.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_app_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

locations.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/locations.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_app_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

testReconfiguration.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/testReconfiguration.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_app_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

xhwicap_custom.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/xhwicap_custom.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_app_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

xhwicap_getset_clb.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/xhwicap_getset_clb.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_app_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

xhwicap_multiframe.o: /home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/swReconfiguration/xhwicap_multiframe.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../empty_app_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


