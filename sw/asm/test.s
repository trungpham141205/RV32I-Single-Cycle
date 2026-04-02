addi x1, x0, 5 
addi x2, x0, 3
add x3, x1, x2
sub x4, x1, x2
and x5, x1, x2
or x6, x1, x2
xor x7, x1, x2
slt x8, x2, x1
sw x3, 0(x0)
lw x9, 0(x0)
beq x1, x1, skip
addi x10, x0, 99
skip:
addi x10, x0, 42
jal x11, done
addi x11, x0, 99
done:
addi x0, x0, 0