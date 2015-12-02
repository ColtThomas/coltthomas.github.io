/*
 * clockDisplay.c
 *
 *  Created on: Oct 9 , 2014
 *      Author: coltmt
 */

#include "clockDisplay.h"
#include "stdio.h"

#include "supportFiles/display.h"
#include "supportFiles/utils.h"

// Used colors
#define CLOCKDISPLAY_GREEN 0x07E0
#define	CLOCKDISPLAY__BLACK   0x0000
#define CLOCKDISPLAY_YELLOW  0xFFE0

// Display constants for chars and triangle setup
#define CLOCKDISPLAY_DISP_TXT_SIZE 4
#define CLOCKDISPLAY_DISP_X_MAX 320
#define CLOCKDISPLAY_DISP_Y_MAX 240
#define CLOCKDISPLAY_DISP_X_ORIGIN 160
#define CLOCKDISPLAY_DISP_Y_ORIGIN 120
#define CLOCKDISPLAY_DISP_TRIANGLE_0 0
#define CLOCKDISPLAY_DISP_TRIANGLE_1 1
#define CLOCKDISPLAY_DISP_TRIANGLE_2 2
#define CLOCKDISPLAY_DISP_TRIANGLE_3 3
#define CLOCKDISPLAY_DISP_TRIANGLE_4 4
#define CLOCKDISPLAY_DISP_TRIANGLE_5 5
#define CLOCKDISPLAY_CHAR_MOD 3
#define CLOCKDISPLAY_CHAR_WIDTH 6
#define CLOCKDISPLAY_CHAR_HEIGHT 8
#define CLOCKDISPLAY_CHAR_0 0
#define CLOCKDISPLAY_CHAR_1 1
#define CLOCKDISPLAY_CHAR_2 2
#define CLOCKDISPLAY_CHAR_3 3
#define CLOCKDISPLAY_CHAR_4 4
#define CLOCKDISPLAY_CHAR_5 5
#define CLOCKDISPLAY_CHAR_6 6
#define CLOCKDISPLAY_CHAR_7 7

// Constants that handle touchscreen return values
#define CLOCKDISPLAY_DISP_TOUCH_REGION_X 3*CLOCKDISPLAY_CHAR_WIDTH*CLOCKDISPLAY_DISP_TXT_SIZE
#define CLOCKDISPLAY_DISP_TOUCH_REGION_Y 2*CLOCKDISPLAY_CHAR_HEIGHT*CLOCKDISPLAY_DISP_TXT_SIZE
#define CLOCKDISPLAY_X_CURSOR CLOCKDISPLAY_DISP_X_ORIGIN - 4 * CLOCKDISPLAY_CHAR_WIDTH * CLOCKDISPLAY_DISP_TXT_SIZE
#define CLOCKDISPLAY_Y_CURSOR CLOCKDISPLAY_DISP_Y_ORIGIN - (CLOCKDISPLAY_CHAR_HEIGHT* CLOCKDISPLAY_DISP_TXT_SIZE)/2

// RunTest constants
#define CLOCKDISPLAY_RUNTEST_CONST 100
#define CLOCKDISPLAY_ROLL_CONST1 65
#define CLOCKDISPLAY_ROLL_CONST2 50


/*
 *  These are the display chars that will be updated by multiple functions
 *  They will display in format (Hr1 Hr0) : (Min1 Min0) : (Sec1 Sec0)
 */

char Hr0 = '2';
char Hr1 = '1';
char Min0 = '9';
char Min1 = '5';
char Sec0 = '9';
char Sec1 = '5';
char Colon = ':';

