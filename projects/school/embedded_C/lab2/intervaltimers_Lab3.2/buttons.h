/*
 * buttons.h
 *
 *  Created on: Sept 16, 2014
 *      Author: Colt Thomas
 */

#ifndef BUTTONS_H_
#define BUTTONS_H_
#include <stdint.h>
#include "xparameters.h"

//constants used to indicate init status
#define BUTTONS_INIT_STATUS_OK 1
#define BUTTONS_INIT_STATUS_FAIL 0

//color values and other constants for the display
#define BUTTONS_YELLOW 0xFFE0
#define BUTTONS_RED 0xF800
#define BUTTONS_CIRCLE_RADIUS 50
#define BUTTONS_MIN_X 0						// The minimum specified x coordinate for display (default is 0)
#define BUTTONS_MIN_Y 0						// The minimum specified y coordinate for display (default is 0)
#define BUTTONS_MAX_X 320					// The maximum specified x coordinate for display (default is 320)
#define BUTTONS_MAX_Y 240					// The maximum specified y coordinate for display (default is 240)
#define BUTTONS_TEXT_SIZE 2

// These constants access the specified bit value
#define 	BUTTONS_ISOLATE_BIT_B0  0x1
#define 	BUTTONS_ISOLATE_BIT_B1 0x2
#define 	BUTTONS_ISOLATE_BIT_B2  0x4
#define 	BUTTONS_ISOLATE_BIT_B3  0x8

// These are used to access and enable the tristate driver
#define BUTTON_OFFSET 0x4
#define BUTTON_TRISTATE_SET 0xF
#define BUTTON_ISOLATE_BITS 0xF

// Initializes the button driver software and hardware. Returns one of the defined status values (above).
int buttons_init();

// Returns the current value of all 4 buttons as the lower 4 bits of the returned value.
// bit3 = BTN3, bit2 = BTN2, bit1 = BTN1, bit0 = BTN0.
int32_t buttons_read();

// Runs a test of the buttons. As you push the buttons, graphics and messages will be written to the LCD
// panel. The test will until all 4 pushbuttons are simultaneously pressed.
void buttons_runTest();

#endif
