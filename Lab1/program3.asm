lkup 8 # load msb
load $r0
cpy $r1
lkup 11 # load lsb
load $r0
cpy $r2
lkup 0
cpy $r3 # stores 1
cpy $r4 # stores result
lkup 12 # address for answer
cpy $r15
lkup 10 # stores 0
cpy $r14
LOOP:
mov $r4 # result + 1
add $r3
cpy $r4
mov $r14
cpy $r6 # result^2 msb
cpy $r7 # result^2 lsb
cpy $r8 # i = 0
SQUARE:
rst
mov $r7 # add result
add $r4 
cpy $r7
mov $r6
add $r14 #add 0
cpy $r6
rst
mov $r8 # i++
add $r3
cpy $r8
lt $r4 # whle i < result
bne SQUARE

mov $r1 # check if msb of x < msb of result  
lt $r6
bne END

mov $r6 # check if msb of x > msb of result
lt $r1
bne LOOP

mov $r7 
lt $r2
bne LOOP

# check if lsb result = lsb x
mov $r7
eql $r2
bne LOOP

END:
rst
mov $r4 # result - 1
sub $r3
store $r15 # store in datamemory[18]
halt









