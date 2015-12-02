#include "simonControl.h"
#include "flashSequence.h"
#include "simonDisplay.h"
#include "globals.h"
#include "verifySequence.h"
#include "supportFiles/display.h"
#include "buttons.h"
#include "stdbool.h"
#include "stdio.h"
#include "stdlib.h"




#define SIMONCONTROL_MSG_DISPLAY_TIME 40	// Message duration
#define SIMONCONTROL_MSG_DISPLAY_INIT 0		// Initiates message duration
#define SIMONCONTROL_SEQ_INIT 4				// Initial max sequence
#define SIMONCONTROL_SEQ_MAX 255			// Sequence max
#define SIMONCONTROL_SEQ_INDX 0				// Initiation for sequence
#define SIMONCONTROL_SEQ_CAP 4				// Default sequence cap
#define SIMONCONTROL_TEXT4 4				// Text size
#define SIMONCONTROL_TEXT2 2				// Text size

// Constants for message cursor coordinates
#define SIMONCONTROL_MSG_X (display_height()/4)
#define SIMONCONTROL_MSG_Y (display_width()/4)
#define SIMONCONTROL_MSG_START_X (display_height()/4) + SIMONCONTROL_TEXT4 * 9
#define SIMONCONTROL_MSG_START_Y (display_width()/4)
#define SIMONCONTROL_MSG_START_X2 (display_height()/4)
#define SIMONCONTROL_MSG_START_Y2 (display_width()/4) + SIMONCONTROL_TEXT4 * 10
#define SIMONCONTROL_ERASE true

// Constants for display clearing
#define SIMONCONTROL_BUTTONHEIGHT (display_height()/6)
#define SIMONCONTROL_BUTTONWIDTH (display_height()/6)
#define SIMONCONTROL_XLEFT	(display_width()/4)-(SIMONCONTROL_BUTTONWIDTH/2)
#define SIMONCONTROL_XRIGHT (3*display_width()/4)-(SIMONCONTROL_BUTTONWIDTH/2)
#define SIMONCONTROL_YBOTTOM	(3*display_height()/4)-(SIMONCONTROL_BUTTONWIDTH/2)
#define SIMONCONTROL_YTOP	(display_height()/4)-(SIMONCONTROL_BUTTONWIDTH/2)
#define SIMONCONTROL_SEQ_RESULT_X 85*SIMONCONTROL_TEXT2 + SIMONCONTROL_MSG_X
// State machine declaration
enum simonControl_st_t {
	init_st,							// Start here, any inits activated.
	wait_for_touch_st,                 	// Main state; waits for touch to start
	wait_for_sequence_st,			   	// State waits for sequence to flash
	wait_for_user_st,					// State waits for user input
	iteration_check_st,					// State verifies if user finished sequence
	msg_win_st,							// Win message displayed
	new_level_st,						// Verifies if user wishes to continue
	msg_slow_st,						// Shows message if user is too slow
	msg_wrong_st,						// Shows message if input is incorrect
	msg_result_st,						// Shows the max sequence attained
} simonControl_st = init_st;

// Variables are used for iterative operations, and the sequence
uint16_t iterateSequence;
uint16_t messageDisplay;
uint16_t sequenceIndex;
uint16_t sequenceCap;
uint8_t sequenceMain[SIMONCONTROL_SEQ_MAX];

uint8_t simonControl_randMod4() {
	return rand() % 4;	// Random number generated to add random sequence square
}

// Specifically clears the button squares in transitions
void simonControl_clearDisplay() {
	display_fillRect(SIMONCONTROL_XLEFT, SIMONCONTROL_YBOTTOM, SIMONCONTROL_BUTTONWIDTH, SIMONCONTROL_BUTTONHEIGHT, DISPLAY_BLACK);
	display_fillRect(SIMONCONTROL_XLEFT, SIMONCONTROL_YTOP, SIMONCONTROL_BUTTONWIDTH, SIMONCONTROL_BUTTONHEIGHT, DISPLAY_BLACK);
    display_fillRect(SIMONCONTROL_XRIGHT,SIMONCONTROL_YTOP, SIMONCONTROL_BUTTONWIDTH, SIMONCONTROL_BUTTONHEIGHT, DISPLAY_BLACK);
	  display_fillRect(SIMONCONTROL_XRIGHT, SIMONCONTROL_YBOTTOM, SIMONCONTROL_BUTTONWIDTH, SIMONCONTROL_BUTTONHEIGHT, DISPLAY_BLACK);
}

// Win display message
void simonControl_winDisplay() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_WHITE);
    display_println("You won... for now.");
}

