#include "globals.h"
#include "stdio.h"
#include "stdbool.h"

#define GLOBALS_MAXSIZE 255
uint8_t global_sequence[GLOBALS_MAXSIZE];
uint8_t current_size;
// This is the length of the complete sequence at maximum length.
// You must copy the contents of the sequence[] array into the global variable that you maintain.
// Do not just grab the pointer as this will fail.
void globals_setSequence(const uint8_t sequence[], uint16_t length) {
	uint8_t i;
	for (i = 0 ; i < length ; i++) {
		global_sequence[i] = sequence[i];
	}
}

// This returns the value of the sequence at the index.
uint8_t globals_getSequenceValue(uint16_t index) {
	return global_sequence[index];
}

// Retrieve the sequence length.
uint16_t globals_getSequenceLength() {
	return GLOBALS_MAXSIZE;
}

// This is the length of the sequence that you are currently working on.
void globals_setSequenceIterationLength(uint16_t length) {
	current_size = length;
}

// This is the length of the sequence that you are currently working on (not the maximum length but the interim length as
// the use works through the pattern one color at a time.
uint16_t globals_getSequenceIterationLength() {
	return current_size;
}
