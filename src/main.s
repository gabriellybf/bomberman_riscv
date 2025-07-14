.data
.include "mapa2.data"

.text
li s1, 0xFF000000
li s2, 0xFF012C00
la s0, mapa2
addi s0, s0, 8

LOOP1: beq s1, s2, FIM
lw t0, 0(s0)
sw t0, 0(s1)
addi s0, s0, 4
addi s1, s1, 4
j LOOP1

FIM:
li a7, 10
ecall
