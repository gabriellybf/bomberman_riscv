.include "char.s"
.include "char_branco.s"

.data
char_x: .word 0

.text
.globl main

main:
	li s1, 0           # posição X atual
	li s2, 0           # posição X anterior
	li s3, 0           # posição Y atual
	li s4, 0           # posição Y anterior

loop:
	call GetCharacter  # lê caractere em s0

	li t1, 100         # tecla 'd' no código ASCII
	beq s0, t1, right
	
	li t1, 97          # tecla 'a' no código ASCII
	beq s0, t1, left
	
	li t1, 119         # tecla 'w' no código ASCII
	beq s0, t1, up
	
	li t1, 115         # tecla 's' no código ASCII
	beq s0, t1, down

	j loop

## MOVIMENTO PARA A DIREITA
right:
	li t0, 304         # limite horizontal (max X)
	addi t1, s1, 16    # próxima posição X

	bgt t1, t0, linha_baixo  # se próxima posição passa do limite, muda linha

	# apagar sprite anterior
	la a0, char_preto
	mv a1, s1
	mv a2, s3
	call PRINT

	# atualizar posição
	mv s2, s1
	addi s1, s1, 16

	# desenhar novo sprite
	la a0, char
	mv a1, s1
	mv a2, s3
	call PRINT

	j loop

linha_baixo:
	# apagar sprite anterior
	la a0, char_preto
	mv a1, s1
	mv a2, s3
	call PRINT

	# desce uma linha e reseta x
	li s1, 0
	addi s3, s3, 16

	# desenhar novo sprite
	la a0, char
	mv a1, s1
	mv a2, s3
	call PRINT

	j loop

## MOVIMENTO PARA A ESQUERDA
left:
	ble s1, zero, loop

	la a0, char_preto
	mv a1, s1
	mv a2, s3
	call PRINT

	mv s2, s1
	addi s1, s1, -16

	la a0, char
	mv a1, s1
	mv a2, s3
	call PRINT

	j loop

## MOVIMENTO PARA CIMA
up:
	ble s3, zero, loop

	la a0, char_preto
	mv a1, s1
	mv a2, s3
	call PRINT

	mv s4, s3
	addi s3, s3, -16

	la a0, char
	mv a1, s1
	mv a2, s3
	call PRINT

	j loop

## MOVIMENTO PARA BAIXO
down:
	li t0, 224
	bge s3, t0, loop

	la a0, char_preto
	mv a1, s1
	mv a2, s3
	call PRINT

	mv s4, s3
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

	lw t4, 0(a0)     # largura
	lw t5, 4(a0)     # altura

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

## LER O CARACTERE DO TECLADO
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