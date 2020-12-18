# CSE141L

## Brief ISA Overview
We use an accumulator based architecture. We used the following split for instrution code: 4 bits opcode, 4 bits registers, 1 bit signaling a branch. We use a Look Up Table for immediate values. 

## Features
Program 1 and Program 3 find the correct multiplicative inverse and square root respectively.
Program 2 is able to divide whole numbers, but calculates some remainders incorrectly. 

## Challenges
Challenges we faced while implementing our design were signed/unsigned comparisons. We resolved this by including a lt operator that is able to do signed comparisons while using an unsigned comparison for program 3. We also had to include a Look Up Table for large hardcoded values that would not fit into the immediate of our instructions. 

We floor our answers. 

We used the provided test benches 1 2 and 3 with minimal editing choosing to change code only to floor our square root answers.

## Zoom Link to Video:

https://www.youtube.com/watch?v=P6Mjyd4q-P0&feature=youtu.be

Time stamps:
Program 1 Test Case 1:  2:43
Program 1 Test Case 2:  3:15

Program 2 Test Case 1:  3:53
Program 2 Test Case 2: 4:23
Program 2 Test Case 3: 4:58

Program 3 Test Case 1: 5:45
Program 3 Test Case 2: 8:17
Program 3 Test Csae 3: 9:10

