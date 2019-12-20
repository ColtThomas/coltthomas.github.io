## Behind the scenes

### Preprocessor

Before your code is actually compiled, the preprocessor does the following:
* Removes comments
* Gets all include files. <Angle brackets> look in the standard compiler includes, and "double quotes" tells the compiler to search from the current directory.
* Macro expansion. Macros can either be an object (#define foo), or a function (#define foo()). Multiline macros contain a \ to indicate new line:
       #define divide(a,b) ((a)/  \
                              (b))

The preprocessor will interpred directives such as:
#define
#error
#if,elif,else

## Code Examples

### Static
static int a;  

A static keyword is used as follows:
* if a static variable is declared in the body of a function, it will maintain its value between function invocations
* if a static variable is declared in a module (outside of the body of a function) then is is a localized global
* a function declared static may only be called by other functions within that module

### Define a Struct

struct sock {
    int color;
    int quantity;
    void* nextSock;
    void* prevSock;
};

### Dynamic Array using Malloc
```C
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
```

### Error Directive

```C
#if DEFINED(THING)
# define DERP 6
#else
# error "THING not defined"
#endif
```
