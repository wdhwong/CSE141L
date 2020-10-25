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

void divide() {
    unsigned int dividend = 1; // Get from data_memory[0] and data_memory[1]
    unsigned int divisor = 3; // Get from data_memory[2]

    unsigned int count = 0; // Addition across two registers
    while (divisor <= dividend) {
        count++;
        dividend -= divisor;
    }

    // Store count in data_memory[4] and data_memory[5]
    for (int i = 15; i >= 0; i--) {
        if ((i+1) % 4 == 0 && i+1 != 16) {
            printf(" ");
        }
        printf("%d", (count >> i) & 1);
    }
    printf("\n");

    if (dividend == 0) {
        return; // HALT instruction
    }

    unsigned int digits = 0;
    unsigned int counter = 1;
    unsigned int result = 0;

    while (digits < 8) {
        if (counter >= divisor) {
            result |= 1;
            counter -= divisor;
        }
        result <<= 1;
        digits++;
        counter <<= 1;
    }

    while (dividend > 1) {
        result += result;
        dividend--;
    }

    // Store result in data_memory[6]
    for (int i = digits - 1; i >= 0; i--) {
        if ((i+1) % 4 == 0 && i+1 != digits) {
            printf(" ");
        }
        printf("%d", (result >> i) & 1);
    }
    printf("\n");

    // HALT instruction
}

int main(int argc, char *argv[]) {
    divide();
}