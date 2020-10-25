# r0 = accumulator
# r1 = data_memory[8]
# r2 = data_memory[9]
# r3 = upper_result
# r4 = lower_result
# r5 = upper_count
# r6 = lower_count
# r7 = digits
# r8 = 16
# r9 = 0
# r10 = 0
# r11 = 0
# r12 = upper_temp
# r13 = lower_temp
# r14 = 1
# r15 = overflow
# unsigned int value; $r1 and $r2
str 8        # load data_memory[8] into $r1
load $r0
cpy $r1
str 9        # load data_memory[9] into $r2
load $r0
cpy $r2
# unsigned int result = 0; $r3 and $r4
$r3 = 0
# unsigned int count = 1; $r5 and $r6
str 1
cpy $r6
# unsigned int digits = 0; $r7
str 1
cpy $r13

str 16
cpy $r8
OUTER: 
# Do counter + (-value)
# convert value to two's complement representation (flip and add 1)
mov $r2
nand $r0
add $r14
# add lower 8 bits of counter to lower 8 bits of value and save carry bit
add $r2
cpy $r13
# add upper 8 bits of counter to upper 8 bits of value and carry bit => store into temp
mov $r1
nand $r0
add $r15 # add overflow bit
rst
cpy $r12

# compare upper_temp to 0 and lower_temp to 0 (counter + -value >= 0)
# if upper_temp < 0 (same as opposite temp >= 0)
mov $r12
lt $r11
bne SKIP_IF
#    result |= 1;
mov $r4
or $r14
cpy $r4
#    count = temp;
mov $r12
cpy $r5
mov $r13
cpy $r6
#}

SKIP_IF:
# Shift counter left by one bit (also handle carry bit)
# count <<= 1;
mov $r6
sll $r14
cpy $r6
mov $r15
eql $r14
bne SKIP_UPPER_C # no overflow from carry bit
mov $r5
sll $r14
or $r14
cpy $r5
rst

SKIP_UPPER_C:
# Shift result left by one bit (also handle carry bit)
# result <<= 1;
mov $r4
sll $r14
cpy $r4
mov $r15
bne SKIP_UPPER_R    # no overflow from carry bit
mov $r3             # shift upper result by 1
sll $r14
or $r14
cpy $r5
rst

SKIP_UPPER_R:
# digits++;
mov $r7
add $r14
lt $r8       # compare 16 to accumulator
bne OUTER    # loop to OUTER while digits < 16

# Store result in data_memory[10]/data_memory[11]
str 10
cpy $r9
str 11
cpy $r10
mov $r3
store $r9
mov $r4
store $r10
halt