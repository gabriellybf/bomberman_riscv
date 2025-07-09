.include "char.s" 
.include "char_branco.s"
.include "bombinha.s"

.data
char_x: .word 0
bomba_x: .word -1
bomba_y: .word -1

.text
.globl main

main:
	li s1, 0
	li s2, 0
	li s3, 0
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
	la a0, bomba
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	la t0, bomba_x
	sw s1, 0(t0)
	la t0, bomba_y
	sw s3, 0(t0)

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

	#******** verifica se está saindo de cima da bomba
	la t2, bomba_x
	lw t2, 0(t2)
	la t3, bomba_y
	lw t3, 0(t3)
	mv t4, s1
	mv t5, s3
	beq t2, t4, check_y_atual_bomba_d
	j limpa_d

check_y_atual_bomba_d:
	beq t3, t5, printa_bomba_d
	j limpa_d

printa_bomba_d:
	la a0, bomba
	j printa_saida_d

limpa_d:
	la a0, char_preto

printa_saida_d:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	#******** personagem pode andar sobre bomba, mas tem consequências

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

	#******** verifica se está saindo de cima da bomba
	la t2, bomba_x
	lw t2, 0(t2)
	la t3, bomba_y
	lw t3, 0(t3)
	mv t4, s1
	mv t5, s3
	beq t2, t4, check_y_atual_bomba_e
	j limpa_e

check_y_atual_bomba_e:
	beq t3, t5, printa_bomba_e
	j limpa_e

printa_bomba_e:
	la a0, bomba
	j printa_saida_e

limpa_e:
	la a0, char_preto

printa_saida_e:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	#******** REMOVIDO: checagem de bomba no destino

	addi t4, s1, -16
	mv s1, t4
	la a0, char
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
	j loop

##******** CIMA
up:
	ble s3, zero, loop

	#******** verifica se está saindo de cima da bomba
	la t2, bomba_x
	lw t2, 0(t2)
	la t3, bomba_y
	lw t3, 0(t3)
	mv t4, s1
	mv t5, s3
	beq t2, t4, check_y_atual_bomba_c
	j limpa_c

check_y_atual_bomba_c:
	beq t3, t5, printa_bomba_c
	j limpa_c

printa_bomba_c:
	la a0, bomba
	j printa_saida_c

limpa_c:
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

	#******** verifica se está saindo de cima da bomba
	la t2, bomba_x
	lw t2, 0(t2)
	la t3, bomba_y
	lw t3, 0(t3)
	mv t4, s1
	mv t5, s3
	beq t2, t4, check_y_atual_bomba_b
	j limpa_b

check_y_atual_bomba_b:
	beq t3, t5, printa_bomba_b
	j limpa_b

printa_bomba_b:
	la a0, bomba
	j printa_saida_b

limpa_b:
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
