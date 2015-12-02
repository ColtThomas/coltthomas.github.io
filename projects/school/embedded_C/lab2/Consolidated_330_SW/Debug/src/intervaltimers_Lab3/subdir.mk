################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/intervaltimers_Lab3/intervalTimer.c \
../src/intervaltimers_Lab3/main.c 

OBJS += \
./src/intervaltimers_Lab3/intervalTimer.o \
./src/intervaltimers_Lab3/main.o 

C_DEPS += \
./src/intervaltimers_Lab3/intervalTimer.d \
./src/intervaltimers_Lab3/main.d 


# Each subdirectory must supply rules for building sources it contributes
src/intervaltimers_Lab3/%.o: ../src/intervaltimers_Lab3/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM g++ compiler'
	arm-xilinx-eabi-g++ -Wall -O2 -finline-functions -g3 -I"J:\ecen330\lab2\Consolidated_330_SW" -c -fmessage-length=0 -I../../HW3_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


