# r1 is dividend1 (left, msb)
# r2 is dividend2 (right, lsb)
# r3 is divisor
# r4 = op
# r5 =mask
# r6 =rem
# r7 =i
# r8 =ans1
# r9 =ans2
# r10 =16
# r11 =8
# r12 =1
# r13 = temp
# r14 = 255

# load msb dividend
lkup 10
load $r0
cpy $r1

# load lsb dividend
lkup 0
load $r0
cpy $r2

# load divisor
lkup 1
load $r0
cpy $r3

# op, rem, int i, ans1, ans2 = 0
lkup 10
cpy $r4
cpy $r6
cpy $r7
cpy $r8
cpy $r9

# mask = 128
lkup 7
cpy $r5

# r10 =16, r11 = 8
lkup 8
cpy $r10
lkup 3
cpy $r11

#r12 = 1 
lkup 0
cpy $r12

#r14 = -1
lkup 13	
cpy $r14		

DIVIDE:
mov $r10 # if 16 < i is true then branch to setup_remainder
lt $r7		
bne SETUP_REMAINDER

lkup 9 # if  7 < i is true, then branch to use LSB
lt $r7 		
bne LOWER

# move MSB value into r13 as temp hold, then forcibly branch to operations
mov $r1
cpy $r13
lkup 0
bne OPERATIONS

LOWER:
# move LSB into r13 as temp hold
mov $r2
cpy $r13	

OPERATIONS:
mov $r5
nand $r13	
eql $r14 # if equal to 255, accum = 1 take branch since Bit was 0
bne BIT_IS_0
#if bit is 1, shift op left by 1 and append a 1
sll $r4
mov $r4
or $r12
cpy $r4
lkup 0
bne CHECK_DIVISOR

BIT_IS_0:
lkup 10
cpy $r13
mov $r4
eql $r13 #if op = 0, branch to check divisor, else shift left by 1
bne CHECK_DIVISOR
sll $r4

CHECK_DIVISOR:
#if op < divisor go to mask shift
mov $r4
lt $r3
bne SHIFT_MASK
mov $r11 #accum = 8
sub $r12 #accum = 7
lt $r7 
#if 7 < counter is true, branch to use Ans2, else use ans1
bne LOWER_QUOTIENT

# ans1 = ans1 | mask
mov $r5
or $r8
cpy $r8	
# force branch to subtract
mov $r12
bne SUBTRACT	

LOWER_QUOTIENT:
mov $r5
or $r9
cpy $r9


SUBTRACT:
# op = op - divsior
mov $r4 
sub $r3
cpy $r3


SHIFT_MASK:
slr $r5

mov $r7 #increment counter i++
add $r12  
cpy $r7


#if mask = 0, reset mask to 128
lkup 10	# accum has 0
lt $r5	
bne DIVIDE # 0 < mask is true, take branch back to top of DIVIDE
lkup 7		
cpy $r5 # mask was reset to 128
lkup 0
bne DIVIDE # forcibly puts 1 in accum to branch to top of DIVIDE



SETUP_REMAINDER:
lkup 7		
cpy $r5 # reset mask 128
lkup 10
cpy $r7 # reset counter 0

REMAINDER:
# while(k < 8 && op !=0)
lkup 10
eql $r4		
bne DONE # 0 = op, branch to done
mov $r11
lt $r7 # 8 < count, branch
bne DONE
slr $r4
mov $r3
lt $r4 #if divisor < op then accum = 1 take branch
bne IF_INSIDE_REMAINDER
#mask >>=1
slr $r5
mov $r7 # k++
add $r12

#branch back to remainder
mov $r12
bne REMAINDER 	

IF_INSIDE_REMAINDER:
# rem = rem | mask
mov $r6
or $r5
cpy $r6	
# op = op - divisor
mov $r4
sub $r3
cpy $r4

#mask >>=1
slr $r5	

#k++	
mov $r7		
add $r12

#branch back to remainder 
mov $r12
bne REMAINDER

DONE:
#store MSB -> mem[4], LSB -> mem[5], Rem -> mem[6], halt 2 cycles
lkup 9		
cpy $r13 # temp reg to hold offset value
mov $r8
store $r13 # ans1 -> mem[4]

lkup 14	
cpy $r13 # temp reg to hold offset value
mov $r9
store $r13 # ans2-> mem[5]

lkup 15
cpy $r13 # temp reg to hold offset value
mov $r6
store $r13 # rem -> mem[6]

halt