// Upper row of triangle touch buttons and coordinates
static uint32_t X0 = CLOCKDISPLAY_DISP_X_ORIGIN - CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH;
static uint32_t Y0 = CLOCKDISPLAY_DISP_Y_ORIGIN - (CLOCKDISPLAY_CHAR_HEIGHT*CLOCKDISPLAY_DISP_TXT_SIZE);
static uint32_t X1 = CLOCKDISPLAY_DISP_X_ORIGIN + CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH;
static uint32_t Y1 = CLOCKDISPLAY_DISP_Y_ORIGIN - (CLOCKDISPLAY_CHAR_HEIGHT*CLOCKDISPLAY_DISP_TXT_SIZE);
static uint32_t X2 = CLOCKDISPLAY_DISP_X_ORIGIN;
static uint32_t Y2 = CLOCKDISPLAY_DISP_Y_ORIGIN - (CLOCKDISPLAY_CHAR_HEIGHT * CLOCKDISPLAY_DISP_TXT_SIZE) - CLOCKDISPLAY_CHAR_WIDTH * CLOCKDISPLAY_DISP_TXT_SIZE;

// Lower row of triangle touch buttons and coordinates
static uint32_t X3 = CLOCKDISPLAY_DISP_X_ORIGIN + CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH;
static uint32_t Y3 = CLOCKDISPLAY_DISP_Y_ORIGIN + (CLOCKDISPLAY_CHAR_HEIGHT*CLOCKDISPLAY_DISP_TXT_SIZE);
static uint32_t X4 = CLOCKDISPLAY_DISP_X_ORIGIN - CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH;
static uint32_t Y4 = CLOCKDISPLAY_DISP_Y_ORIGIN + (CLOCKDISPLAY_CHAR_HEIGHT*CLOCKDISPLAY_DISP_TXT_SIZE);
static uint32_t X5 = CLOCKDISPLAY_DISP_X_ORIGIN;
static uint32_t Y5 = CLOCKDISPLAY_DISP_Y_ORIGIN + (CLOCKDISPLAY_CHAR_HEIGHT * CLOCKDISPLAY_DISP_TXT_SIZE) + CLOCKDISPLAY_CHAR_WIDTH * CLOCKDISPLAY_DISP_TXT_SIZE;

// Gives x coordinate for passed char place
uint32_t clockDisplay_x_char (uint32_t char_place) {
	return CLOCKDISPLAY_X_CURSOR + CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH * char_place;
}

// Gives y coordinate for passed char place
uint32_t clockDisplay_y_char (uint32_t char_place) {
	return CLOCKDISPLAY_Y_CURSOR;
}

// Displays triangle based on passed color and triangle position
void clockDisplay_Triangle(uint8_t num , uint32_t color) {

	switch (num) {
	case 0 :
		display_fillTriangle(X0 - CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y0,X1 - CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y1,X2 - CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y2,color);
		break;
	case 1 :
		display_fillTriangle(X0,Y0,X1,Y1,X2,Y2,color);
		break;
	case 2:
		display_fillTriangle(X0 + CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y0,X1  + CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y1,X2 + CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y2,color);
		break;
	case 3 :
		display_fillTriangle(X3 - CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y3,X4 - CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y4,X5 - CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y5,color);
		break;
	case 4 :
		display_fillTriangle(X3,Y3,X4,Y4,X5,Y5,color);
		break;
	case 5:
		display_fillTriangle(X3 + CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y3,X4  + CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y4,X5 + CLOCKDISPLAY_CHAR_MOD * CLOCKDISPLAY_DISP_TXT_SIZE * CLOCKDISPLAY_CHAR_WIDTH,Y5,color);
		break;
	default:
		printf("error; invalid triangle access");

	}
}

// Clears the clock
void clockDisplay_Clr_Time() {
	Hr0 = '2';
	Hr1 = '1';
	Min0 = '0';
	Min1 = '0';
	Sec0 = '0';
	Sec1 = '0';

}

// Increments the seconds with appropriate rollover
void clockDisplay_IncSec(){
	if (Sec0 == '9') {
		Sec0 = '0';
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_7),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);

		if (Sec1 == '5') {
			Sec1 = '0';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_6),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);

		}
		else {
			Sec1++;
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_6),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
	}
	else {
		Sec0++;
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_7),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	}
}