// Win display message clear
void simonControl_winDisplayClear() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_BLACK);
    display_println("You won... for now.");
}

// New level inquiry display message
void simonControl_newLevelDisplay() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_WHITE);
    display_println("Touch to level up");
}

// New level inquiry display message clear
void simonControl_newLevelDisplayClear() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_BLACK);
    display_println("Touch to level up");
}

// Slow display message
void simonControl_slowDisplay() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_WHITE);
    display_println("Wow, much slow");
}

// Slow display message clear
void simonControl_slowDisplayClear() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_BLACK);
    display_println("Wow, much slow");
}


// Sequence error message
void simonControl_errorDisplay() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_WHITE);
    display_println("Incorrect Sequence");
}


// Sequence error message clear
void simonControl_errorDisplayClear() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_BLACK);
    display_println("Incorrect Sequence");
}

// Max sequence message
void simonControl_MaxSeqDisplay() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_WHITE);
    display_println("Max Sequence:");
    display_setCursor(SIMONCONTROL_SEQ_RESULT_X, SIMONCONTROL_MSG_Y);
    display_println(sequenceIndex);
}

// Max sequence message clear
void simonControl_MaxSeqDisplayClear() {
	display_setTextSize(SIMONCONTROL_TEXT2);
	display_setCursor(SIMONCONTROL_MSG_X, SIMONCONTROL_MSG_Y);
    display_setTextColor(DISPLAY_BLACK);
    display_println("Max Sequence:");
    display_setCursor(SIMONCONTROL_SEQ_RESULT_X, SIMONCONTROL_MSG_Y);
    display_println(sequenceIndex);
}

// Initial message
void simonControl_WaitTouchDisplay() {
	display_setTextSize(SIMONCONTROL_TEXT4);
	display_setCursor(SIMONCONTROL_MSG_START_X, SIMONCONTROL_MSG_START_Y);
    display_setTextColor(DISPLAY_WHITE);
    display_println("SIMON");
    display_setTextSize(SIMONCONTROL_TEXT2);
    display_setCursor(SIMONCONTROL_MSG_START_X2, SIMONCONTROL_MSG_START_Y2);
    display_println("poke me to start");
}

// Initial message clear
void simonControl_WaitTouchDisplayClear() {
	display_setTextSize(SIMONCONTROL_TEXT4);
	display_setCursor(SIMONCONTROL_MSG_START_X, SIMONCONTROL_MSG_START_Y);
    display_setTextColor(DISPLAY_BLACK);
    display_println("SIMON");
    display_setTextSize(SIMONCONTROL_TEXT2);
    display_setCursor(SIMONCONTROL_MSG_START_X2, SIMONCONTROL_MSG_START_Y2);
    display_println("poke me to start");
}



