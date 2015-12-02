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


#define INTERVALTIMER_VALID_TIMER_TRUE 1
#define INTERVALTIMER_VALID_TIMER_FALSE 0

#define INTERVALTIMER_INITIALIZE 0X0
#define	INTERVALTIMER_TCSR0_ADDRESS 0X00
#define	INTERVALTIMER_TLR0_ADDRESS 0X04
#define	INTERVALTIMER_TCR0_ADDRESS 0X08
#define	INTERVALTIMER_TCSR1_ADDRESS 0X10
#define	INTERVALTIMER_TLR1_ADDRESS 0X14
#define	INTERVALTIMER_TCR1_ADDRESS 0X18
#define	INTERVALTIMER_CASC_BIT 0X0800
#define	INTERVALTIMER_LOAD_BIT 0X20
#define INTERVALTIMER_LOAD_CLEAR_BIT 0X00
#define	INTERVALTIMER_ENT0_BIT 0X0080
#define INTERVALTIMER_ENT0_CLEAR_BIT 0x00

//#define	INTERVALTIMER_


uint32_t intervalTimer_start(uint32_t timerNumber);
uint32_t intervalTimer_stop(uint32_t timerNumber);
uint32_t intervalTimer_reset(uint32_t timerNumber);
uint32_t intervalTimer_init(uint32_t timerNumber);


uint32_t intervalTimer_initAll();
uint32_t intervalTimer_resetAll();
uint32_t intervalTimer_testAll();
uint32_t intervalTimer_runTest(uint32_t timerNumber);
uint32_t intervalTimer_getTotalDurationInSeconds(uint32_t timerNumber, double *seconds);



#endif
