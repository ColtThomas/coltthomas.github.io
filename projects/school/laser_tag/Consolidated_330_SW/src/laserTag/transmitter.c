/*
 * transmitter.c
 *
 *  Created on: Dec 22, 2014
 *      Author: hutch
 */

#include "transmitter.h"
#include "stdint.h"
#include "supportFiles/buttons.h"
#include "supportFiles/switches.h"
#include "supportFiles/mio.h"
#include "supportFiles/utils.h"
#include "stdio.h"


#include "queue.h"
#include "supportFiles/leds.h"
#include "supportFiles/globalTimer.h"
#include "supportFiles/interrupts.h"
#include "supportFiles/intervalTimer.h"
#include "stdbool.h"
#include "stdlib.h"
#include "supportFiles/display.h"
#include "filter.h"
#include "isr.h"
#include "trigger.h"

#define TRANSMITTER_OUTPUT_PIN 13
#define TRANSMITTER_HIGH_VALUE 1
#define TRANSMITTER_LOW_VALUE 0
#define TRANSMITTER_TOTAL_PERIOD 20000 // 200 ms duration pulse
#define TRANSMITTER_PLAYER_0 0x0
#define TRANSMITTER_PLAYER_1 0x1
#define TRANSMITTER_PLAYER_2 0x2
#define TRANSMITTER_PLAYER_3 0x3
#define TRANSMITTER_PLAYER_4 0x4
#define TRANSMITTER_PLAYER_5 0x5
#define TRANSMITTER_PLAYER_6 0x6
#define TRANSMITTER_PLAYER_7 0x7
#define TRANSMITTER_PLAYER_8 0x8
#define TRANSMITTER_PLAYER_9 0x9
#define TRANSMITTER_PLAYER_0_f 11111
#define TRANSMITTER_PLAYER_1_f 13889
#define TRANSMITTER_PLAYER_2_f 17241
#define TRANSMITTER_PLAYER_3_f 20000
#define TRANSMITTER_PLAYER_4_f 22727
#define TRANSMITTER_PLAYER_5_f 26316
#define TRANSMITTER_PLAYER_6_f 29412
#define TRANSMITTER_PLAYER_7_f 33333
#define TRANSMITTER_PLAYER_8_f 35714
#define TRANSMITTER_PLAYER_9_f 38462
#define TRANSMITTER_CLOCK 1000000
#define TRANSMITTER_CONVERT_TICK 50000 // sets the internal tick rate for player frequencies

// Test function #defines
#define TIMER_PERIOD 50.0E-3
#define TIMER_CLOCK_FREQUENCY (XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / 2)
#define TIMER_LOAD_VALUE ((TIMER_PERIOD * TIMER_CLOCK_FREQUENCY) - 1.0)
#define TOTAL_SECONDS 60

enum transmit_st_t {
	init_st,                // Start here, any inits activated.
	transmit_on,			// a '1' is transmitted in this state
	transmit_off,			// a '0' is transmitted in this state
	final_st,   			// waiting for enable signal from outside
} transmitState = init_st;

bool transmitEnable;
uint32_t transmit_total_period;
uint32_t transmit_frequency_period;
uint32_t transmit_tick_count;
bool transmit_ignore_input;
bool transmitFinish;
void transmitter_on() {
//	printf("on \r\n");
	mio_writePin(TRANSMITTER_OUTPUT_PIN, TRANSMITTER_HIGH_VALUE);
}

void transmitter_off() {
//	printf("off\r\n");
	mio_writePin(TRANSMITTER_OUTPUT_PIN, TRANSMITTER_LOW_VALUE);
}

void transmitter_init() {
	transmitEnable = 0;
	transmit_total_period = TRANSMITTER_TOTAL_PERIOD;
	transmit_frequency_period = 0;	// Decide if you want a default player frequency
	transmit_ignore_input =false;
	transmitFinish = true;
	transmitter_setFrequencyNumber(0);

	mio_init(false);
	mio_setPinAsOutput(TRANSMITTER_OUTPUT_PIN);
	transmitter_off();
	buttons_init();

}


bool transmitter_running() {
	return transmitEnable;
}

void transmitter_run() {
	transmitEnable = true;
}


void transmitter_setFrequencyNumber(uint16_t frequencyNumber) {

		switch(frequencyNumber) {
		case TRANSMITTER_PLAYER_0:
			transmit_frequency_period =  44;
//			printf("player 0 - %ld\r\n",transmit_frequency_period);
			break;
		case TRANSMITTER_PLAYER_1:
			transmit_frequency_period =  35;
//			printf("player 1 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_2:
			transmit_frequency_period =  28;
//			printf("player 2 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_3:
			transmit_frequency_period =  24;
//			printf("player 3 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_4:
			transmit_frequency_period =  21;
//			printf("player 4 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_5:
			transmit_frequency_period =  18;
//			printf("player 5 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_6:
			transmit_frequency_period =  16;
//			printf("player 6 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_7:
			transmit_frequency_period =  14;
//			printf("player 7 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_8:
			transmit_frequency_period =  13;
//			printf("player 8 - %ld\r\n",transmit_frequency_period);
				break;
		case TRANSMITTER_PLAYER_9:
			transmit_frequency_period =  12;
//			printf("player 9 - %ld\r\n",transmit_frequency_period);
				break;
		default:
//			printf("invalid input\r\n");
			break;

		}

}

