/*
 * lockoutTimer.c

 *
 *  Created on: Mar 4, 2015
 *      Author: coltmt
 */
#include "lockoutTimer.h"
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


#define TOTAL_SECONDS 3
#define LOCKOUTTIMER_PERIOD 50000

enum lockout_st_t {
	idle_st,                // Start here, any inits activated.
	run_st
} lockoutState = idle_st;

uint32_t lockoutTimerCount;
//volatile static bool lockoutEnable;
volatile static bool lockoutRunning;

// Standard init function.
void lockoutTimer_init(){
	lockoutTimerCount = 0;
//	lockoutEnable = false;
	lockoutRunning = false;

}

// Calling this starts the timer.
void lockoutTimer_start(){
	lockoutRunning = true;
//	printf("start\r\n");
}

// Returns true if the timer is running.
bool lockoutTimer_running(){
	return lockoutRunning;
}

// Standard tick function.
void lockoutTimer_tick() {
	//State actions
	switch(lockoutState) {
		case idle_st:
			break;
		case run_st:
			break;
		}
		//Transition State conditions
		switch(lockoutState) {
		case idle_st:
			if(lockoutRunning) {
				lockoutState = run_st;
				lockoutRunning = true;
			}
			break;
		case run_st: {
			if(lockoutTimerCount >= LOCKOUTTIMER_PERIOD) {
				lockoutState = idle_st;
				lockoutRunning = false;
//				printf("ohai\r\n");
				lockoutTimerCount = 0;
			}
			lockoutTimerCount++;
			break;
		}

		}
}
void lockoutTimer_runTest() {
	printf("\r\n-----Lockout Timer Test-----\r\n");

	lockoutTimer_init();

	static uint32_t timer = 1;

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


    intervalTimer_reset(timer);
    intervalTimer_start(timer);
    lockoutTimer_start();
    while(lockoutTimer_running()){}
    intervalTimer_stop(timer);			// Stop the interval timer.



    	  interrupts_disableArmInts();	// Disable ARM interrupts.

    	  double runningSeconds, isrRunningSeconds;
    	  intervalTimer_getTotalDurationInSeconds(1, &runningSeconds);
    	  printf("Total run time as measured by interval timer in seconds: %g.\n\r", runningSeconds);
    	  intervalTimer_getTotalDurationInSeconds(0, &isrRunningSeconds);
    	  printf("Measured run time in timerIsr (using interval timer): %g.\n\r", isrRunningSeconds);
    	  printf("Detected interrupts via global flag: %d\n\r", countInterruptsViaInterruptsIsrFlag);
    	  printf("During %d seconds, an average of %7.3f ADC samples were collected per second.\n\r",
    		 TOTAL_SECONDS, (float) isr_getTotalAdcSampleCount() / (float) TOTAL_SECONDS);
    		printf("\r\n-----End Lockout Timer Test-----\r\n");

}

