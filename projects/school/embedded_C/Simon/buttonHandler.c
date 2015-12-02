#include "buttonHandler.h"
#include "supportFiles/display.h"
#include "supportFiles/utils.h"
#include "simonDisplay.h"


#define RUN_TEST_TERMINATION_MESSAGE1 "buttonHandler_runTest()"
#define RUN_TEST_TERMINATION_MESSAGE2 "terminated."
#define RUN_TEST_TEXT_SIZE 2
#define BUTTONHANDLER_DEBOUNCE 1
// States for the controller state machine.
enum buttonHandler_st_t {
	init_st,                 // Start here, any inits activated.
	no_touch_st,        	// Wait here until the first touch - board shows normal squares until touched.
	wait_st,
	hold_st,     			// waiting for release.
	final_st,   			// waiting for enable signal from outside
} buttonState = init_st;

bool buttonEnable;
bool releaseDetected;
uint8_t increment;
uint8_t buttonActive;
// Get the simon region numbers. See the source code for the region numbering scheme.
uint8_t buttonHandler_getRegionNumber() {
	int16_t x = 0;
	int16_t y = 0;
	uint8_t z = 0;
	display_getTouchedPoint(&x, &y, &z);

	return simonDisplay_computeRegionNumber(x,y);
}

// Turn on the state machine. Part of the interlock.
void buttonHandler_enable() {
	buttonEnable = true;
}

// Turn off the state machine. Part of the interlock.
void buttonHandler_disable() {
	buttonEnable = false;
	releaseDetected = false;
}

// Other state machines can call this function to see if the user has stopped touching the pad.
bool buttonHandler_releaseDetected() {
	return releaseDetected;
}

// Standard tick function.
void buttonHandler_tick() {
	  // Perform state action first.
	  switch(buttonState) {
	    case init_st:
	    	//printf("release detected is false\r\n");
	    	releaseDetected =false;
	    	increment = 0;
	      break;
	    case no_touch_st:
	    	releaseDetected =false;
    		increment = 0;
	      break;
	    case wait_st:
	    	increment++;
	    	break;
	    case hold_st:
	      break;
	    case final_st:
	    	//printf("final button st\r\n");
    		releaseDetected = false;
	      break;
	     default:
	      break;
	  }

	  // Perform state update next.
	  switch(buttonState) {
	    case init_st:
	    	if (buttonEnable) {
	    		buttonState = no_touch_st;
		    	simonDisplay_drawAllButtons();

	    	}
	      break;
	    case no_touch_st:
	    	if (display_isTouched()){
	    		buttonState = wait_st;
	    		display_clearOldTouchData();
	    	}
	    	else if (buttonEnable == false) {
	    		buttonState = init_st;
	    	}
	    	else {
	    		buttonState = no_touch_st;
	    	}
	      break;
	    case wait_st:
	    	if (increment >= BUTTONHANDLER_DEBOUNCE && display_isTouched()) {
	    		buttonActive = buttonHandler_getRegionNumber();
	    		simonDisplay_drawSquare(buttonActive,false);
	    		buttonState = hold_st;
	    	}
	    	else if (!display_isTouched()){
	    		buttonState = no_touch_st;
	    	}
	    	break;
	    case hold_st:
	    	if(!display_isTouched()) {

		    	simonDisplay_drawSquare(buttonActive,true);
	    		simonDisplay_drawButton(buttonActive);
	    		releaseDetected = true;
	    		buttonState = final_st;
	    	}
	    	else if (!buttonEnable) {
		    	simonDisplay_drawSquare(buttonActive,true); //
		    	buttonState = final_st;
	    	}
	    	else {
	    		//display_clearOldTouchData();   //might have to remove this
	    		buttonState = hold_st;
	    	}

	      break;
	    case final_st:
	    	if (!buttonEnable) {
	    		buttonState = init_st;
	    	}
	      break;
	     default:
	      break;
	  }
}


// buttonHandler_runTest(int16_t touchCount) runs the test until
// the user has touched the screen touchCount times. It indicates
// that a button was pushed by drawing a large square while
// the button is pressed and then erasing the large square and
// redrawing the button when the user releases their touch.

void buttonHandler_runTest(int16_t touchCountArg) {
  int16_t touchCount = 0;             // Keep track of the number of touches.
  display_init();                     // Always have to init the display.
  display_fillScreen(DISPLAY_BLACK);  // Clear the display.
  simonDisplay_drawAllButtons();      // Draw the four buttons.
  buttonHandler_enable();
  while (touchCount < touchCountArg) {  // Loop here while touchCount is less than the touchCountArg
    buttonHandler_tick();               // Advance the state machine.
    utils_msDelay(1);			// Wait here for 1 ms.
    if (buttonHandler_releaseDetected()) {  // If a release is detected, then the screen was touched.
      touchCount++;                         // Keep track of the number of touches.
      printf("button released: %d\n\r", buttonHandler_getRegionNumber());  // Get the region number that was touched.
      buttonHandler_disable();             // Interlocked behavior: handshake with the button handler (now disabled).
      utils_msDelay(1);                     // wait 1 ms.
      buttonHandler_tick();                 // Advance the state machine.
      buttonHandler_enable();               // Interlocked behavior: enable the buttonHandler.
      utils_msDelay(1);                     // wait 1 ms.
      buttonHandler_tick();                 // Advance the state machine.
    }
  }
  display_fillScreen(DISPLAY_BLACK);			// clear the screen.
  display_setTextSize(RUN_TEST_TEXT_SIZE);		// Set the text size.
  display_setCursor(0, display_height()/2);		// Move the cursor to a rough center point.
  display_println(RUN_TEST_TERMINATION_MESSAGE1);	// Print the termination message on two lines.
  display_println(RUN_TEST_TERMINATION_MESSAGE2);
}



