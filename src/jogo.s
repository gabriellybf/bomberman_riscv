.include "char.s"
.include "char_branco.s"
.include "bombinha.s"

.data
char_x: .word 0
bomba_x: .word -1, -1, -1, -1, -1
bomba_y: .word -1, -1, -1, -1, -1

.text
.globl main

main:
	li s1, 0  # pos x
	li s2, 0
	li s3, 0  # pos y
	li s4, 0

loop:
	call GetCharacter
	li t1, 100
	beq s0, t1, right
	li t1, 97
	beq s0, t1, left
	li t1, 119
	beq s0, t1, up
	li t1, 115
	beq s0, t1, down
	li t1, 101
	beq s0, t1, bomb
	j loop

bomb:
	li t0, 0               # índice i = 0
	la t1, bomba_x
	la t2, bomba_y

encontra_vaga:
	lw t3, 0(t1)           # carrega bomba_x[i]
	li t4, -1
	beq t3, t4, salva_pos
	addi t0, t0, 1
	addi t1, t1, 4         # próxima posição do array bomba_x
	addi t2, t2, 4         # próxima posição do array bomba_y
	li t5, 5
	blt t0, t5, encontra_vaga
	j continua_bomba       # se não tiver espaço, apenas continua

salva_pos:
	sw s1, 0(t1)           # salva x
	sw s3, 0(t2)           # salva y

continua_bomba:
	la a0, bomba
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	la a0, char
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
	j loop

##******** DIREITA
right:
	li t0, 304
	addi t1, s1, 16
	bgt t1, t0, linha_baixo

	#******** verifica se está saindo de cima de qualquer bomba
	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_d:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_d
	bne t4, s3, proxima_bomba_d
	la a0, bomba
	j printa_saida_d

proxima_bomba_d:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_d

	la a0, char_preto

printa_saida_d:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	mv s2, s1
	addi s1, s1, 16
	la a0, char
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
	j loop

##******** ESQUERDA
left:
	ble s1, zero, loop

	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_e:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_e
	bne t4, s3, proxima_bomba_e
	la a0, bomba
	j printa_saida_e

proxima_bomba_e:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_e

	la a0, char_preto

printa_saida_e:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	addi s1, s1, -16
	la a0, char
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
	j loop

##******** CIMA
up:
	ble s3, zero, loop

	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_c:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_c
	bne t4, s3, proxima_bomba_c
	la a0, bomba
	j printa_saida_c

proxima_bomba_c:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_c

	la a0, char_preto

printa_saida_c:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	addi s3, s3, -16
	la a0, char
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
	j loop

##******** BAIXO
down:
	li t0, 224
	bge s3, t0, loop

	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_b:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_b
	bne t4, s3, proxima_bomba_b
	la a0, bomba
	j printa_saida_b

proxima_bomba_b:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_b

	la a0, char_preto

printa_saida_b:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	addi s3, s3, 16
	la a0, char
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
	j loop

linha_baixo:
	la a0, char_preto
	mv a1, s1
	mv a2, s3
	call PRINT

	li s1, 0
	addi s3, s3, 16

	la a0, char
	mv a1, s1
	mv a2, s3
	call PRINT
	j loop

## PRINT
PRINT:
	li t0, 0xFF0
	add t0, t0, a3
	slli t0, t0, 20
	add t0, t0, a1

	li t1, 320
	mul t1, t1, a2
	add t0, t0, t1

	addi t1, a0, 8
	mv t2, zero
	mv t3, zero

	lw t4, 0(a0)
	lw t5, 4(a0)

PRINT_LINHA:
	lw t6, 0(t1)
	sw t6, 0(t0)
	addi t0, t0, 4
	addi t1, t1, 4
	addi t3, t3, 4
	blt t3, t4, PRINT_LINHA

	addi t0, t0, 320
	sub t0, t0, t4
	mv t3, zero
	addi t2, t2, 1
	ble t2, t5, PRINT_LINHA

	ret

## GET CHARACTER
GetCharacter:
	addi sp, sp, -4
	sw ra, 0(sp)
	li s0, 0
	j CharacterCheck

GetCharacterLoop:
	jal IsCharacterThere

CharacterCheck:
	beq s0, zero, GetCharacterLoop
	lui t0, 0xff200
	addi t0, t0, 4
	lw s0, 0(t0)
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

IsCharacterThere:
	lui t0, 0xff200
	lw t1, 0(t0)
	andi s0, t1, 1
	ret
