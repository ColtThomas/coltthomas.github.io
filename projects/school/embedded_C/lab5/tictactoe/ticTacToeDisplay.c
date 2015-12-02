#include "ticTacToeDisplay.h"
#include "supportFiles/display.h"
#include "supportFiles/utils.h"
#include "stdio.h"
#include "buttons.h"
#include "switches.h"

#define TICTACTOE_DISP_ROW_0 0
#define TICTACTOE_DISP_ROW_1 1
#define TICTACTOE_DISP_ROW_2 2
#define TICTACTOE_DISP_COLUMN_0 0
#define TICTACTOE_DISP_COLUMN_1 1
#define TICTACTOE_DISP_COLUMN_2 2

#define TICTACTOE_DISP_ROW_0_PT (display_height()/6)
#define TICTACTOE_DISP_ROW_1_PT 3*(display_height()/6)
#define TICTACTOE_DISP_ROW_2_PT 5*(display_height()/6)
#define TICTACTOE_DISP_COLUMN_0_PT (display_width()/6)
#define TICTACTOE_DISP_COLUMN_1_PT 3*(display_width()/6)
#define TICTACTOE_DISP_COLUMN_2_PT 5*(320/6)
#define TICTACTOE_DISP_RADIUS display_height()/10

#define BUTTON_ISOLATE_BITS 0xF
#define BUTTONS_ISOLATE_BIT_B0  0x1
#define BUTTONS_ISOLATE_BIT_B1 0x2
#define BUTTONS_ISOLATE_BIT_B2  0x4
#define BUTTONS_ISOLATE_BIT_B3  0x8

// Draws an X or O depending on touched region

void ticTacToeDisplay_clear() {
	ticTacToeDisplay_init();
}

void ticTacToeDisplay_gameOver() {
	display_init();  // Must init all of the software and underlying hardware for LCD.
	display_fillScreen(DISPLAY_BLACK);  // Blank the screen.
	display_setRotation(true);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_ROW_0,TICTACTOE_DISP_COLUMN_0);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_ROW_0,TICTACTOE_DISP_COLUMN_2);
	display_drawFastHLine(display_width()/3, display_height()/2, display_width()/3, DISPLAY_CYAN);

	display_setCursor(TICTACTOE_DISP_COLUMN_1_PT,TICTACTOE_DISP_ROW_2_PT);
	display_println("Game Over");

}

// Tells if SW0 is up or down; returns true if high
uint8_t ticTacToeDisplay_SW () {
	return switches_read()& 0x1;
}


// Inits the tic-tac-toe display, draws the lines that form the board.
void ticTacToeDisplay_init(){
	display_init();  // Must init all of the software and underlying hardware for LCD.
	display_fillScreen(DISPLAY_BLACK);  // Blank the screen.
	display_setRotation(true);
	buttons_init();
	ticTacToeDisplay_drawBoardLines();

/*
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_0, TICTACTOE_DISP_ROW_0);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_1, TICTACTOE_DISP_ROW_0);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_2, TICTACTOE_DISP_ROW_0);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_0, TICTACTOE_DISP_ROW_1);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_1, TICTACTOE_DISP_ROW_1);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_2, TICTACTOE_DISP_ROW_1);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_0, TICTACTOE_DISP_ROW_2);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_1, TICTACTOE_DISP_ROW_2);
	ticTacToeDisplay_drawX(TICTACTOE_DISP_COLUMN_2, TICTACTOE_DISP_ROW_2);
*/
	/*
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_0, TICTACTOE_DISP_ROW_0);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_0, TICTACTOE_DISP_ROW_1);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_0, TICTACTOE_DISP_ROW_2);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_1, TICTACTOE_DISP_ROW_0);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_1, TICTACTOE_DISP_ROW_1);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_1, TICTACTOE_DISP_ROW_2);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_2, TICTACTOE_DISP_ROW_0);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_2, TICTACTOE_DISP_ROW_1);
	ticTacToeDisplay_drawO(TICTACTOE_DISP_COLUMN_2, TICTACTOE_DISP_ROW_2);*/




}

