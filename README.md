# CSE141L

## Brief ISA Overview
We use an accumulator based architecture. We used the following split for instrution code: 4 bits opcode, 4 bits registers, 1 bit signaling a branch. We use a Look Up Table for immediate values. 

## Features
Program 1 and Program 3 find the correct multiplicative inverse and square root respectively.
Program 2 is able to divide whole numbers, but calculates some remainders incorrectly. 

## Challenges
Challenges we faced while implementing our design were signed/unsigned comparisons. We resolved this by including a lt operator that is able to do signed comparisons. We also had to include a Look Up Table for large hardcoded values that would not fit into the immediate of our instructions. 

We floor our answers. 

We changed our test bench to floor our answers. 

## Zoom Link to Video:
Time stamps:
 
