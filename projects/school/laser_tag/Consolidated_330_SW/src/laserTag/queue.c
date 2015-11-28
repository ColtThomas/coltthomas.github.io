/*
 * queue.c
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include "queue.h"

#define QUEUE_ERROR_VALUE 0
#define QUEUE_INIT_VALUE 0
#define QUEUE_OFFSET 1
#define QUEUE_PASS 1

//These constants are specifically used in runTest function
#define QUEUE_OVERWRITE_VAL 12
#define QUEUE_OVERWRITE_INDX 9

//Increments the indexIn value
//Rather than having additional conditional statements in the push and pop
//functions, we create a function that handles the cases for more easily readable
//code.
void queue_incrementIndxIn(queue_t* q) {
	queue_index_t queueIndexIn = q->indexIn;
	queue_index_t queueSize = q->size - QUEUE_OFFSET;
	if (queueIndexIn == (queueSize) ) {
		q->indexIn = QUEUE_INIT_VALUE;
	}
	else {
		q->indexIn++;
	}
}

//Indexes the indexOut value
//Rather than having additional conditional statements in the push and pop
//functions, we create a function that handles the cases for more easily readable
//code.
void queue_incrementIndxOut(queue_t* q) {
	if (q->indexOut == (q->size - QUEUE_OFFSET)) {
		q->indexOut = QUEUE_INIT_VALUE;
	}
	else {
		q->indexOut++;
	}
}
// Standard queue implementation that leaves one spot empty so easier to check for full/empty.
void queue_init(queue_t* q, queue_size_t size) {
  q->indexIn = QUEUE_INIT_VALUE;
  q->indexOut = QUEUE_INIT_VALUE;
  q->elementCount = QUEUE_INIT_VALUE;
  q->size = size;
  q->data = (queue_data_t *) malloc(q->size * sizeof(queue_data_t));
}

// Just free the malloc'd storage.
void gueue_garbageCollect(queue_t* q) {
  free(q->data);
}


// Returns the size of the queue..
queue_size_t queue_size(queue_t* q) {
	return q->size;
}

// Returns true if the queue is full.
bool queueFull(queue_t* q) {
	return q->elementCount >= q->size;
}

// Returns true if the queue is empty.
bool queue_empty(queue_t* q) {
	return q->elementCount == QUEUE_INIT_VALUE;
}

// Pushes a new element into the queue. Reports an error if the queue is full.
void queue_push(queue_t* q, queue_data_t value) {

		if (queueFull(q) == true) {
			printf("*error: queue is full*\n\r");
		}
		else {
			q->data[q->indexIn] = value; //Index in indicates where the new value is pushed
			queue_incrementIndxIn(q);
			q->elementCount++;
		}
}

// Removes the oldest element in the queue.
queue_data_t queue_pop(queue_t* q) {

	queue_data_t popValue;
	if (!queue_empty(q)) {
		popValue = q->data[q->indexOut];
		q->elementCount--;
		queue_incrementIndxOut(q);
		return popValue;
	}
	else {
		printf("*error; queue empty*\n\r");
		return QUEUE_ERROR_VALUE;
	}

}

// Pushes a new element into the queue, making room by removing the oldest element.
void queue_overwritePush(queue_t* q, queue_data_t value) {
	if (queueFull(q)) {
		q->data[q->indexIn] = value;
		queue_incrementIndxIn(q);
		queue_incrementIndxOut(q);

	}
	else {
		queue_push(q,value);
	}
}

// Provides random-access read capability to the queue.
// Low-valued indexes access older queue elements while higher-value indexes access newer elements
// (according to the order that they were added).
queue_data_t queue_readElementAt(queue_t* q, queue_index_t index) {
	queue_index_t indexFinal;

	if (index > queue_size(q) - QUEUE_OFFSET) {
		printf("invalid index %d\r\n",index);
		return QUEUE_ERROR_VALUE;
	}

	//These statements determine if the queue is wrapped or not.
	if ( q->indexIn > q->indexOut) {
		//non-wrapped queue.
		indexFinal = q->indexOut + index;
		return q->data[indexFinal];
	}
	else if ( q->indexIn < q->indexOut) {
		//queue is wrapped.
		indexFinal = index + q->indexOut - q->size;
	}
	else {
		if (queue_empty(q)) {
			printf("queue is empty \r\n");
		}
		else {
			//Indexes are at same location, but queue not empty.
			indexFinal = q->indexOut + index;
			if (indexFinal >= q->size) {
				indexFinal = indexFinal - q->size;
			}
			return q->data[indexFinal];
		}
	}

	return QUEUE_ERROR_VALUE;
}

// Returns a count of the elements currently contained in the queue.
queue_size_t queue_elementCount(queue_t* q) {
	return q->elementCount;
}


// Prints the current contents of the queue. Handy for debugging.
void queue_print(queue_t* q) {
	uint32_t i;
	for (i = QUEUE_INIT_VALUE ; i < q->size ; i++) {
		printf("index %lu - ", i);
		printf("returned queue value: %lf ", queue_readElementAt(q, i));
		printf("value at physical address: %lf \r\n", q->data[i]);
	}
}

// Performs a comprehensive test of all queue functions.
//int queue_runTest() {
//
//	printf("Testing queue: \r\n \r\n");
//	queue_t queue1;
//	queue_size_t size = 8;
//	queue_init(&queue1,size);
//
//	//Incremental variables
//	uint32_t i;
//	uint32_t k;
//
//	//Comparison array
//	double testArray[size];
//
//	//Pass boolean
//	bool passTest = QUEUE_INIT_VALUE;
//	//Pretest
//
//
//	printf("\r\n--Testing push function--\r\n \r\n");
//	for (i = QUEUE_INIT_VALUE ; i < size + 1 ; i++) {
//		queue_push(&queue1,i);
//		testArray[i] = i;
//	}
//	if (queueFull(&queue1)) {
//		passTest = true;
//		for (i = QUEUE_INIT_VALUE ; i < size ; i++) {
//			if (testArray[i] != queue_readElementAt(&queue1, i)) {
//				passTest = false;
//			}
//		}
//		if (passTest) {printf("Pass push test\r\n");}
//		else {printf("Push test failed\r\n");}
//	}
//
//
//	printf("\r\n--Testing readElementAt function-- \r\n\r\n");
//	printf("printing values from indexes 0 to %lu: \r\n", size);
//	queue_print(&queue1);
//
//
//	printf("\r\n--Testing overwritePush function-- \r\n\r\n");
//	printf("printing values from indexes 0 to %lu: \r\n", size);
//	for (k = QUEUE_OVERWRITE_VAL ; k < size + QUEUE_OVERWRITE_INDX  ; k++ ) {
//		queue_overwritePush(&queue1, k);
//	}
//	queue_print(&queue1);
//
//
//	printf("\r\n--Testing pop function-- \r\n\r\n");
//	for (k = QUEUE_INIT_VALUE ; k < size + QUEUE_OFFSET ; k++) {
//		printf("test: popped out %lf \n\r" , queue_pop(&queue1));
//	}
//	if (queue_empty(&queue1)) {
//		printf("Pass pop test\r\n");
//	}
//	else {
//		printf("Pop test failed\r\n");
//	}
//
//
//	return QUEUE_PASS;
//}


//---------------------------------------Given test code------------------------

#define SMALL_QUEUE_SIZE 10
#define SMALL_QUEUE_COUNT 10
static queue_t smallQueue[SMALL_QUEUE_COUNT];
static queue_t largeQueue;

// smallQueue[SMALL_QUEUE_COUNT-1] contains newest value, smallQueue[0] contains oldest value.
// Thus smallQueue[0](0) contains oldest value. smallQueue[SMALL_QUEUE_COUNT-1](SMALL_QUEUE_SIZE-1) contains newest value.
// Presumes all queue come initialized full of something (probably zeros).
static double popAndPushFromChainOfSmallQueues(double input) {
  // Grab the oldest value from the oldest small queue before it is "pushed" off.
  double willBePoppedValue = queue_readElementAt(&(smallQueue[0]), 0);
  // Sequentially pop from the next newest queue and push into next oldest queue.
  for (int i=0; i<SMALL_QUEUE_COUNT-1; i++) {
    queue_overwritePush(&(smallQueue[i]), queue_pop(&(smallQueue[i+1])));
  }
  queue_overwritePush(&(smallQueue[SMALL_QUEUE_COUNT-1]), input);
  return willBePoppedValue;
}

static bool compareChainOfSmallQueuesWithLargeQueue(uint16_t iterationCount) {
  bool success = true;
  static uint16_t oldIterationCount;
  static bool firstPass = true;
  // Start comparing the oldest element in the chain of small queues, and the large queue
  // and move towards the newest values.
  for (uint16_t smallQIdx=0; smallQIdx<SMALL_QUEUE_COUNT; smallQIdx++) {
    for (uint16_t smallQEltIdx=0; smallQEltIdx<SMALL_QUEUE_SIZE; smallQEltIdx++) {
      double smallQElt = queue_readElementAt(&(smallQueue[smallQIdx]), smallQEltIdx);
      double largeQElt = queue_readElementAt(&largeQueue, (smallQIdx*SMALL_QUEUE_SIZE) + smallQEltIdx);
      if (smallQElt != largeQElt) {
	if (firstPass || (iterationCount != oldIterationCount)) {
	  printf("Iteration:%d\n\r", iterationCount);
	  oldIterationCount = iterationCount;
	  firstPass = false;
	}
	printf("largeQ(%d):%lf", (smallQIdx*SMALL_QUEUE_SIZE) + smallQEltIdx, largeQElt);
	printf(" != ");
	printf("smallQ[%d](%d): %lf\n\r", smallQIdx, smallQEltIdx, smallQElt);
        success = false;
      }
    }
  }
  return success;
}

#define TEST_ITERATION_COUNT 105
#define FILLER 5
int queue_runTest() {
  int success = 1;  // Be optimistic.
  // Let's make this a real torture test by testing queues against themselves.
  // Test the queue against an array to make sure there is agreement between the two.
  double testData[SMALL_QUEUE_SIZE + FILLER];
  queue_t q;
  queue_init(&q, SMALL_QUEUE_SIZE);
  // Generate test values and place the values in both the array and the queue.
  for (int i=0; i<SMALL_QUEUE_SIZE + FILLER; i++) {
    double value = (double)rand()/(double)RAND_MAX;
    queue_overwritePush(&q, value);
    testData[i] = value;
  }
  // Everything is initialized, compare the contents of the queue against the array.
  for (int i=0; i<SMALL_QUEUE_SIZE; i++) {
    double qValue = queue_readElementAt(&q, i);
    if (qValue != testData[i+FILLER]) {
      printf("testData[%d]:%lf != queue_readElementAt(&q, %d):%lf\n\r", i, testData[i+FILLER], i+FILLER, qValue);
      success = 0;
    }
  }
  if (!success) {
    printf("Test 1 failed. Array contents not equal to queue contents.\n\r");
  } else {
    printf("Test 1 passed. Array contents match queue contents.\n\r");
  }
  success = 1;  // Remain optimistic.
  // Test 2: test a chain of 5 queues against a single large queue that is the same size as the cumulative 5 queues.
  for (int i=0; i<SMALL_QUEUE_COUNT; i++)
    queue_init(&(smallQueue[i]), SMALL_QUEUE_SIZE);
  for (int i=0; i<SMALL_QUEUE_COUNT; i++) {
    for (int j=0; j<SMALL_QUEUE_SIZE; j++)
      queue_overwritePush(&(smallQueue[i]), 0.0);
  }
  queue_init(&largeQueue, SMALL_QUEUE_SIZE * SMALL_QUEUE_COUNT);
  for (int i=0; i<SMALL_QUEUE_SIZE*SMALL_QUEUE_COUNT; i++)
    queue_overwritePush(&largeQueue, 0.0);
  for (int i=0; i<TEST_ITERATION_COUNT; i++) {
    double newInput = (double)rand()/(double)RAND_MAX;
    popAndPushFromChainOfSmallQueues(newInput);
    queue_overwritePush(&largeQueue, newInput);
    if (!compareChainOfSmallQueuesWithLargeQueue(i)) {  // i is passed to print useful debugging messages.
      success = 0;
    }
  }

  if (success)
    printf("Test 2 passed. Small chain of queues behaves identical to single large queue.\n\r");
  else
    printf("Test 2 failed. The content of the chained small queues does not match the contents of the large queue.\n\r");
  return success;
}
