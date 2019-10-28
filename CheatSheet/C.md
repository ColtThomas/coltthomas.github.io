### Define a Struct

struct sock {
    int color;
    int quantity;
    void* nextSock;
    void* prevSock;
};

### Dynamic Array using Malloc

struct thing *data1; // Pointer of the data type 
 memset(data1, 0, sizeof(struct thing)*datacount);  // Init all structs to 0
  data1[0].number = 1;
  data1[2].number = 15;
  data1[49].number = 66;

// When you know the count you can do the following:
  const int datacount = 50; 
  data1 = malloc(sizeof(struct thing)*datacount);
  if (!data1) {
    perror("Error allocating memory");
    abort();
  }
  
  for (int i = 0; i < datacount; i++){
    printf("Element %d: %d\n", i, data1[i].number);
  }

free(data1);
