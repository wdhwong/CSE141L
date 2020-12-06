lkup 3        # load data_memory[8] into $r1
load $r0
cpy $r1
lkup 4        # load data_memory[9] into $r2
load $r0
cpy $r2
lkup 0        # lower count = 1; $r5 and $r6
cpy $r6
lkup 8        # 16
cpy $r8
lkup 0        # 1
cpy $r14
lkup 9        # 7
cpy $r9
OUTER:
rst
mov $r2       # lower temp = lower count - lower value
nand $r0
add $r14
add $r6
cpy $r13
mov $r1       # upper temp = upper count - upper value ; upper count + (-value)
nand $r0
add $r5
cpy $r12
rst
mov $r12      # if (upper_temp < 0) => if upper_temp >= 0
lt $r11
bne SKIP_IF
mov $r4       # result |= 1;
or $r14
cpy $r4
mov $r12      # upper count = upper temp
cpy $r5
mov $r13      # lower count = lower temp
cpy $r6
SKIP_IF:
mov $r5           # left shift upper count by 1
sll $r14
cpy $r5
mov $r6           # get top bit of lower count
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
mov $r4         # shift lower result by 1
sll $r14
cpy $r4
mov $r2       # lower temp = lower count - lower value
nand $r0
add $r14
add $r6
cpy $r13
mov $r1       # upper temp = upper count - upper value ; upper count + (-value)
nand $r0
add $r5
cpy $r12
rst
mov $r12      # if (upper_temp < 0) => if upper_temp >= 0
lt $r11
bne SKIP_IF2
mov $r4       # result |= 1;
or $r14
cpy $r4
mov $r12      # upper count = upper temp
cpy $r5
mov $r13      # lower count = lower temp
cpy $r6
SKIP_IF2:
mov $r7       # digits++
add $r14
cpy $r7
lt $r8       # compare 16 to accumulator
bne OUTER    # loop to OUTER while digits < 16
lkup 5       # Store result in data_memory[10]/data_memory[11]
cpy $r9
lkup 6
cpy $r10
mov $r3
store $r9
mov $r4
store $r10
halt