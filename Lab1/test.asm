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
# r15 = 0
lkup 3        # load data_memory[8] into $r1
load $r0
cpy $r1
lkup 4        # load data_memory[9] into $r2
load $r0
cpy $r2
lkup 0       #1
cpy $r14
lkup 8       #16
cpy $r8
lkup 0       #lower count = 1
cpy $r6
lkup 9
cpy $r9
OUTER:
mov $r5           # left shift upper count by 1
sll $r14
cpy $r5
mov $r6           # get top bit
slr $r9
nand $r14         # and with 1
nand $r0
or $r5
cpy $r5
mov $r6           # left shift lower count by 1
sll $r14
cpy $r6
mov $r3          # shift upper result by 1
sll $r14
cpy $r3
mov $r4          # get top bit of lower result
slr $r9
nand $r14        # and with 1
nand $r0
or $r3
cpy $r3
mov $r4
sll $r14
cpy $r4
mov $r7      #add 1 to i
add $r14     #store back to r7
cpy $r7
lt $r8       # compare 16 to accumulator
bne OUTER    # loop to OUTER while digits < 16
lkup 5
cpy $r9
lkup 6
cpy $r10
mov $r3
store $r9
mov $r4
store $r10
halt