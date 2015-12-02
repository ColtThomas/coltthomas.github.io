################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/switchesandbuttonslab2/buttons.c \
../src/switchesandbuttonslab2/main.c \
../src/switchesandbuttonslab2/switches.c 

OBJS += \
./src/switchesandbuttonslab2/buttons.o \
./src/switchesandbuttonslab2/main.o \
./src/switchesandbuttonslab2/switches.o 

C_DEPS += \
./src/switchesandbuttonslab2/buttons.d \
./src/switchesandbuttonslab2/main.d \
./src/switchesandbuttonslab2/switches.d 


# Each subdirectory must supply rules for building sources it contributes
src/switchesandbuttonslab2/%.o: ../src/switchesandbuttonslab2/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM g++ compiler'
	arm-xilinx-eabi-g++ -Wall -O3 -c -fmessage-length=0 -I../../HW3_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


