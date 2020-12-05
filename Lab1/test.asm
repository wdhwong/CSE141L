lkup 0       #1
cpy $r14
lkup 8       #16
cpy $r8
OUTER:
mov $r7      #add 1 to i
add $r14     #store back to r7
cpy $r7
lt $r8       # compare 16 to accumulator
bne OUTER    # loop to OUTER while digits < 16
halt