// Draws an X at the specified row and column.
void ticTacToeDisplay_drawX(uint8_t row, uint8_t column) {
	switch (row) {
	case 0:
		switch(column) {
		case 0:
			display_drawLine( TICTACTOE_DISP_COLUMN_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );

			break;
		case 1:
			display_drawLine( TICTACTOE_DISP_COLUMN_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		case 2:
			display_drawLine( TICTACTOE_DISP_COLUMN_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_0_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		default:break;
		}
		break;
	case 1:
		switch(column) {
		case 0:
			display_drawLine( TICTACTOE_DISP_COLUMN_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		case 1:
			display_drawLine( TICTACTOE_DISP_COLUMN_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		case 2:
			display_drawLine( TICTACTOE_DISP_COLUMN_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_1_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		default:break;
		}
		break;
	case 2:
		switch(column) {
		case 0:
			display_drawLine( TICTACTOE_DISP_COLUMN_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_0_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_0_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		case 1:
			display_drawLine( TICTACTOE_DISP_COLUMN_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_1_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_1_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		case 2:
			display_drawLine( TICTACTOE_DISP_COLUMN_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT - TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			display_drawLine( TICTACTOE_DISP_COLUMN_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT - TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_COLUMN_2_PT + TICTACTOE_DISP_RADIUS, TICTACTOE_DISP_ROW_2_PT + TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW );
			break;
		default:break;
		}
		break;
	default:break;
	}
}

// Draws an O at the specified row and column.
void ticTacToeDisplay_drawO(uint8_t row, uint8_t column) {
	switch (row) {
	case 0:
		switch(column) {
		case 0:
			display_drawCircle(TICTACTOE_DISP_COLUMN_0_PT, TICTACTOE_DISP_ROW_0_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		case 1:
			display_drawCircle(TICTACTOE_DISP_COLUMN_1_PT, TICTACTOE_DISP_ROW_0_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		case 2:
			display_drawCircle(TICTACTOE_DISP_COLUMN_2_PT, TICTACTOE_DISP_ROW_0_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		default:break;
		}
		break;
	case 1:
		switch(column) {
		case 0:
			display_drawCircle(TICTACTOE_DISP_COLUMN_0_PT, TICTACTOE_DISP_ROW_1_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		case 1:
			display_drawCircle(TICTACTOE_DISP_COLUMN_1_PT, TICTACTOE_DISP_ROW_1_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		case 2:
			display_drawCircle(TICTACTOE_DISP_COLUMN_2_PT, TICTACTOE_DISP_ROW_1_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		default:break;
		}
		break;
	case 2:
		switch(column) {
		case 0:
			display_drawCircle(TICTACTOE_DISP_COLUMN_0_PT, TICTACTOE_DISP_ROW_2_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		case 1:
			display_drawCircle(TICTACTOE_DISP_COLUMN_1_PT, TICTACTOE_DISP_ROW_2_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		case 2:
			display_drawCircle(TICTACTOE_DISP_COLUMN_2_PT, TICTACTOE_DISP_ROW_2_PT, TICTACTOE_DISP_RADIUS, DISPLAY_YELLOW);
			break;
		default:break;
		}
		break;
	default:break;
	}
}

// After a touch has been detected and after the proper delay, this sets the row and column arguments
// according to where the user touched the board.
void ticTacToeDisplay_touchScreenComputeBoardRowColumn(uint8_t* row, uint8_t* column) {
	int16_t x = 0;
	int16_t y = 0;
	uint8_t z = 0;
	uint8_t rowval;
	uint8_t columnval;
	if(display_isTouched()) {
		display_clearOldTouchData();
		utils_msDelay(50);
		display_getTouchedPoint(&x, &y, &z);
		*row = 0;
		*column = 0;
		// column 0
		if (x <= display_width()/3) {


			//row 0
			if (y <=  display_height()/3) {
				rowval = 0;
				columnval = 0;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 0 column 0 \n\r" );
			}
			//row 1
			else if (y <= 2* display_height()/3) {
				rowval = 1;
				columnval = 0;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 1 column 0 \n\r" );
			}
			//row 2
			else {
				rowval = 2;
				columnval = 0;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 2 column 0 \n\r" );

			}

		}
		// column 1
		else if (x <= 2*(display_width()/3) ) {

			//row 0
			if (y <=  display_height()/3) {
				rowval = 0;
				columnval = 1;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 0 column 0 \n\r" );
			}
			//row 1
			else if (y <= 2* display_height()/3) {
				rowval = 1;
				columnval = 1;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 1 column 0 \n\r" );
			}
			//row 2
			else {
				rowval = 2;
				columnval = 1;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 2 column 0 \n\r" );

			}
		}

		// column 2
		else {

			//row 0
			if (y <=  display_height()/3) {
				rowval = 0;
				columnval = 2;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 0 column 0 \n\r" );
			}
			//row 1
			else if (y <= 2* display_height()/3) {
				rowval = 1;
				columnval = 2;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 1 column 0 \n\r" );
			}
			//row 2
			else {
				rowval = 2;
				columnval = 2;
				if (ticTacToeDisplay_SW()) {
					ticTacToeDisplay_drawO(rowval, columnval);
				}
				else {
					ticTacToeDisplay_drawX(rowval, columnval);
				}
				printf("row 2 column 0 \n\r" );

			}
		}
	}
}

// Runs a test of the display. Does the following.
// Draws the board. Each time you touch one of the screen areas, the screen will paint
// an X or an O, depending on whether switch 0 (SW0) is slid up (O) or down (X).
// When BTN0 is pushed, the screen is cleared. The test terminates when BTN1 is pushed.
void ticTacToeDisplay_runTest() {
	uint8_t* row = 0;
	uint8_t* column = 0;
	ticTacToeDisplay_init();
	while(1){
		ticTacToeDisplay_touchScreenComputeBoardRowColumn(row , column );

		if ((buttons_read() & BUTTON_ISOLATE_BITS) & BUTTONS_ISOLATE_BIT_B0) {
			ticTacToeDisplay_clear();
		}
		if ((buttons_read() & BUTTON_ISOLATE_BITS) & BUTTONS_ISOLATE_BIT_B1) {
			ticTacToeDisplay_gameOver();
			break;
		}
	}
}

// This will draw the four board lines.
void ticTacToeDisplay_drawBoardLines() {
	display_drawFastVLine(display_width()/3, 0, display_height(), DISPLAY_CYAN);
	display_drawFastVLine(2*(display_width()/3), 0, display_height(), DISPLAY_CYAN);
	display_drawFastHLine(0, display_height()/3, display_width(), DISPLAY_CYAN);
	display_drawFastHLine(0,(2*display_height()/3), display_width(), DISPLAY_CYAN);
}
