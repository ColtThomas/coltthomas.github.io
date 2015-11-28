################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/laserTag/detector.c \
../src/laserTag/filter.c \
../src/laserTag/histogram.c \
../src/laserTag/hitLedTimer.c \
../src/laserTag/isr.c \
../src/laserTag/lockoutTimer.c \
../src/laserTag/main.c \
../src/laserTag/queue.c \
../src/laserTag/transmitter.c \
../src/laserTag/trigger.c 

OBJS += \
./src/laserTag/detector.o \
./src/laserTag/filter.o \
./src/laserTag/histogram.o \
./src/laserTag/hitLedTimer.o \
./src/laserTag/isr.o \
./src/laserTag/lockoutTimer.o \
./src/laserTag/main.o \
./src/laserTag/queue.o \
./src/laserTag/transmitter.o \
./src/laserTag/trigger.o 

C_DEPS += \
./src/laserTag/detector.d \
./src/laserTag/filter.d \
./src/laserTag/histogram.d \
./src/laserTag/hitLedTimer.d \
./src/laserTag/isr.d \
./src/laserTag/lockoutTimer.d \
./src/laserTag/main.d \
./src/laserTag/queue.d \
./src/laserTag/transmitter.d \
./src/laserTag/trigger.d 


# Each subdirectory must supply rules for building sources it contributes
src/laserTag/%.o: ../src/laserTag/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM g++ compiler'
	arm-xilinx-eabi-g++ -Wall -O3 -finline-functions -g3 -I"F:\ecen390.3\ECEN390_Student_SW_0.2\Consolidated_330_SW" -c -fmessage-length=0 -MT"$@" -I../../HW3_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


