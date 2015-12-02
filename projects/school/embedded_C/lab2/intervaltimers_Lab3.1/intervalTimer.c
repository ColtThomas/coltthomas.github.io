/*
 * intervalTimer.c
 *
 *  Created on: Sep 22, 2014
 *      Author: coltmt
 */


#include "stdio.h"
#include "intervalTimer.h"
#include "xil_io.h"
#include <stdio.h>

uint32_t intervalTimer_isValid(uint32_t timerNumber) {

	switch (timerNumber) {
	case 0:
		printf("accessing timer 0... \n");
		return INTERVALTIMER_VALID_TIMER_TRUE;
		break;

	case 1:
		printf("accessing timer 1... \n");
		return INTERVALTIMER_VALID_TIMER_TRUE;
		break;

	case 2:
		printf("accessing timer 2... \n");
		return INTERVALTIMER_VALID_TIMER_TRUE;
		break;

	default:
		printf("error; invalid timer access \n");
		return INTERVALTIMER_VALID_TIMER_FALSE;
		break;
	}
}

uint32_t intervalTimer_xor_bit(uint32_t initialBit, uint32_t modBit) {
	uint32_t returnBit = initialBit ^ modBit;
	return returnBit;
}


uint32_t intervalTimer_start(uint32_t timerNumber) {
	if (intervalTimer_isValid(timerNumber)) {

		uint32_t tempBit = Xil_In32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS);

		tempBit = tempBit | INTERVALTIMER_ENT0_BIT;

		Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , tempBit);



		/*
		printf("start activated....\n");
		Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TLR0_ADDRESS, INTERVALTIMER_INITIALIZE);
		Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS, INTERVALTIMER_LOAD_BIT);
		printf("%p\n" , (u32 *) Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS));

		uint32_t bitModder = Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS);

		bitModder = bitModder | INTERVALTIMER_ENT0_BIT;
		//Xil_Out32( Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS) , Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS) |  );
		//uint32_t placeHolder = Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS);
		//intervalTimer_xor_bit(placeHolder , )


		Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS, bitModder);
		printf("%p\n" , (u32 *) Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS));
		*/
	}

	return 0;
}
uint32_t intervalTimer_stop(uint32_t timerNumber){
	intervalTimer_isValid(timerNumber);

	// This sets the ENT0 bit to 0 and stops the timer
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , INTERVALTIMER_ENT0_CLEAR_BIT);
	return 0;
}
uint32_t intervalTimer_reset(uint32_t timerNumber) {
	intervalTimer_isValid(timerNumber);

	// Write a 0 into the TLR0 and TLR1 registers
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TLR0_ADDRESS , INTERVALTIMER_INITIALIZE);
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TLR1_ADDRESS , INTERVALTIMER_INITIALIZE);

	// Write a 1 into the LOAD0 and LOAD1 bits of the TCSR0 and TCSR1 register

	uint32_t startZeroA = Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS);
	uint32_t startZeroB = Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS);

	startZeroA = startZeroA | INTERVALTIMER_LOAD_BIT;
	startZeroB = startZeroB | INTERVALTIMER_LOAD_BIT;

	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , startZeroA);
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS , startZeroB);

	// Write a 0 back into the LOAD0 and LOAD1 registers so they stop loading 0 consistently

	uint32_t startOneA = Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS);
	uint32_t startOneB = Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS);

	startOneA = startOneA | INTERVALTIMER_LOAD_CLEAR_BIT;
	startOneB = startZeroB | INTERVALTIMER_LOAD_CLEAR_BIT;

	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , startOneA);
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS , startOneB);

	intervalTimer_init(timerNumber);




	/*
	// For counter 0 reset
	Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TLR0_ADDRESS, INTERVALTIMER_INITIALIZE);
	Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS, INTERVALTIMER_LOAD_BIT);



	// For counter 1 reset
	Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TLR1_ADDRESS, INTERVALTIMER_INITIALIZE);
	Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS, INTERVALTIMER_LOAD_BIT);

	 */
	//Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , INTERVALTIMER_LOAD_CLEAR_BIT);
		//Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS , INTERVALTIMER_LOAD_CLEAR_BIT);
	//Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , INTERVALTIMER_LOAD_BIT);
	//Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS , INTERVALTIMER_LOAD_BIT);
	return 0;
}
uint32_t intervalTimer_init(uint32_t timerNumber) {

	//we first check to see if the timer is valid
	intervalTimer_isValid(timerNumber);

	// Write a 0 to the TCSR0 bit
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , INTERVALTIMER_INITIALIZE);
	// Write a 0 to the TCSR1 bit
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS , INTERVALTIMER_INITIALIZE);
	// Set CASC bit to 1 in the TCSR0 register
	Xil_Out32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS , INTERVALTIMER_CASC_BIT);
	//Clear UDT0 bit in the TCSR0 register is done by default when 0 is written


	// We set the initial timer value to zero
	//intervalTimer_reset(timerNumber);










	/*
	//this initializes the TCSR0 and TCSR1 registers
	Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS, INTERVALTIMER_INITIALIZE);
	Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS, INTERVALTIMER_INITIALIZE);


	printf("here comes the mess: ");
	printf("%p\n" , (u32 *) Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS));   //this is how you check the value of a bit

	if (Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS) != INTERVALTIMER_INITIALIZE) {
		printf("son of a gun, it didn't initialize TCSR0!");
		return 0;
	}

	if (Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR1_ADDRESS) != INTERVALTIMER_INITIALIZE) {
			printf("son of a gun, it didn't initialize TCSR1!");
			return 0;
	}

	//this is supposed to set the CASC bit to 1
	Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS, INTERVALTIMER_CASC_BIT);
	//u32 *tcsr0 = (u32 *) Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS);  //This is used to see the value at the selected bit

	printf("after the change: ");
	printf("%p\n" , (u32 *) Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS));  //this is how you check the value of a bit
	//Xil_Out32( XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_CASC_BIT, INTERVALTIMER_INITIALIZE);

	if (Xil_In32(XPAR_AXI_TIMER_0_BASEADDR + INTERVALTIMER_TCSR0_ADDRESS) != INTERVALTIMER_CASC_BIT) {
			printf("son of a gun, THAT CASC BIT WASN'T SET!");
			return 0;
	}
	//this is where I want to set the UDT0 bit																													<------------------------------------How to set both CASC and UDT0

	*/

	return 0;
}
