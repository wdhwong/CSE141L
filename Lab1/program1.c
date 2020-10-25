#include "stdio.h"

void printBits(char *str, unsigned char value)
{
    printf("%s", str);
    for (int i = 7; i >= 0; i--)
    {
        printf("%d", (value >> i) & 1);
    }
    printf("\n");
}

void printTwo(char *stra, char *strb, unsigned char a, unsigned char b)
{
    printf("%s", stra);
    for (int i = 7; i >= 0; i--)
    {
        printf("%d", (a >> i) & 1);
    }
    printf(" %s", strb);
    for (int i = 7; i >= 0; i--)
    {
        printf("%d", (b >> i) & 1);
    }
    printf("\n");
}

void multiplicativeInverse()
{
    unsigned int value = 1;
    // str 8        load data_memory[8] into $r1
    // load $r0
    // cpy $r1
    // str 9        load data_memory[9] into $r2
    // load $r0
    // cpy $r2
    unsigned int result = 0; 
    // $r3 = 0
    unsigned int count = 1;
    // str 1
    // cpy $r4
    unsigned int digits = 0;

    // str 16
    // cpy $r5
    // OUTER: 
    while (digits < 16) {
        // Do counter + (-value) >= 0
        // convert value to two's complement representation (flip and add 1)
        // add lower 8 bits of counter to lower 8 bits of value and save carry bit
        // add upper 8 bits of counter to upper 8 bits of value and carry bit => store into temp
        if ((count - value) >= 0) {
            result |= 1;
            // set counter to temp
            count -= value;
        }
        // Shift counter left by one bit (also handle carry bit)
        count <<= 1;
        // Shift result left by one bit (also handle carry bit)
        result <<= 1;
        digits++;


        // mov $r4      load digits into accumulator
        // lt $r5       compare digits to accumulator
        // bne OUTER    loop to OUTER if accumulator is 1 else continue
    }

    // Store result in data_memory[10]/data_memory[11]
    // mov
    // store
    // mov
    // store
    // halt
}

int main(int argc, char *argv[])
{
    multiplicativeInverse();
}