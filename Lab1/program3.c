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

void squareRoot() {
    unsigned int n = 16;
    unsigned int A = 1;
    unsigned int B = 0;
    unsigned int temp = n;
    unsigned int decimal = 0;
    unsigned int digits = 0;
    unsigned int counter = 1;
    unsigned int result = 0;
    unsigned int prev = 0;

    // temp + (-A) >= 0
    while (temp >= A) {
        B++;
        temp -= A;
    }
    B += A;
    B >>= 1;

    while ((A ^ B) != 0) {
        A = B;
        prev = result;
        
        temp = n;
        while (temp >= A) {
            B++;
            temp -= A;
        }

        digits = 0;
        counter = 1;
        result = 0;
        while (digits < 8) {
            if (counter >= A) {
                result |= 1;
                counter -= A;
            }
            result <<= 1;
            digits++;
            counter <<= 1;
        }

        B >>= 1;
        if (prev >= result) {
            break;
        }
    }

    // HALT instruction
    printf("%d\n", A);
}

int main(int argc, char *argv[]) {
    squareRoot();
}