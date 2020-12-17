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

#load msb dividend
lkup 10
load $r0
cpy $r1

#load lsb dividend
lkup 0
load $r0
cpy $r2

#load divisor
lkup 1
load $r0
cpy $r3

#op, rem, int i, ans1, ans2 = 0
lkup 10
cpy $r4
cpy $r5
cpy $r6
cpy $r8
cpy $r9

#mask = 128
lkup 7
cpy $r5


#r10 =16, r11 = 8
lkup 8
cpy $r10
lkup 3
cpy $r11

#r12 = 1
lkup 0
cpy $r12

#r14 = 255
lkup 13
cpy $r14

DIVIDE:
# if 16 < i is true then branch to setup_remainder
mov $r10
lt $r7
bne SETUP_REMAINDER

#check to make sure i !=16
mov $r7
eql $r10
bne SETUP_REMAINDER

#if 7 < i is true, branch to use LSB
lkup 9
lt $r7
bne LOWER

#move MSB value into r13 as temphold, then branch to ops
mov $r1
cpy $r13
lkup 0
bne OPERATIONS

LOWER:
#move LSB into r13 as temp hold
mov $r2
cpy $r13

OPERATIONS:
# NAND mask & dividend
mov $r5
nand $r13
#if equal to 255, bit was 0, accum = 1, take branch
eql $r14
bne BIT_IS_0

# bit =1, shift op by 1, append 1
mov $r4
sll $r12
or $r12
cpy $r4

#force branch
mov $r12
bne CHECK_DIVISOR

BIT_IS_0:
#if op = 0 do nothing and branch, else if op != 0 shift left 1
lkup 10
cpy $r13
mov $r4
eql $r13
bne CHECK_DIVISOR

#mov op to accumulator, shift op left by 1
mov $r4
sll $r12
cpy $r4

CHECK_DIVISOR:
#if op < divisor go to mask shift
mov $r4
lt $r3
bne SHIFT_MASK
#if 7 < i is true, branch to use ans2, else use ans1
lkup 9
lt $r7
bne LOWER_QUOTIENT

#ans1 = ans1 | mask
mov $r5
or $r8
cpy $r8

#force branch to subtract
mov $r12
bne SUBTRACT

LOWER_QUOTIENT:
# ans2 = ans2 | mask
mov $r5
or $r9
cpy $r9

SUBTRACT:
#op = op - divisor
mov $r4
rst
sub $r3
cpy $r4

SHIFT_MASK:
# mask = mask >> 1
mov $r5
slr $r12
cpy $r5

#increment i++
mov $r7
rst
add $r12
cpy $r7

#if 0 < mask is true, branch to top of DIVIDE
lkup 10
lt $r5
bne DIVIDE
#mask reset to 128
lkup 7
cpy $r5
#force branch to DIVIDE
lkup 0
bne DIVIDE

SETUP_REMAINDER:
# mask reset = 128, counter reset = 0
lkup 7
cpy $r5
lkup 10
cpy $r7

REMAINDER:
# while (k < 8 && op !=0)

# if 0 = op is true, accum = 1, branch to done
lkup 10
eql $r4
bne DONE 

# if 8 < counter is true, branch to done
mov $r11
lt $r7
bne DONE

# if 8 = counter is true, branch to done
mov $r11
eql $r7
bne DONE

# op = op << 1
mov $r4
sll $r12
cpy $r4

#if divisor < op take branch
mov $r3
lt $r4
bne IF_INSIDE_REMAINDER

#if divisor = op, take branch
mov $r3
eql $r4
bne IF_INSIDE_REMAINDER

#mask = mask >> 1
mov $r5
slr $r12
cpy $r5

#k++
mov $r7
rst
add $r12
cpy $r7

#branch back to remainder
mov $r12
bne REMAINDER

IF_INSIDE_REMAINDER:
#rem = rem | mask
mov $r6
or $r5
cpy $r6

#op = op - divisor
mov $r4
rst
sub $r3
cpy $r4

#mask = mask >> 1
mov $r5
slr $r12
cpy $r5

#k++
mov $r7
rst
add $r12
cpy $r7

#branch back to remainder
mov $r12
bne REMAINDER

DONE:
#store ans1 -> mem[4]
lkup 2
cpy $r13
mov $r8
store $r13   

#ans2 -> mem[5]
lkup 14
cpy $r13
mov $r9
store $r13

#Rem -> mem[6]
lkup 15
cpy $r13
mov $r6
store $r13

halt