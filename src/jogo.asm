.include "char.s"
.include "char_branco.s"
.include "bombinha.s"
.include "inimigo.data"
.include "mapa2.data"
.include "mapa2_colisao.data"

.data
char_x: .word 0
bomba_x: .word -1, -1, -1, -1, -1
bomba_y: .word -1, -1, -1, -1, -1
bomba_timer: .word 0, 0, 0, 0, 0
inimigos_x: .word -1, -1, -1, -1, -1
vidas: .word 3
jogador_atingido: .word 0   # usado pra resetar dps da explos?o
mapa_colisao_mem: .space 76800
tempo_fase_inimigo: .word 200
estado_inimigo: .word 0

.text
   li s11, 0

.globl main

main:
    jal copiar_mapa_colisao
    jal MENU
    jal LOOP1
    
loop:
    jal IsCharacterThere
    beq s0, zero, sem_tecla

    jal GetCharacter

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

sem_tecla:
    jal atualiza_bombas
    li s0, 0
    addi s11, s11, 1
    j INIMIGO
    j loop

MENU:   beq s1, s2, GETCHAR
	lw t0, 0(s0)
	sw t0, 0(s1)
	addi s0, s0, 4
	addi s1, s1, 4
        j LOOP1

GETCHAR:
      jal GetCharacter
      li t1, 13
      beq s0, t1, FIMENU
      
FIMENU:
      li s11, 0
      li s1, 0xFF000000
      li s2, 0xFF012C00
      la s0, mapa2
      addi s0, s0, 8    
      j LOOP1

LOOP1: beq s1, s2, FIMLOOP1
	lw t0, 0(s0)
	sw t0, 0(s1)
	addi s0, s0, 4
	addi s1, s1, 4
        j LOOP1

FIMLOOP1:
	li s1, 16  # pos x do jogador
    	li s3, 48  # pos y do jogador
    	la a0, char
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
    	j loop
        
INIMIGO:
    lw t0, tempo_fase_inimigo   # carrega 500 em t0
    rem t1, s11, t0             # t1 = s11 % 500
    bne t1, zero, verifica_estado  # se NÃO for múltiplo, só verifica o estado

    # se for múltiplo, inverte o estado
    la t2, estado_inimigo
    lw t3, 0(t2)
    xori t3, t3, 1              # 0 ? 1
    sw t3, 0(t2)

verifica_estado:
    la t2, estado_inimigo
    lw t3, 0(t2)
    beq t3, zero, inimigo1
    j inimigo2

inimigo1:
    # printa na nova posição (64, 80)
    li s5, 64
    li s6, 80
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    # apaga posição antiga (48, 80)
    li s5, 48
    li s6, 80
    la a0, char
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop

inimigo2:
    # apaga posição antiga (48, 80)
    li s5, 48
    li s6, 80
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    # printa na nova posição (64, 80)
    li s5, 64
    li s6, 80
    la a0, char
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    j loop

# verifica se h? colis?o em (a1, a2)
# a1 = pos_x
# a2 = pos_y
# retorna: t6 = 1 (n?o colidiu), t6 = 0 (colidiu)
verifica_colisao:
    la t0, mapa_colisao_mem     # base do mapa

    srli t1, a1, 4              # coluna (x / 16)
    srli t2, a2, 4              # linha  (y / 16)

    li t3, 20                   # largura do mapa em c?lulas
    mul t2, t2, t3              # linha * largura
    add t1, t1, t2              # offset = linha * largura + coluna

    add t1, t0, t1              # endere?o final
    lbu t4, 0(t1)               # valor da c?lula (0 = livre, >0 = colis?o)

    # DEBUG opcional
    # mv a0, t4
    # li a7, 1
    # ecall

    bnez t4, colidiu            # se t4 != 0 -> colidiu
    li t6, 1                    # n?o colidiu
    jr ra

colidiu:
    li t6, 0
    mv a0, t4
    li a7, 1     # syscall print_int
    ecall

    j loop
    
# copia N bytes do mapa_colisao para o endere?o 0x100000
copiar_mapa_colisao:
    la a0, mapa2_colisao       # origem
    la a1, mapa_colisao_mem    # destino
    li t0, 76800               # tamanho total (320x240)

copia_loop:
    lbu t1, 0(a0)
    sb t1, 0(a1)
    addi a0, a0, 1
    addi a1, a1, 1
    addi t0, t0, -1
    bnez t0, copia_loop

    jr ra

# BOMBA
bomb:
    li t0, 0
    la t1, bomba_x
    la t2, bomba_y
    la t6, bomba_timer

encontra_vaga:
    lw t3, 0(t1)
    li t4, -1
    beq t3, t4, salva_pos
    addi t0, t0, 1
    addi t1, t1, 4
    addi t2, t2, 4
    addi t6, t6, 4
    li t5, 5
    blt t0, t5, encontra_vaga
    ret

salva_pos:
    sw s1, 0(t1)
    sw s3, 0(t2)
    sw zero, 0(t6)

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

# ATUALIZA??O DAS BOMBAS
atualiza_bombas:
    li t0, 0
    la t1, bomba_x
    la t2, bomba_y
    la t3, bomba_timer
    li t4, 5

