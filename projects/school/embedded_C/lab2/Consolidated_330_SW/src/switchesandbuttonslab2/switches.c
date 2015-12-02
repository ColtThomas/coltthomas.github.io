#include "stdio.h"
#include "xil_io.h"
#include "switches.h"
#include "supportFiles/leds.h"

// Initializes the SWITCHES driver software and hardware. Returns one of the STATUS values defined above.
int switches_init() {
	 Xil_Out32(XPAR_GPIO_SLIDE_SWITCHES_BASEADDR + 0x4, 0xF);	//uses a function from xil_io.h to allow switches to be used
	return SWITCHES_INIT_STATUS_OK;
}

// Returns the current value of all 4 SWITCHESs as the lower 4 bits of the returned value.
// bit3 = SW3, bit2 = SW2, bit1 = SW1, bit0 = SW0.
int32_t switches_read() {


	/*
	 * Xil_In32() returns the address of the slide switches and does bitwise operation & 0xF to return the last four bits
	 * of the switches.  When the bit = 1, the correlating switch is high; when the bit = 0, the correlating switch is low.
	 */


	return Xil_In32(XPAR_GPIO_SLIDE_SWITCHES_BASEADDR) & 0xF;
}

// Runs a test of the switches. As you slide the switches, LEDs directly above the switches will illuminate.
// The test will run until all switches are slid upwards. When all 4 slide switches are slid upward,
// this function will return.
void switches_runTest(){
	switches_init();
	leds_init(true);	// The LEDs are initialized.  We pass in true to indicate we don't want status messages printed.

	/*
	 * 	This while loop will continue to write the value of the switches to the LEDs until all four are put up at once.
	 * 	This occurs when the last four bits are 1111 which is decimal equivalent of 15, hence SWITCH_MAX_VALUE = 15.
	 */
	while(switches_read() < SWITCH_MAX_VALUE){
		leds_write(switches_read());	// Writes corresponding switch values to the LEDs.
	}

	leds_write(0x0000);	// Puts out the LEDs after the test

}
