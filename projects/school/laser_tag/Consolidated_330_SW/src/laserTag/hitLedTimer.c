/*
 * hitLedTimer.c
 *
 *  Created on: Mar 4, 2015
 *      Author: coltmt
 */
#include "hitLedTimer.h"
#include <stdio.h>
#include "supportFiles/leds.h"
#include "supportFiles/globalTimer.h"
#include "supportFiles/interrupts.h"
#include "supportFiles/intervalTimer.h"
#include "supportFiles/buttons.h"
#include "supportFiles/switches.h"
#include <stdbool.h>
#include <stdlib.h>
#include "isr.h"
#include "supportFiles/utils.h"
#include "supportFiles/mio.h"
#define TOTAL_SECONDS 20
#define HITLED_ACTIVATE 0x1
#define HITLED_PERIOD 20000
#define ALL_LEDS_OFF 0X0
#define LED_OUTPUT_PIN 11
enum hitLed_st_t {
	idle_st,                // Start here, any inits activated.
	run_on_st,
	run_off_st
} hitLedState = idle_st;

uint32_t timerCount;
bool hitLedRunning;

// Need to init things.
void hitLedTimer_init() {
	timerCount = 0;
	hitLedRunning = false;
	mio_init(false);
	mio_setPinAsOutput(LED_OUTPUT_PIN);
}

// Calling this starts the timer.
void hitLedTimer_start() {
	hitLedRunning = true;

}

// Returns true if the timer is currently running.
bool hitLedTimer_running() {
	return hitLedRunning;

}

// Standard tick function.
void hitLedTimer_tick() {
	//State actions
	switch(hitLedState) {
		case idle_st:
			break;
		case run_on_st:
			break;
		case run_off_st:
			break;
		}
	//Transition State conditions
	switch(hitLedState) {
		case idle_st:
			// hitLedRunning acts as the enable for state machine
			if(hitLedRunning) {
				hitLedState = run_on_st;
				leds_write(HITLED_ACTIVATE);	// hitLed turns on
				hitLedRunning = true;
			}
			break;
		case run_on_st:
			if(timerCount >= HITLED_PERIOD) {
				hitLedState = run_off_st;
				timerCount =0;
				leds_write(ALL_LEDS_OFF);
				mio_writePin(LED_OUTPUT_PIN, 1);  //off

				hitLedRunning = false;
			}
				timerCount++;

			break;
		case run_off_st: {
			if(timerCount >= HITLED_PERIOD) {
				hitLedState = idle_st;
				timerCount =0;
				leds_write(ALL_LEDS_OFF);
				mio_writePin(LED_OUTPUT_PIN, 0);

				hitLedRunning = false;
			}
				timerCount++;

			break;
			}
	}

}



void hitLedTimer_runTest() {
	printf("\r\n-----HitLed Timer Test-----\r\n");
	hitLedTimer_init();

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

	  int countInterruptsViaInterruptsIsrFlag = 0;
	  // Enable interrupts at the ARM.
	  interrupts_enableArmInts();
	  intervalTimer_start(1);
	  // Wait until TOTAL seconds have expired. globalTimerTickCount is incremented by timer isr.
	  while (interrupts_isrInvocationCount() < (TOTAL_SECONDS * privateTimerTicksPerSecond)) {
	    if (interrupts_isrFlagGlobal) {				// If this is true, an interrupt has occured (at least one).
	      countInterruptsViaInterruptsIsrFlag++;	// Note that you saw it.
	      interrupts_isrFlagGlobal = 0;			// Reset the shared flag.
	      // Place non-timing critical code here.
		  hitLedTimer_start();
	      while(hitLedTimer_running()) {}
	      utils_msDelay(300);
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
	  printf("\r\n-----End HitLed Timer Test-----\r\n");
}