// Decrements the seconds with appropriate rollover
void clockDisplay_DecSec(){
	if (Sec0 == '0') {
		if (Sec1 == '0') {
			Sec0 = '9';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_7),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			Sec1 = '5';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_6),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
		else {
			Sec1--;
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_6),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			Sec0 = '9';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_7),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
	}
	else {
		Sec0--;
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_7),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	}
}

// Increments the minutes with appropriate rollover
void clockDisplay_IncMin(){
	if (Min0 == '9') {
		Min0 = '0';
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_4),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		if (Min1 == '5') {
			Min1 = '0';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_3),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);

		}
		else {
			Min1++;
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_3),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
	}
	else {
		Min0++;
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_4),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	}
}

// Decrements the minutes with appropriate rollover
void clockDisplay_DecMin(){
	if (Min0 == '0') {
		if (Min1 == '0') {
			Min0 = '9';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_4),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			Min1 = '5';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_3),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);

		}
		else {
			Min1--;
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_3),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			Min0 = '9';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_4),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
	}
	else {
		Min0--;
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_4),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	}
}

// Increments the hours with appropriate rollover
void clockDisplay_IncHr(){
	if (Hr1 == '1') {
		if (Hr0 == '2') {
			Hr1 = ' ';
			Hr0 = '1';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_0),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
		else {
			Hr0++;
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
	}
	else {
		if (Hr0 == '9') {
			if (Hr1 == ' '){
				Hr1 = '0';
			}
			Hr1++;
			Hr0 = '0';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_0),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
		else {
			Hr0++;
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
	}
}

// Decrements the hours with appropriate rollover
void clockDisplay_DecHr(){
	if (Hr0 == '1') {
		if (Hr1 == ' ') {
			Hr0 = '2';
			Hr1 = '1';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_0),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
		else if (Hr1 == '1') {
			Hr0 = '0';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
		else {
			Hr1--;
			if (Hr1 == '0') {
				Hr1 = ' ';
			}
			Hr0 = '9';
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
			display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_0),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		}
	}
	else if (Hr0 == '0') {
		Hr1--;
		if (Hr1 == '0') {
			Hr1 = ' ';
		}
		Hr0 = '9';
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_0),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	}
	else {
		Hr0--;
		display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	}
}

// Returns the coordinates of last touched area
uint8_t clockDisplay_touchedArea() {
	int16_t x = 0;
	int16_t y = 0;
	uint8_t z = 0;
	display_getTouchedPoint(&x,&y,&z);

		display_getTouchedPoint(&x,&y,&z);

		if (y <= 115) {
				if (x <= (int32_t) X0) {
					clockDisplay_IncHr();
				}
				else if ( x >= (int32_t) X1) {
					clockDisplay_IncSec();
				}
				else {
					clockDisplay_IncMin();
				}

		}
		else {
				if (x <= (int32_t) X0) {
					clockDisplay_DecHr();
				}
				else if ( x <= (int32_t) X1) {
					clockDisplay_DecMin();
				}
				else {
					clockDisplay_DecSec();
				}
		}
	x = 0;
	y = 0;
	z = 0;
	return 0;
}

/*
 * Public functions
 */

// Init function
void clockDisplay_init() {
	display_init();  // Must init all of the software and underlying hardware for LCD.
	display_fillScreen(CLOCKDISPLAY__BLACK);  // Blank the screen.
	display_setRotation(true);
	display_setTextColor(CLOCKDISPLAY_GREEN);
	display_setTextSize(CLOCKDISPLAY_DISP_TXT_SIZE);

	clockDisplay_updateTimeDisplay(true);

	// Sets the colons on display; they never change
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_5),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Colon,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_2),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Colon,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);

	clockDisplay_Triangle(CLOCKDISPLAY_DISP_TRIANGLE_0 ,CLOCKDISPLAY_GREEN);
	clockDisplay_Triangle(CLOCKDISPLAY_DISP_TRIANGLE_1 ,CLOCKDISPLAY_GREEN);
	clockDisplay_Triangle(CLOCKDISPLAY_DISP_TRIANGLE_2 ,CLOCKDISPLAY_GREEN);
	clockDisplay_Triangle(CLOCKDISPLAY_DISP_TRIANGLE_3 ,CLOCKDISPLAY_GREEN);
	clockDisplay_Triangle(CLOCKDISPLAY_DISP_TRIANGLE_4 ,CLOCKDISPLAY_GREEN);
	clockDisplay_Triangle(CLOCKDISPLAY_DISP_TRIANGLE_5 ,CLOCKDISPLAY_GREEN);
}

