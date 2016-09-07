#include <stdio.h>
#include "platform.h"

// Fibonacci sequences require two initial values in the series
#define FIB_SEED_0 0 
#define FIB_SEED_1 1

#define FIB_ITERATIONS 6 // Fibonacci sequence length

void print(char *str);

int main()
{
    init_platform();

    // Initialize variables used to calculate the fibonacci number sequence
    int seed_0 = FIB_SEED_0;
    int seed_1 = FIB_SEED_1;
    int result;
    int iterations = FIB_ITERATIONS;
    xil_printf("Fib Number Sequence: %d, %d ",seed_0,seed_1);

    // Fibonacci algorithm: x(n) = x(n-1) + x(n-2)
    for (int i = 0 ; i < iterations; i++) {
    	result = seed_0 + seed_1;
    	seed_0 = seed_1;
    	seed_1 = result;
    	xil_printf(", %d",result);
    }
    xil_printf("\r\n"); // Outbut is in the format: 0,1,1,2,3,5,....

    cleanup_platform();

    return 0;
}
