#include <stdio.h>

void printBinary(int n) {
    // array to store binary number 
    int binaryNum[32]; 
  
    // counter for binary array 
    int i = 0; 
    while (n > 0) { 
  
        // storing remainder in binary array 
        binaryNum[i] = n % 2; 
        n = n / 2; 
        i++; 
    } 
  
    // printing binary array in reverse order 
    for (int j = i - 1; j >= 0; j--) 
        printf("%d", binaryNum[j]); 
}   

int binSubtracton(int a, int b) 
{
      int carry;
      //get 2's compliment of b and add in a
      b = binAddition(~b, 1);
 
      while (b != 0) {
              //find carry and shift it left    
              carry = (a & b) << 1;
              //find the sum
              a = a ^ b;
              b = carry;
      }
      return a;
}

int binAddition(int a,int b) 
{
      int c; //carry
      while (b != 0) {
              //find carry and shift it left
              c = (a & b) << 1;
              //find the sum
              a=a^b;
              b=c;
      }
      return a; 
}
void divide() {
    unsigned int i = 0;
    //unsigned int mask = 128;
    
    unsigned int mask = 128;
    unsigned int d1 = 8;
    unsigned int d2 = 0;
    unsigned int ans1 =0;
    unsigned int ans2 =0;
    unsigned int divisor = 100;
    unsigned int op = 0;
    unsigned int rem = 0;
    
    while(i < 16) {
        
        // nand to isolate bit
        // d2 is leftmost bits
        
        unsigned int a = (i <=7 ) ? ~(d1 & mask) : ~(d2 & mask);
        
        
        // if bit is 1, shift 1
        // if bit is 0, op is > 0, shift 0
        // if bit is 0, op is 0, do nothing
        
        if(a != -1) {
            // bit is 1
            // shift 1 in 
            op = (op <<= 1) | 1;
        } else if (op > 0) {
            // shift 0
            op <<= 1;
        }
        
    
        if(op >= divisor) {
            if(i <= 7) {
                ans1 = ans1 | mask;
                printBinary(ans1);
            } else {
                ans2 = ans2 | mask;
                printBinary(ans2);
            }
            op = binSubtracton(op, divisor);
            
        } 
        
        mask = (mask >>= 1);
        
        if(mask == 0) {
            mask = 128;
        }
        
        i++;
    }
    
    mask = 128;
    
    printf(" d1: %d, d2: %d\n", d1, d2);
    printf("ans 1: %d, ans 2: %d\n", ans1, ans2);
    
    
    int k = 0;
    
    while(k < 8 && op != 0) {
    
        op <<= 1;
     
        if(divisor <= op) {
            rem = rem | mask;
            op = binSubtracton(op, divisor);
        }
    
        mask >>= 1;
        k++;
    }
    
    printf("remainder is : ");
    printBinary(rem);

}


int main()
{
    divide();
}