// Updates the time values on clock
void clockDisplay_updateTimeDisplay(bool forceUpdateAll) {
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_0),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_1),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Hr0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_3),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_4),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Min0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_6),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec1,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
	display_drawChar(clockDisplay_x_char (CLOCKDISPLAY_CHAR_7),clockDisplay_y_char (CLOCKDISPLAY_CHAR_0),Sec0,CLOCKDISPLAY_GREEN,CLOCKDISPLAY__BLACK,CLOCKDISPLAY_DISP_TXT_SIZE);
}

// Increments or decrements depending on touched region of display
void clockDisplay_performIncDec() {
	clockDisplay_touchedArea();

}

// Time is advanced one second; rolls over sec -> min -> hr
void clockDisplay_advanceTimeOneSecond() {
	clockDisplay_IncSec();

	if (Sec0 == '0' && Sec1 == '0') {
		clockDisplay_IncMin();

		if (Min0 == '0' && Min1 == '0') {
			clockDisplay_IncHr();

			if (Hr0 == '0' && Hr1 == '0') {
				clockDisplay_Clr_Time();
				clockDisplay_updateTimeDisplay(1);
			}
		}
	}

}

// Test function that verifies the inc/dec function of each clock element and the touch feature
void clockDisplay_runTest() {

	for (uint32_t i = 0 ; i < CLOCKDISPLAY_ROLL_CONST1 ; i++) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_IncSec();
	}

	for (uint32_t i = 0 ; i < CLOCKDISPLAY_ROLL_CONST1 ; i++) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_IncMin();
	}

	for (uint32_t i = 0 ; i < CLOCKDISPLAY_ROLL_CONST1 ; i++) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_IncHr();
	}

	clockDisplay_Clr_Time();
	clockDisplay_updateTimeDisplay(true);


	for (uint32_t i = 0 ; i < CLOCKDISPLAY_ROLL_CONST1 ; i++) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_DecSec();
	}

	for (uint32_t i = 0 ; i < CLOCKDISPLAY_ROLL_CONST1 ; i++) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_DecMin();
	}

	for (uint32_t i = 0 ; i < CLOCKDISPLAY_ROLL_CONST1 ; i++) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_DecHr();
	}

	clockDisplay_Clr_Time();
	clockDisplay_updateTimeDisplay(true);

	for (uint32_t i = 0 ; i < CLOCKDISPLAY_RUNTEST_CONST ; i++) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_advanceTimeOneSecond();
	}

	int16_t x = 0;
	int16_t y = 0;
	uint8_t z = 0;
	uint8_t counter = 0;
	printf("touchscreen test:");
	while(1) {
		utils_msDelay(CLOCKDISPLAY_RUNTEST_CONST);
		clockDisplay_performIncDec();
		display_getTouchedPoint(&x,&y,&z);


		if (display_isTouched()) {
			printf("Coordinates (%u ,",x);
			printf(" %u)",y);
			printf("with pressure %u \n\r",z);
			counter++;
		}
		if (counter == CLOCKDISPLAY_ROLL_CONST2) {
			counter = 0;
		}
		x= 0;
		y= 0;
		z = 0;
	}
}