void transmitter_tick() {


	// State actions
	switch(transmitState) {
	case init_st:
//		printf("init\r\n");
		break;
	case transmit_on:
//		printf("1\r\n");
		break;
	case transmit_off:
//		printf("0\r\n");
		break;
	case final_st:
		break;
	default:
		break;
	}

	// State update
	switch(transmitState) {
	case init_st:
		if (transmitEnable) {
			transmitState = transmit_on;
			transmitter_on();	//Implement mio
			transmit_ignore_input = true;
//			printf("firing...\r\n");
//			printf("transmit frequency: %ld \r\n" , transmit_frequency_period);
		}
		else {
			transmitState = init_st;
		}
		break;
	case transmit_on:
		if(transmit_tick_count >= transmit_frequency_period) {
			transmit_tick_count = 0;
			transmitState = transmit_off;
			transmitter_off();	//Implement mio
		}
		else if(transmit_total_period >= TRANSMITTER_TOTAL_PERIOD){
			transmitState = final_st;
//			printf("off\r\n");
			transmit_ignore_input = false;
			transmitter_off();
			transmit_tick_count = 0;
			transmit_total_period = 0;
			transmitEnable = false;
			transmitFinish = true;
		}
		else {
			transmit_tick_count++;
			transmit_total_period++;
//			printf("increment\r\n");
		}
		break;
	case transmit_off:
		if(transmit_tick_count >= transmit_frequency_period) {
			transmit_tick_count = 0;
			transmitState = transmit_on;
			transmitter_on();	//Implement mio
		}
		else if(transmit_total_period >= TRANSMITTER_TOTAL_PERIOD){
			transmitState = final_st;
			transmit_ignore_input = false;
			transmitter_off();
			transmit_tick_count = 0;
			transmit_total_period = 0;
			transmitEnable = false;
//			printf("off\r\n");
			transmitFinish = true;

		}
		else {
			transmit_tick_count++;
			transmit_total_period++;
		}
		break;
	case final_st:
		if(transmitEnable) {
			transmitState = init_st;
			transmitFinish = true;
		}
		else {
			transmitState = final_st;
		}
		break;
	default:
		break;
	}

}

void transmitter_runTest() {
printf("\r\n-----Transmitter Test----\r\n");

	transmitter_init();
	switches_init();
	buttons_init();

	transmitter_setFrequencyNumber(switches_read());

	  // We want to use the interval timers.
	  intervalTimer_initAll();
	  intervalTimer_resetAll();
	  intervalTimer_testAll();
	  printf("Laser Tag Test Program\n\r");
	  // Find out how many timer ticks per second.
	  u32 privateTimerTicksPerSecond = interrupts_getPrivateTimerTicksPerSecond();
	  printf("private timer ticks per second: %ld\n\r", privateTimerTicksPerSecond);
	  // Initialize the GPIO LED driver and print out an error message if it fails (argument = true).
	  // The LD4 LED provides a heart-beat that visually verifies that interrupts are running.
	  leds_init(true);
	  // Init all interrupts (but does not enable the interrupts at the devices).
	  // Prints an error message if an internal failure occurs because the argument = true.
	  interrupts_initAll(true);
	  // Enables the main interrupt on the time.
	  interrupts_enableTimerGlobalInts();
	  // Start the private ARM timer running.
	  interrupts_startArmPrivateTimer();
	  printf("This program will run for %d seconds and print out statistics at the end of the run.\n\r",
		 TOTAL_SECONDS);
	  printf("Starting timer interrupts.\n\r");
	  // Enable global interrupt of System Monitor. The system monitor contains the ADC. Mainly to detect EOC interrupts.
	  interrupts_enableSysMonGlobalInts();
	  // Start a duration timer and compare its timing against the time computed by the timerIsr().
	  // Assume that ENABLE_INTERVAL_TIMER_0_IN_TIMER_ISR is defined in interrupts.h so that time spent in timer-isr is measured.
	  intervalTimer_start(1);
	  int countInterruptsViaInterruptsIsrFlag = 0;
	  // Enable interrupts at the ARM.
	  interrupts_enableArmInts();
	  // Wait until TOTAL seconds have expired. globalTimerTickCount is incremented by timer isr.
	  transmitter_run();

	  while (interrupts_isrInvocationCount() < (TOTAL_SECONDS * privateTimerTicksPerSecond)) {

		  if (interrupts_isrFlagGlobal) {				// If this is true, an interrupt has occured (at least one).
	      countInterruptsViaInterruptsIsrFlag++;	// Note that you saw it.
	      interrupts_isrFlagGlobal = 0;			// Reset the shared flag.

	    }

		  if (transmitFinish) {
				transmitter_setFrequencyNumber(switches_read());
				  transmitter_run();
				  utils_msDelay(500);
		  }

	  }
	  interrupts_disableArmInts();	// Disable ARM interrupts.
	  intervalTimer_stop(1);			// Stop the interval timer.

	  double runningSeconds, isrRunningSeconds;
	  intervalTimer_getTotalDurationInSeconds(1, &runningSeconds);
	  printf("Total run time as measured by interval timer in seconds: %g.\n\r", runningSeconds);
	  intervalTimer_getTotalDurationInSeconds(0, &isrRunningSeconds);
	  printf("Measured run time in timerIsr (using interval timer): %g.\n\r", isrRunningSeconds);
	  printf("Detected interrupts via global flag: %d\n\r", countInterruptsViaInterruptsIsrFlag);
	  printf("During %d seconds, an average of %7.3f ADC samples were collected per second.\n\r",
		 TOTAL_SECONDS, (float) isr_getTotalAdcSampleCount() / (float) TOTAL_SECONDS);
	  printf("\r\n-----End Transmitter Test----\r\n");

}
















