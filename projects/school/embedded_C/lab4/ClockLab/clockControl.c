/*
 * clockControl.c
 *
 *  Created on: Oct 9 , 2014
 *      Author: coltmt
 */

#include "clockControl.h"
#include "clockDisplay.h"
#include "stdio.h"
#include "supportFiles/display.h"
#include "supportFiles/utils.h"

#define CLKCTRL_IMAX 100
#define CLKCTRL_AUTOTIMER_INC 500
#define CLKCTRL_EXPIRED_VALUE 5000
enum ClkStates {init_st ,touch_start_st, waiting_for_touch_st , ad_timer_running_st, auto_timer_running_st, rate_timer_running_st, rate_timer_expired_st} ClkState;


/*
 *  Timer initialization values; these are set to allow the
 *  timer to auto-increment at a rate of 10x per second after holding
 *  for .5 seconds.
 */

uint32_t adTimer;
uint32_t rateTimer;
uint32_t autoTimer;


// increment counter for function clockDisplay_advanceTimeOneSecond()
uint8_t i = 0;

void clockControl_tick() {

	/*
	 * Below is the implementation of our state machine ClkStates.
	 * Note that there is an added state called touch_start_st.  This
	 * is added in addition to the init state to await the initial
	 * touch of the display before incrementing.
	 *
	 * Another functionality that I added was in the waiting_for_touch_st.
	 * A counter i increments to 100 before calling the advanceTimeOneSecond()
	 * function.  This allows the timer to increment every second.
	 *
	 * See the lab 4 description for an illustration of the state machine
	 */

	switch(ClkState) {


		// All states are explicitly shown in the case statements
		// Assigning ClkState indicates a state change
		case(init_st):
				ClkState = touch_start_st;
			break;
		case(touch_start_st):		//Added state waits for first touch

				// Transitions when display is touched
				if (display_isTouched()) {
					ClkState = waiting_for_touch_st;
				}

			break;
		case(waiting_for_touch_st):
				// All timers reset to zero, and i increments
				adTimer = 0;
				autoTimer = 0;
				rateTimer = 0;
				i++;

				// This added if statement waits 1 second to increment using counter i
				if ( i == CLKCTRL_IMAX) {
					clockDisplay_advanceTimeOneSecond();
					i=0;
				}

				// Transitions when display is touched
				if(display_isTouched()) {
					display_clearOldTouchData();
					ClkState = ad_timer_running_st;
				}

			break;
		case(ad_timer_running_st):
				// adTimer incremented as Moore action
				adTimer = adTimer + CLKCTRL_EXPIRED_VALUE;

				// If user continues holding display, transiton auto increment state
				if (display_isTouched() && adTimer == CLKCTRL_EXPIRED_VALUE) {
					ClkState = auto_timer_running_st;
				}

				// If display tapped, one increment/decrement will occur as Mealy
				else if (!display_isTouched() && adTimer == CLKCTRL_EXPIRED_VALUE) {
					clockDisplay_performIncDec();
					ClkState = waiting_for_touch_st;
				}

			break;
		case(auto_timer_running_st):
				// autoTimer incremented
				autoTimer = autoTimer + CLKCTRL_AUTOTIMER_INC;

				// Increment ceases as display released
				if (!display_isTouched()) {
					clockDisplay_performIncDec();
					ClkState = waiting_for_touch_st;
				}

				// Waits for .5 seconds before auto inc/dec state transitions
				else if (display_isTouched() && autoTimer == CLKCTRL_EXPIRED_VALUE) {
					clockDisplay_performIncDec();
					ClkState = rate_timer_running_st;
				}

			break;
		case(rate_timer_running_st):
				// Controls the auto increment timing to 10x a second
				rateTimer = rateTimer + CLKCTRL_AUTOTIMER_INC ;

				// Stops increment as display is released
				if (!display_isTouched()) {
					clockDisplay_performIncDec();
					ClkState = waiting_for_touch_st;
				}

				// Loop that continues increment
				else if (display_isTouched() && rateTimer == CLKCTRL_EXPIRED_VALUE) {
					ClkState = rate_timer_expired_st;
				}

			break;
		case(rate_timer_expired_st):
				// rateTimer reset to control transition rate
				rateTimer = 0;

				// Loop that continues increment
				if (display_isTouched()) {
					clockDisplay_performIncDec();
					ClkState = rate_timer_running_st;
				}

				// Stops increment as display is released
				else if (!display_isTouched()) {
					ClkState = waiting_for_touch_st;
				}

			break;
		default:

			break;


	}
}