void simonControl_tick() {


	// State actions
	switch(simonControl_st) {
	case init_st:
		printf("simonControl init \r\n");

		// Variable initiation
		iterateSequence = SIMONCONTROL_SEQ_INIT;
		sequenceIndex = SIMONCONTROL_SEQ_INDX;
		messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
		sequenceCap = SIMONCONTROL_SEQ_CAP;
		break;
	case wait_for_touch_st:
		printf("simonControl wait for touch \r\n");
		break;
	case wait_for_sequence_st:
		printf("simonControl wait for sequence \r\n");
		break;
	case wait_for_user_st:
		printf("simonControl wait for user \r\n");
		break;
	case iteration_check_st:
		simonControl_clearDisplay();
		printf("simonControl iteration check \r\n");
		iterateSequence++;
		break;
	case msg_win_st:
		printf("simonControl message win \r\n");
		messageDisplay++;
		break;
	case new_level_st:
		printf("simonControl new level \r\n");
		messageDisplay++;
		break;
	case msg_slow_st:
		printf("simonControl slow \r\n");
		messageDisplay++;
		break;
	case msg_wrong_st:
		printf("simonControl wrong \r\n");
		messageDisplay++;
		break;
	case msg_result_st:
		printf("simonControl result \r\n");
		messageDisplay++;
		break;
	default:
		break;
	}

	// State update
	switch(simonControl_st) {
	case init_st:
		simonControl_st = wait_for_touch_st;
		simonControl_WaitTouchDisplay();
		break;
	case wait_for_touch_st:
		if (display_isTouched()) {
			simonControl_WaitTouchDisplayClear();
			simonControl_st = wait_for_sequence_st;
			flashSequence_enable();

			// We initiate the sequence from index 0 and store it in globals
			sequenceMain[sequenceIndex] = simonControl_randMod4();
			sequenceIndex++;
			globals_setSequenceIterationLength(sequenceIndex);
			globals_setSequence(sequenceMain, sequenceIndex);
		}
		else {
			simonControl_st = wait_for_touch_st;
		}
		break;
	case wait_for_sequence_st:
		if (flashSequence_completed()) {
			simonControl_st = wait_for_user_st;

			// We switch use of state machines on transition
			flashSequence_disable();
			verifySequence_enable();
		}
		else {
			simonControl_st = wait_for_sequence_st;
		}
		break;
	case wait_for_user_st:

		// verifySequence disabled as we exit the wait_for_user_st

		if (!verifySequence_isComplete() && verifySequence_isTimeOutError()) {
			simonControl_st = msg_slow_st;
			simonControl_clearDisplay();
			verifySequence_disable();
			simonControl_slowDisplay();
		}
		else if (!verifySequence_isComplete() && verifySequence_isUserInputError()) {
			simonControl_st = msg_wrong_st;
			simonControl_clearDisplay();
			verifySequence_disable();
			simonControl_errorDisplay();

		}
		else if (verifySequence_isComplete()) {
			simonControl_st = iteration_check_st;
			verifySequence_disable();
			simonControl_clearDisplay();
		}
		break;
	case iteration_check_st:

		// We check the cap to see if player finished
		if (sequenceIndex >= sequenceCap) {
			simonControl_st = msg_win_st;
			messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
			simonControl_winDisplay();
		}
		// Else we move on and add a random sequence square
		else  {
			simonControl_st = wait_for_sequence_st;
			sequenceIndex++;
			sequenceMain[sequenceIndex] = simonControl_randMod4();
			globals_setSequenceIterationLength(sequenceIndex);
			globals_setSequence(sequenceMain, sequenceIndex);
			flashSequence_enable();

		}
		break;
	case msg_win_st:
		if (messageDisplay >= SIMONCONTROL_MSG_DISPLAY_TIME) {
			simonControl_st = new_level_st;
			messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
			simonControl_winDisplayClear();
			simonControl_newLevelDisplay();
		}
		else {
			simonControl_st = msg_win_st;
		}
		break;
	case new_level_st:
		if (messageDisplay >= SIMONCONTROL_MSG_DISPLAY_TIME && !display_isTouched()) {
			simonControl_newLevelDisplayClear();
			simonControl_st = msg_result_st;
			messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
			simonControl_MaxSeqDisplay();
		}
		// If player continues, cap is increased; we start over
		else if (display_isTouched()) {
			simonControl_newLevelDisplayClear();
			simonControl_st = wait_for_sequence_st;
			sequenceCap++;

			sequenceIndex = SIMONCONTROL_SEQ_INDX;
			flashSequence_enable();
			// We initiate the sequence from index 0 and store it in globals
			sequenceMain[sequenceIndex] = simonControl_randMod4();
			sequenceIndex++;
			globals_setSequenceIterationLength(sequenceIndex);
			globals_setSequence(sequenceMain, sequenceIndex);

		}
		else {
			simonControl_st = new_level_st;
		}
		break;
	case msg_slow_st:
		if (messageDisplay >= SIMONCONTROL_MSG_DISPLAY_TIME) {
			simonControl_slowDisplayClear();
			simonControl_st = msg_result_st;
			messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
			simonControl_MaxSeqDisplay();
		}
		else {
			simonControl_st = msg_slow_st;
		}
		break;
	case msg_wrong_st:
		if (messageDisplay >= SIMONCONTROL_MSG_DISPLAY_TIME) {
			simonControl_errorDisplayClear();
			simonControl_st = msg_result_st;
			messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
			simonControl_MaxSeqDisplay();
		}
		else {
			simonControl_st = msg_wrong_st;
		}
		break;
	case msg_result_st:

		// Variables are initialized again as we enter  wait_for_touch_st
		if (messageDisplay >= SIMONCONTROL_MSG_DISPLAY_TIME) {
			simonControl_MaxSeqDisplayClear();
			simonControl_st = wait_for_touch_st;
			sequenceCap = SIMONCONTROL_SEQ_CAP;
			messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
			simonControl_WaitTouchDisplay();
			sequenceIndex = SIMONCONTROL_SEQ_INDX;
			messageDisplay = SIMONCONTROL_MSG_DISPLAY_INIT;
		}
		else {
			simonControl_st = msg_result_st;
		}
		break;
	default:
		simonControl_st = init_st;
		break;
	}

}
