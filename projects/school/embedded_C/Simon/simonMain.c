#include "simonDisplay.h"
#include "buttonHandler.h"
#include "flashSequence.h"
#include "verifySequence.h"
#include "simonControl.h"
#include "intervalTimer.h"

#include "stdio.h"
#include "stdint.h"
#include "stdbool.h"
#include "supportFiles/leds.h"
#include "supportFiles/globalTimer.h"
#include "supportFiles/interrupts.h"
#include "supportFiles/display.h"
#include "xparameters.h"
//#include "intervalTimer.h"


#define TIMER_PERIOD 50.0E-3
#define TIMER_CLOCK_FREQUENCY (XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / 2)
#define TIMER_LOAD_VALUE ((TIMER_PERIOD * TIMER_CLOCK_FREQUENCY) - 1.0)
#define TOTAL_SECONDS 20
int main() {
	//buttonHandler_runTest(10);
	//flashSequence_runTest();
	//verifySequence_runTest();



	  // The formula for computing the load value is based upon the formula from 4.1.1 (calculating timer intervals)
	  // in the Cortex-A9 MPCore Technical Reference Manual 4-2.
	  // Assuming that the prescaler = 0, the formula for computing the load value based upon the desired period is:
	  // load-value = (period * timer-clock) - 1

	    // Initialize the GPIO LED driver and print out an error message if it fails (argument = true).
		   // You need to init the LEDs so that LD4 can function as a heartbeat.
	    leds_init(true);
	    // Init all interrupts (but does not enable the interrupts at the devices).
	    // Prints an error message if an internal failure occurs because the argument = true.
	    interrupts_initAll(true);
	    interrupts_setPrivateTimerLoadValue(TIMER_LOAD_VALUE);
	    u32 privateTimerTicksPerSecond = interrupts_getPrivateTimerTicksPerSecond();
	    printf("private timer ticks per second: %ld\n\r", privateTimerTicksPerSecond);
	    // Allow the timer to generate interrupts.
	    interrupts_enableTimerGlobalInts();
	    // Initialization of the Simon game state machines is not time-dependent so we do it outside of the state machine.
		display_init();
		display_fillScreen(DISPLAY_BLACK);
	    // Keep track of your personal interrupt count. Want to make sure that you don't miss any interrupts.
	     int32_t personalInterruptCount = 0;
	    // Start the private ARM timer running.
	    interrupts_startArmPrivateTimer();
	    // Enable interrupts at the ARM.
	    interrupts_enableArmInts();
	    // interrupts_isrInvocationCount() returns the number of times that the timer ISR was invoked.
	    // This value is maintained by the timer ISR. Compare this number with your own local
	    // interrupt count to determine if you have missed any interrupts.


	    double *seconds;


	     while (interrupts_isrInvocationCount() < (TOTAL_SECONDS * privateTimerTicksPerSecond)) {
	      if (interrupts_isrFlagGlobal) {  // This is a global flag that is set by the timer interrupt handler.
	    	  // Count ticks.
	      	personalInterruptCount++;
	      	verifySequence_tick();
	      	flashSequence_tick();
	      	buttonHandler_tick();
	      	intervalTimer_start(1);

	      	simonControl_tick();
	      	intervalTimer_stop(1);
	      	intervalTimer_getTotalDurationInSeconds(1,seconds);
	      	printf("%f \r\n",*seconds);
	      	//printf("interrupt count: %lu \r\n", interrupts_isrInvocationCount());
	      	intervalTimer_reset(1);
	    	  interrupts_isrFlagGlobal = 0;
	      }
	   }
	   interrupts_disableArmInts();
	   printf("isr invocation count: %ld\n\r", interrupts_isrInvocationCount());
	   printf("internal interrupt count: %ld\n\r", personalInterruptCount);

	return 0;
}
