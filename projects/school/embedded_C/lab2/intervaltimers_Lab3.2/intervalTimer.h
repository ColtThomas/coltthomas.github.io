/*
 * intervalTimer.h
 *
 *  Created on: Sep 22, 2014
 *      Author: coltmt
 */

#ifndef INTERVAL_TIMER_H_
#define INTERVAL_TIMER_H_
#include <stdint.h>
#include "xparameters.h"


uint32_t intervalTimer_start(uint32_t timerNumber);
/*
 *	Starts the timer indicated by input parameter
 *	Parameter: 	timerNumber
 *	Returns: 	Boolean true if started
 *				Boolean false if failed to start
 */

uint32_t intervalTimer_stop(uint32_t timerNumber);
/*
 *	Stops the timer indicated by input parameter
 *	Parameter: 	timerNumber
 *	Returns: 	Boolean true if stopped
 *				Boolean false if failed to stop
 */

uint32_t intervalTimer_reset(uint32_t timerNumber);
/*
 *	Resets the timer indicated by input parameter
 *	Parameter: 	timerNumber
 *	Returns: 	Boolean true if reset
 *				Boolean false if failed to reset
 */

uint32_t intervalTimer_init(uint32_t timerNumber);
/*
 *	Initializes the timer indicated by input parameter
 *	Parameter: 	timerNumber
 *	Returns: 	Boolean true if initialized
 *				Boolean false if failed to initialize
 */

uint32_t intervalTimer_initAll();
/*
 *	Initializes all three timers
 *	Returns: 	Boolean true if timers initialized
 *				Boolean false if failed to initialize
 */

uint32_t intervalTimer_resetAll();
/*
 *	Resets all three timers
 *	Returns: 	Boolean true if timers reset
 *				Boolean false if failed to reset
 */

uint32_t intervalTimer_testAll();
/*
 *	Verifies operation of timers
 *	Returns: 	Boolean true if timers passed test
 *				Boolean false if failed test
 *	Comments:	Test results printed in console
 */

uint32_t intervalTimer_runTest(uint32_t timerNumber);
/*
 *	Verifies operation of timer indicated by input parameter
 *	Parameter: 	timerNumber
 *	Returns: 	Boolean true if timers passed test
 *				Boolean false if failed test
 *	Comments:	Test results printed in console
 */
uint32_t intervalTimer_getTotalDurationInSeconds(uint32_t timerNumber, double *seconds);
/*
 * 	Reads the time on the timer registers
 * 	Parameters: timerNumber
 * 				seconds
 * 	Comments: 	seconds passed in by reference and modified in function
 */



#endif
