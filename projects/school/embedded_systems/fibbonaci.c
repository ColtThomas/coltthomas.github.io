#include <stdio.h>
#include "platform.h"

//#define FIB_SEED_1 0
//#define FIB_SEED_2 0
void print(char *str);



int main()
{
    init_platform();


    // You could probably use the seed values as global
    int seed_0 = 0;
    int seed_1 = 1;
    int result;
    int iterations = 6;
    int i;
    xil_printf("Fib Number Sequence: %d, %d ",seed_0,seed_1);

    // Fibonacci algorithm
    for (i = 0 ; i < iterations; i++) {
    	result = seed_0 + seed_1;
    	seed_0 = seed_1;
    	seed_1 = result;
    	xil_printf(", %d",result);
    }
    xil_printf("\r\n");

//    xil_printf("I present you a fib number: %d\r\n",result);

    cleanup_platform();

    return 0;
}