atualiza_loop:
    lw t5, 0(t1)
    li t6, -1
    beq t5, t6, proxima_bomba

    lw s7, 0(t3)
    addi s7, s7, 1
    sw s7, 0(t3)

    li s8, 8000 #tempo q a bomba vai demorar pra explodir
    bne s7, s8, proxima_bomba

    mv a1, t5
    lw a2, 0(t2)
    li a3, 0

    # salva os ponteiros antes do jal
    addi sp, sp, -12
    sw t1, 0(sp)
    sw t2, 4(sp)
    sw t3, 8(sp)

    jal explosao

    # recupera ponteiros
    lw t1, 0(sp)
    lw t2, 4(sp)
    lw t3, 8(sp)
    addi sp, sp, 12

    # limpa bomba
    li t6, -1
    sw t6, 0(t1)
    sw t6, 0(t2)
    sw zero, 0(t3)

proxima_bomba:
    addi t0, t0, 1
    addi t1, t1, 4
    addi t2, t2, 4
    addi t3, t3, 4
    blt t0, t4, atualiza_loop
    ret

# EXPLOSAO
explosao:
    # limpa flag de dano
    la t6, jogador_atingido
    sw zero, 0(t6)

    # centro
    la a0, bomba
    call PRINT
    call destruir_obstaculo
    
    # cima
    addi a2, a2, -16
    call PRINT
    call destruir_obstaculo
    addi a2, a2, 16
    
    # baixo
    addi a2, a2, 16
    call PRINT
    call destruir_obstaculo
    addi a2, a2, -16
    
    # esquerda
    addi a1, a1, -16
    call PRINT
    call destruir_obstaculo
    addi a1, a1, 16
    
    # direita
    addi a1, a1, 16
    call PRINT
    call destruir_obstaculo
    addi a1, a1, -16

    # checa dano
    mv t1, a1
    mv t2, a2

    call checa_dano      # centro
    addi t2, t2, -16
    call checa_dano      # cima
    addi t2, t2, 32
    call checa_dano      # baixo
    addi t2, t2, -16

    addi t1, t1, -16
    call checa_dano      # esquerda
    addi t1, t1, 32
    call checa_dano      # direita
    addi t1, t1, -16

    li t3, 100000
espera_explosao:
    addi t3, t3, -1
    bnez t3, espera_explosao

    # apagar explos?o: centro
    la a0, char_preto
    mv a1, a1
    mv a2, a2
    li a3, 0
    call PRINT
    
    # apagar posi??o do vetor da bomba correspondente ao centro
    la t0, bomba_x
    la t1, bomba_y
    li t2, 0
    
    apaga_bomba_central_loop:
    li t3, 5
    beq t2, t3, fim_apaga_bomba

    lw t4, 0(t0)       # bomba_x[i]
    lw t5, 0(t1)       # bomba_y[i]

    beq t4, a1, confere_y
    j proxima_pos

confere_y:
    beq t5, a2, limpa_slot
    j proxima_pos

proxima_pos:
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, 1
    j apaga_bomba_central_loop

limpa_slot:
    li t6, -1
    sw t6, 0(t0)
    sw t6, 0(t1)
    j fim_apaga_bomba

fim_apaga_bomba:
    addi a2, a2, -16
    call PRINT
    addi a2, a2, 32
    call PRINT
    addi a2, a2, -16

    addi a1, a1, -16
    call PRINT
    addi a1, a1, 32
    call PRINT
    addi a1, a1, -16

    # se levou dano, resetar
    la t6, jogador_atingido
    lw s10, 0(t6)
    beqz s10, volta
    jal FIMLOOP1
    
volta:
    j loop

# DANO
checa_dano:
    bne t1, s1, no_dano
    bne t2, s3, no_dano
    la t3, vidas
    lw t4, 0(t3)
    addi t4, t4, -1
    sw t4, 0(t3)

    la t5, jogador_atingido
    li t6, 1
    sw t6, 0(t5)
    
no_dano:
    ret
    
# fun??o que remove obst?culos destrut?veis (valor 255) da mem?ria de colis?o
# n?o modifica obst?culos fixos (valor 50)
# entradas:
# a1 = x (pos_x da explos?o)
# a2 = y (pos_y da explos?o)
destruir_obstaculo:
    la t0, mapa_colisao_mem     # base da mem?ria de colis?o

    srli t1, a1, 4              # t1 = coluna (x / 16)
    srli t2, a2, 4              # t2 = linha (y / 16)

    li t3, 20                   # largura do mapa em c?lulas
    mul t2, t2, t3              # t2 = linha * largura
    add t1, t1, t2              # offset = linha * largura + coluna

    add t1, t0, t1              # endere?o = base + offset
    lbu t4, 0(t1)               # l? valor atual

    li t5, 255
    bne t4, t5, fim_destruir    # s? modifica se for exatamente 255

    li t6, 0
    sb t6, 0(t1)                # zera a posi??o (remove obst?culo)

fim_destruir:
    ret

##******** DIREITA
right:
	li t0, 304           # limite do mapa na horizontal
	addi t1, s1, 16
	bgt t1, t0, loop     # se passar do limite, n?o anda
	
	mv a1, t1
    	mv a2, s3
    	jal verifica_colisao
    	beqz t6, loop       # impede andar se colidiu
    
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
	
	addi t1, s1, -16   # destino: 16 px ? esquerda
    	mv a1, t1          # novo X
    	mv a2, s3          # Y atual
    	jal verifica_colisao
    	beqz t6, loop      # colidiu? volta ao loop
    	
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
	
	addi t1, s3, -16   # destino: 16 px acima
    	mv a1, s1          # x atual
    	mv a2, t1          # novo y
    	jal verifica_colisao
    	beqz t6, loop
    	
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
	
	addi t1, s3, 16    # destino: 16 px abaixo
    	mv a1, s1          # x atual
    	mv a2, t1          # novo y
    	jal verifica_colisao
    	beqz t6, loop

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
