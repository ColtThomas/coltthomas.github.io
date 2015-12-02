#include <stdio.h>
#include "supportFiles/display.h"
#define GREEN 0x07E0
#define YELLOW 0xFFE0
#define RED 0xF800
int main() {
	display_init();  // Must init all of the software and underlying hardware for LCD.
	display_fillScreen(DISPLAY_BLACK);  // Blank the screen.

	display_setRotation(0);
	display_drawLine(0,0,240,320,GREEN);
	display_drawLine(240,0,0,320 ,GREEN);
	display_drawCircle(120,80,30,RED);
	display_fillCircle(120,240,30,RED);
	display_drawTriangle(90,160,45,134,45,186,YELLOW);
	display_fillTriangle(150,160,195,134,195,186,YELLOW);

}