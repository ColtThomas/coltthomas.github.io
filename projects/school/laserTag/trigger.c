/*
 * trigger.c
 *
 *  Created on: Mar 4, 2015
 *      Author: coltmt
 */

#include "trigger.h"
#include "transmitter.h"
#include "supportFiles/buttons.h"
#include "supportFiles/mio.h"
#include <stdio.h>

#include "queue.h"
#include "supportFiles/leds.h"
#include "supportFiles/globalTimer.h"
#include "supportFiles/interrupts.h"
#include "supportFiles/intervalTimer.h"
#include "supportFiles/buttons.h"
#include "supportFiles/switches.h"
#include <stdbool.h>
#include <stdlib.h>
#include "supportFiles/display.h"
#include "filter.h"
#include "isr.h"
#include "transmitter.h"
#include "trigger.h"
#include "supportFiles/switches.h"

#define TOTAL_SECONDS 20

#define TRIGGER_DEBOUNCE 50 //debounce time
#define TRIGGER_SAFETY 10 // Safety timer between the transmit on and off function calls
#define TRIGGER_GUN_TRIGGER_MIO_PIN 10
#define GUN_TRIGGER_PRESSED 1
enum trigger_st_t {
	trig_wait_st,                // Start here, any inits activated.
	trig_debounce_press,
	trig_debounce_release,
	trig_register_release,
	trig_hold
} triggerState = trig_hold;


uint32_t trig_timer;
uint32_t trig_on_safety;
bool trig_enable;
bool ignoreGunInput;
// Returns true if button 0 is pressed
bool trigger_pulled() {



	return ((!ignoreGunInput & (mio_readPin(TRIGGER_GUN_TRIGGER_MIO_PIN) == GUN_TRIGGER_PRESSED)) ||
            (buttons_read() & BUTTONS_BTN0_MASK));
}

// Init trigger data-structures.
void trigger_init() {
	printf("initiallizing the trigger\r\n");
	trig_timer = 0;
	trig_on_safety = 0;
	ignoreGunInput = false;

	buttons_init();
	mio_init(true);

	// Inits the mio and if there is a floating ground, we ignore the trigger input
	mio_init(false);
	mio_setPinAsInput(TRIGGER_GUN_TRIGGER_MIO_PIN);

	if ((!ignoreGunInput & (mio_readPin(TRIGGER_GUN_TRIGGER_MIO_PIN) == GUN_TRIGGER_PRESSED))) {
		printf("trigger read\r\n");
	}




	if(trigger_pulled()) {
		ignoreGunInput = true;
		printf("ignoring trigger\r\n");
	}

}



// Enable the trigger state machine. The state-machine does nothing until it is enabled.
void trigger_enable() {
	trig_enable=true;
//	printf("enabled\r\n");
}

// Standard tick function.
void trigger_tick() {
//	printf("tick tock\r\n");
	// State actions
	switch(triggerState) {
	case trig_wait_st:
		break;
	case trig_debounce_press:

		break;
	case trig_debounce_release:

		break;
	case trig_register_release:

		break;
	case trig_hold:
		break;
	}

	// State update
	switch(triggerState) {
	case trig_wait_st:
//		printf("waiting\r\n");
		if(trigger_pulled()) {
			triggerState = trig_debounce_press;
//			printf("to debounce\r\n");
		}
		else {
			triggerState = trig_wait_st;
		}
		break;
	case trig_debounce_press:
		if(!trigger_pulled() ){
			triggerState = trig_wait_st;
//			printf("back to wait\r\n");
		}
		if(trigger_pulled()&&(trig_timer < TRIGGER_DEBOUNCE)) {
			triggerState = trig_debounce_press;
		}
		if( trigger_pulled()&&(trig_timer > TRIGGER_DEBOUNCE) ) {
			triggerState = trig_debounce_release;
			transmitter_run();

			printf("D\r\n");

			trig_timer = 0;
		}
		trig_timer++;

		break;
	case trig_debounce_release:
		if(!trigger_pulled()) {
			triggerState = trig_register_release;
//			printf("trigger released\r\n");
		}
		break;
	case trig_register_release:
		if(trigger_pulled() ){
			triggerState = trig_debounce_release;
		}
		else if(!trigger_pulled()&&(trig_timer < TRIGGER_DEBOUNCE)) {
			triggerState = trig_register_release;
			trig_timer++;
		}
		else if( !trigger_pulled()&&(trig_timer > TRIGGER_DEBOUNCE) ) {
			triggerState = trig_hold;
			trig_timer = 0;
			printf("U\r\n");
		}
		else {
			triggerState = trig_register_release;
			trig_timer++;
		}
		break;
	case trig_hold:
		if(trig_enable) {
			triggerState = trig_wait_st;
//			printf("to wait\r\n");
		}
		else {
			triggerState = trig_hold;
		}
		break;
	}
}

void trigger_runTest() {
	printf("\r\n-----Trigger Run Test-----\r\n");

	isr_init();

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
	  printf("start loop\r\n");
	  while (interrupts_isrInvocationCount() < (TOTAL_SECONDS * privateTimerTicksPerSecond)) {
//		  printf("count: %ld\r\n",interrupts_isrInvocationCount());
		  if (interrupts_isrFlagGlobal) {				// If this is true, an interrupt has occured (at least one).
	      countInterruptsViaInterruptsIsrFlag++;	// Note that you saw it.
	      interrupts_isrFlagGlobal = 0;			// Reset the shared flag.
		  trigger_enable();

	    }


	  }
	  printf("end\r\n");
	  interrupts_disableArmInts();	// Disable ARM interrupts.
	  intervalTimer_stop(1);			// Stop the interval timer.

	printf("\r\n-----End Trigger Run Test-----\r\n");

}

