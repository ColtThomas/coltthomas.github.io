## Behind the scenes

### Preprocessor

Before your code is actually compiled, the preprocessor does the following:
* Removes comments
* Gets all include files. <Angle brackets> look in the standard compiler includes, and "double quotes" tells the compiler to search from the current directory.
* Macro expansion. Macros can either be an object (#define foo), or a function (#define foo()). Multiline macros contain a \ to indicate new line:
       #define divide(a,b) ((a)/  \
                              (b))

## Code Examples

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
