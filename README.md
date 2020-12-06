# CSE141L

When running the TB, make sure the binary for the program you are running is in the same folder as the project (ie modelsim files are at C:\Downloads\CSE141L so 
program1.bin should be in the same folder)

## ALU Info

Let's say you're trying to do subtraction across two registers (count - value ; where count and value are 16 bits but you only have 8 bit registers). 
You can do two's complement on the lower value and add it to lower count. 
Next, you do the same for the upper value and the upper count but internally, the ALU will add if there is overflow so you don't need to worry about it.
The overflow value will hold so don't forget to call rst to reset the overflow.

```
mov $r6     # Assume lower value in r6, 1 in r14, lower count in r4
nand $r0
add $r14
add $r4     # lower temp = lower count + (-lower value + 1)
mov $r5
nand $r0
add $r3     # upper temp = upper count + (-upper value) ; internally ALU adds overflow bit value either 1 or 0 from previous add operations
```

For less than, it will internally treat the registers as signed so it should be correct for calculating A < B.
```
0 < 1 => 1  (1 because it is true that 0 is less than 1)
1 < 3 => 1
3 < 3 => 0
4 < 3 => 0
```
