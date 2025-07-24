.include "../data/barbiepersonagem.data"
.include "char_branco.s"
.include "../data/explosao_fundo_rosa_right.data"
.include "../data/explosao_fundo_preto_right.data"
.include "../data/explosao_fundo_preto_up.data"
.include "../data/explosao_fundo_rosa_up.data"
.include "charpreto.s"
.include "../data/bibble1.s"
.include "bibble2.s"
.include "char_pretoMAPA2.s"
.include "bombinha.s"
.include "bombinha2.s"
.include "mapa2.data"
.include "mapa1.data"
.include "../data/barbielado.data"
.include "../data/barbielado2.data"
.include "mapa2_colisao.data"
.include "blocoquebravelmapa2.data"
.include "blocoinquebravelmapa1.data"
.include "../data/tela_inicial.data"
.include "oppen.data"
.include "../data/victory.data"

.data
char_x: .word 0
bomba_x: .word -1, -1, -1, -1, -1
bomba_y: .word -1, -1, -1, -1, -1
bomba_timer: .word 0, 0, 0, 0, 0
vidas: .word 3
pontuacao: .word 0
jogador_atingido: .word 0   # usado pra resetar dps da explos?o
mapa_colisao_mem: .space 76800
tempo_fase_inimigo: .word 200
inimigo_x: .word 48      # posição inicial x
inimigo_y: .word 80      # posição inicial y
inimigo_x2: .word 80      # posição inicial x
inimigo_y2: .word 80      # posição inicial y
estado_inimigo: .word 0
estado_inimigo2: .word 0
estado_jogo: .word 0
inimigo1_morte: .word 0
inimigo2_morte: .word 0
inimigo_x3: .word 64      # posição inicial x
inimigo_y3: .word 112      # posição inicial y
estado_inimigo3: .word 0
inimigo3_morte: .word 0
FASE2: .word 0

# Música do mapa 1
num1: .word 103
NOTAS1: 
    .word 67,280,64,280,67,280,72,280,69,1200,65,280,62,280,65,280,71,280,67,600,65,280,64,600,60,280,64,280,60,280,65,600,60,600,60,600,65,280,64,280,67,600,65,600,67,280,64,280,67,280,72,280,69,900,67,280,65,280,62,280,65,280,71,280,67,600,65,280,64,600,60,280,64,280,60,280,65,600,60,600,65,280,65,280,65,280,64,280,67
.text
   li s11, 0

.globl main

main:
    jal copiar_mapa_colisao
    jal PRINTARINICIO
    jal LOOP1
    
loop:
    lw s9, FASE2
    bne s9, zero, loop2
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
    li t1, 32
    beq s0, t1, PAUSE
    li t1, 27
    beq s0, t1, STOPGAME

sem_tecla:
    jal atualiza_bombas
    addi s11, s11, 1
    lw s9, inimigo3_morte
    bne s9, zero, PRINTARINICIO2
    lw s9, inimigo1_morte
    beq s9, zero, INIMIGO
    bne s9, zero, INIMIGO2
    j loop
    
PAUSE:
     jal GetCharacter
     
     li t1, 32
     beq s0, t1, loop
     
STOPGAME: li s11, 0
    li s1, 0xFF000000
    li s2, 0xFF012C00
    la s0, victory
    addi s0, s0, 8
    j LOOP4
LOOP4: 
        beq s1, s2, FIM4
	lw t0, 0(s0)
	sw t0, 0(s1)
	addi s0, s0, 4
	addi s1, s1, 4
        j LOOP4
FIM4:
    la t3, estado_jogo
    li t4, 0
    sw t4, 0(t3)
    jal MENUFASE2
MENUFASE2:
    la t3, estado_jogo
    lw t4, 0(t3)
    bnez t4, GETCHARFASE2  # Se estado_jogo ? 0, pula a música

    jal tocarMusica1
    j GETCHARFASE2

GETCHARFASE2:
    jal GetCharacter
    li t1, 13        # ENTER (CR)
    li t2, 10        # ENTER (LF)
    beq s0, t1, FIMENUFASE2
    beq s0, t2, FIMENUFASE2
    
FIMENUFASE2:
    li a7, 10
    ecall
    	
PRINTARINICIO:
    li s11, 0
    li s1, 0xFF000000
    li s2, 0xFF012C00
    la s0, Telainicial
    addi s0, s0, 8
    j LOOP3
LOOP3: 
        beq s1, s2, MENU
	lw t0, 0(s0)
	sw t0, 0(s1)
	addi s0, s0, 4
	addi s1, s1, 4
        j LOOP3
MENU:
    la t3, estado_jogo
    lw t4, 0(t3)
    bnez t4, GETCHAR  # Se estado_jogo ? 0, pula a música

    jal tocarMusica1
    j GETCHAR

GETCHAR:
    jal GetCharacter
    li t1, 13        # ENTER (CR)
    li t2, 10        # ENTER (LF)
    beq s0, t1, FIMENU
    beq s0, t2, FIMENU
    
FIMENU:
    li s11, 0
    li s1, 0xFF000000
    li s2, 0xFF012C00
    la s0, mapa2
    addi s0, s0, 8
    j LOOP1
    
### PRIMEIRA MÚSICA ####
tocarMusica1:
    la s6, num1  # Carrega o endereço do número de notas em s0
    lw s5, 0(s6) # Lê o número de notas
    la s6, NOTAS1 # Define o endereço das notas
    li t0, 0     # Zera o contador de notas
    li a2, 28    # Instrumento
    li a3, 120   # Volume

.loop1:
    beq t0, s5, .fim1 # Verifica se contador chegou ao final
    lw a0, 0(s6) # Carrega a nota
    lw a1, 4(s6) # Carrega a duração da nota
    li a7, 31    # Syscall para tocar a nota
    ecall        # Faz uma pausa
    mv a0, a1    # Passa a duração da nota para a pausa
    li a7, 32    # Define a chamada se syscal
    ecall        # Faz uma pausa  
    addi s6, s6, 8 # Avança para as próximas notas
    addi t0, t0, 1 # Adiciona o contador
    j .loop1  # Repete o loop

.fim1:
    # Aqui mudamos o estado do jogo pra 1
    la t3, estado_jogo
    li t4, 1
    sw t4, 0(t3)
    ret # Retorna a função 

## LOOP PARA IMPRIMIR PRIMEIRA FASE ##
LOOP1: 
        beq s1, s2, FIMLOOP1
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
        
#PRIMEIRO INIMIGO FASE 1        
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
    li s5, 64 ## ao inves de ser isso, seria
    #lw s5, inimigo_x
    li s6, 80
    #lw s6, inimigo_y
    
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    # apaga posição antiga (48, 80)
    #adiciona -16 no inimigo_x
    li s5, 48
    li s6, 80
    la a0, bibble1f
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop

inimigo2:
    # apaga posição antiga (48, 80)
    # se eu não me engano aqui o inimigo_x já vai ser 48, mas checa direito isso pra não dar erro
    li s5, 48
    li s6, 80
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    # printa na nova posição (64, 80)
    # adiciona 16 no inimigo_x
    li s5, 64
    li s6, 80
    la a0, bibble2f
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    j loop

#SEGUNDO INIMIGO FASE 1
INIMIGO2:
    lw s9, inimigo2_morte
    bne s9, zero, INIMIGO3
    lw t0, tempo_fase_inimigo   # carrega 500 em t0
    rem t1, s11, t0             # t1 = s11 % 500
    bne t1, zero, verifica_estado2  # se NÃO for múltiplo, só verifica o estado

    # se for múltiplo, inverte o estado
    la t2, estado_inimigo2
    lw t3, 0(t2)
    xori t3, t3, 1              # 0 ? 1
    sw t3, 0(t2)

verifica_estado2:
    la t2, estado_inimigo2
    lw t3, 0(t2)
    beq t3, zero, inimigo3
    j inimigo4

inimigo3:
    # printa na nova posição (64, 80)
    li s5, 80 ## ao inves de ser isso, seria
    #lw s5, inimigo_x
    li s6, 80
    #lw s6, inimigo_y
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    # apaga posição antiga (48, 80)
    #adiciona -16 no inimigo_x
    li s5, 80
    li s6, 96
    la a0, bibble1f
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop

inimigo4:
    # apaga posição antiga (48, 80)
    li s5, 80
    li s6, 96
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    # printa na nova posição (64, 80)
    # adiciona 16 no inimigo_x
    li s5, 80
    li s6, 80
    la a0, bibble1f
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    j loop

#TERCEIRO INIMIGO FASE 1
INIMIGO3:
    lw s9, inimigo3_morte
    bne s9, zero, loop
    lw t0, tempo_fase_inimigo   # carrega 500 em t0
    rem t1, s11, t0             # t1 = s11 % 500
    bne t1, zero, verifica_estado3  # se NÃO for múltiplo, só verifica o estado

    # se for múltiplo, inverte o estado
    la t2, estado_inimigo3
    lw t3, 0(t2)
    xori t3, t3, 1              # 0 ? 1
    sw t3, 0(t2)

verifica_estado3:
    la t2, estado_inimigo3
    lw t3, 0(t2)
    beq t3, zero, inimigo5
    j inimigo6

inimigo5:
    # printa na nova posição (64, 80)
    li s5, 80 ## ao inves de ser isso, seria
    li s6, 112
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    # apaga posição antiga (48, 80)
    #adiciona -16 no inimigo_x
    li s5, 96
    li s6, 112
    la a0, bibble1f
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop

inimigo6:
    # apaga posição antiga (48, 80)
    li s5, 96
    li s6, 112
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    # printa na nova posição (64, 80)
    # adiciona 16 no inimigo_x
    li s5, 80
    li s6, 112
    la a0, bibble1f
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

    bnez t4, colidiu            # se t4 != 0 -> colidiu
    li t6, 1                    # n?o colidiu
    jr ra

colidiu:
    li t6, 0
    mv a0, t4
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
    lw s9, FASE2
    bne s9, zero, BOMBA2
BOMBA1:
    la a0, bomba
    j depois_bomba
BOMBA2:
    la a0, bomba_amarela
depois_bomba:
    # usar a0 com PRINT
    mv a1, s1
    mv a2, s3
    li a3, 0
    call PRINT
    lw s9, FASE2
    bne s9, zero, CHAR2
CHAR1:
    la a0, char
    j depois_CHAR
CHAR2:
    la a0, charFASE2
depois_CHAR:
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

    li s8, 800 #tempo q a bomba vai demorar pra explodir
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
    lw s9, FASE2
    bne s9, zero, BOMBA2E
BOMBA1E:
    la a0, explosao_fundorosa_up
    j depois_bombaE
BOMBA2E:
    la a0, explosao_fundopreto_up
depois_bombaE:
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

    lw s9, FASE2
    bne s9, zero, BOMBA2H
BOMBA1H:
    la a0, explosao_fundorosa
    j depois_bombaH
BOMBA2H:
    la a0, explosao_fundopreto ## mudar aqui
depois_bombaH:
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

    addi t2, t2, -16
    addi t2, t2, 32
    addi t2, t2, -16

    addi t1, t1, -16
    addi t1, t1, 32
    addi t1, t1, -16

    li t3, 100000
espera_explosao:
    addi t3, t3, -1
    bnez t3, espera_explosao

    # apagar explos?o: centro
    lw s9, FASE2
    bne s9, zero, CHAR2c
CHAR1c:
    la a0, char_preto
    j DEPOIS_CHAR
CHAR2c:
    la a0, fundo_mapa2
DEPOIS_CHAR:
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
    
    jal destruir_obstaculo
    lw s9, inimigo1_morte
    beq s9, zero, checa_dano_inimigo
    bne s9, zero, checa_dano_inimigo2
    # se levou dano, resetar
    la t6, jogador_atingido
    lw s10, 0(t6)
    beqz s10, volta
    jal FIMLOOP1
checa_dano_inimigo:
    la t0, inimigo_x
    lw t1, 0(t0)     # t1 = inimigo_x
    la t0, inimigo_y
    lw t2, 0(t0)     # t2 = inimigo_y

    # centro
    beq a1, t1, compara_y_centro
    j checa_cima
compara_y_centro:
    beq a2, t2, mata_jogo

checa_cima:
    addi t3, a2, -16
    beq a1, t1, compara_y_cima
    j checa_baixo
compara_y_cima:
    beq t3, t2, mata_jogo

checa_baixo:
    addi t3, a2, 16
    beq a1, t1, compara_y_baixo
    j checa_esquerda
compara_y_baixo:
    beq t3, t2, mata_jogo

checa_esquerda:
    addi t3, a1, -16
    beq t3, t1, compara_y_esq
    j checa_direita
compara_y_esq:
    beq a2, t2, mata_jogo

checa_direita:
    addi t3, a1, 16
    beq t3, t1, compara_y_dir
    j fim_checa
compara_y_dir:
    beq a2, t2, mata_jogo
fim_checa:
    j loop

mata_jogo:
    mv t1, s5
    mv t2, s6
    lw s9, FASE2
    bne s9, zero, FUNDO2A
FUNDO1A:
    la a0, char_preto
    j depois_FUNDOA
FUNDO2A:
    la a0, fundo_mapa2
depois_FUNDOA:
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    la t0, inimigo1_morte    # carrega o endereço da variável
    li t1, 1                 # carrega o valor 1
    sw t1, 0(t0)             # armazena o 1 na memória
    la t0, pontuacao
    li t1, 10
    sw t1, 0(t0)
    la t0, pontuacao   
    lw a0, 0(t0)      
    li a7, 1          
    ecall
    j loop
volta:
    j loop

checa_dano_inimigo2:
    lw s9, inimigo2_morte
    bne s9, zero, checa_dano_inimigo3
    la t0, inimigo_x2
    lw t1, 0(t0)     # t1 = inimigo_x
    la t0, inimigo_y2
    lw t2, 0(t0)     # t2 = inimigo_y

    # centro
    beq a1, t1, compara_y_centro2
    j checa_cima2
compara_y_centro2:
    beq a2, t2, mata_jogo2

checa_cima2:
    addi t3, a2, -16
    beq a1, t1, compara_y_cima2
    j checa_baixo2
compara_y_cima2:
    beq t3, t2, mata_jogo2

checa_baixo2:
    addi t3, a2, 16
    beq a1, t1, compara_y_baixo2
    j checa_esquerda2
compara_y_baixo2:
    beq t3, t2, mata_jogo2

checa_esquerda2:
    addi t3, a1, -16
    beq t3, t1, compara_y_esq2
    j checa_direita2
compara_y_esq2:
    beq a2, t2, mata_jogo2

checa_direita2:
    addi t3, a1, 16
    beq t3, t1, compara_y_dir2
    j fim_checa2
compara_y_dir2:
    beq a2, t2, mata_jogo2

fim_checa2:
    j loop

mata_jogo2:
    mv t1, s5
    mv t2, s6
    lw s9, FASE2
    bne s9, zero, FUNDO2B
FUNDO1B:
    la a0, char_preto
    j depois_FUNDOB
FUNDO2B:
    la a0, fundo_mapa2
depois_FUNDOB:
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    la t0, inimigo2_morte    # carrega o endereço da variável
    li t1, 1                 # carrega o valor 1
    sw t1, 0(t0)             # armazena o 1 na memória
    la t0, pontuacao
    li t1, 20
    sw t1, 0(t0)
    la t0, pontuacao   
    lw a0, 0(t0)      
    li a7, 1          
    ecall
    
    j loop
volta2:
    j loop
    
checa_dano_inimigo3:
    la t0, inimigo_x3
    lw t1, 0(t0)     # t1 = inimigo_x
    la t0, inimigo_y3
    lw t2, 0(t0)     # t2 = inimigo_y

    # centro
    beq a1, t1, compara_y_centro3
    j checa_cima3
compara_y_centro3:
    beq a2, t2, mata_jogo3

checa_cima3:
    addi t3, a2, -16
    beq a1, t1, compara_y_cima3
    j checa_baixo3
compara_y_cima3:
    beq t3, t2, mata_jogo3

checa_baixo3:
    addi t3, a2, 16
    beq a1, t1, compara_y_baixo3
    j checa_esquerda3
compara_y_baixo3:
    beq t3, t2, mata_jogo3

checa_esquerda3:
    addi t3, a1, -16
    beq t3, t1, compara_y_esq3
    j checa_direita3
compara_y_esq3:
    beq a2, t2, mata_jogo3

checa_direita3:
    addi t3, a1, 16
    beq t3, t1, compara_y_dir3
    j fim_checa3
compara_y_dir3:
    beq a2, t2, mata_jogo3

fim_checa3:
    j loop

mata_jogo3:
    mv t1, s5
    mv t2, s6
    la a0, char_preto
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    la t0, inimigo3_morte    # carrega o endereço da variável
    li t1, 1                 # carrega o valor 1
    sw t1, 0(t0)             # armazena o 1 na memória
    la t0, pontuacao
    li t1, 30
    sw t1, 0(t0)
    
    j loop
volta3:
    j loop
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

    li t5, 50
    beq t4, t5, fim_destruir    # s? modifica se for exatamente 255

    li t6, 0
    sb t6, 0(t1)                # zera a posi??o (remove obst?culo)
    li t5, 50
    beq t4, t5, printar_fixo    # se for 50 (fixo), apenas printa e sai

    # Caso não seja fixo, destrói:
    li t6, 0
    sb t6, 0(t1)                # zera a célula (remove obstáculo)
    j fim_destruir

# Se a célula era 50, printa ela novamente no mapa
printar_fixo:
    
    li t5, 32
    li t4, 64
    la a0, bloco_inquebravel                 # caractere a desenhar
    mv a1, t5                   # x
    mv a2, t4                   # y
    li a3, 0                    # camada ou plano
    call PRINT

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
	lw s9, FASE2
        bne s9, zero, BOMBA2A
BOMBA1A:
    la a0, bomba
    j depois_bombaA
BOMBA2A:
    la a0, bomba_amarela
depois_bombaA:
     j printa_saida_d

proxima_bomba_d:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_d

	lw s9, FASE2
        bne s9, zero, CHAR2D
CHAR1D:
    la a0, char_preto
    j printa_saida_d
CHAR2D:
    la a0, fundo_mapa2
printa_saida_d:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	addi s1, s1, 16
	la a0, char_lado2
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
	lw s9, FASE2
        bne s9, zero, BOMBA2B
BOMBA1B:
    la a0, bomba
    j depois_bombaB
BOMBA2B:
    la a0, bomba_amarela
depois_bombaB:
	j printa_saida_e

proxima_bomba_e:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_e

	lw s9, FASE2
        bne s9, zero, CHAR2E
CHAR1E:
    la a0, char_preto
    j printa_saida_e
CHAR2E:
    la a0, fundo_mapa2
    
printa_saida_e:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	addi s1, s1, -16
	la a0, char_lado
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
	lw s9, FASE2
        bne s9, zero, BOMBA2C
BOMBA1C:
    la a0, bomba
    j depois_bombaC
BOMBA2C:
    la a0, bomba_amarela
depois_bombaC:
	j printa_saida_c

proxima_bomba_c:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_c

	lw s9, FASE2
        bne s9, zero, CHAR2F
CHAR1F:
    la a0, char_preto
    j printa_saida_c
CHAR2F:
    la a0, fundo_mapa2
printa_saida_c:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	addi s3, s3, -16
	lw s9, FASE2
        bne s9, zero, CHAR2A
CHAR1A:
    la a0, char
    j depois_CHARA
CHAR2A:
    la a0, charFASE2
depois_CHARA:
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
	lw s9, FASE2
        bne s9, zero, BOMBA2D
BOMBA1D:
    la a0, bomba
    j depois_bombaD
BOMBA2D:
    la a0, bomba_amarela
depois_bombaD:
    j printa_saida_b

proxima_bomba_b:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_b

	lw s9, FASE2
        bne s9, zero, CHAR2b
CHAR1b:
    la a0, char_preto
    j printa_saida_b
CHAR2b:
    la a0, fundo_mapa2

printa_saida_b:
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT

	addi s3, s3, 16
	lw s9, FASE2
        bne s9, zero, CHAR2B
CHAR1B:
    la a0, char
    j depois_CHARB
CHAR2B:
    la a0, charFASE2
depois_CHARB:
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
	
#SEGUNDA FASE DO JOGO
PRINTARINICIO2:
    li s11, 0
    li s1, 0xFF000000
    li s2, 0xFF012C00
    la s0, mapa_1
    addi s0, s0, 8
    j LOOPFASE2
LOOPFASE2: 
        beq s1, s2, FIM5
	lw t0, 0(s0)
	sw t0, 0(s1)
	addi s0, s0, 4
	addi s1, s1, 4
        j LOOPFASE2
FIM5:
	li s1, 16  # pos x do jogador
    	li s3, 48  # pos y do jogador
    	la a0, charFASE2
	mv a1, s1
	mv a2, s3
	li a3, 0
	call PRINT
	la t0, inimigo1_morte    # carrega o endereço da variável
    	li t1, 0                 # carrega o valor 0
    	sw t1, 0(t0)             # armazena o 0 na memória
	la t0, inimigo2_morte    # carrega o endereço da variável
    	li t1, 0                 # carrega o valor 0
    	sw t1, 0(t0)             # armazena o 0 na memória
    	la t0, inimigo3_morte    # carrega o endereço da variável
    	li t1, 0                 # carrega o valor 0
    	sw t1, 0(t0)             # armazena o 0 na memória
    	la t0, FASE2   # carrega o endereço da variável
    	li t1, 1                # carrega o valor 0
    	sw t1, 0(t0)             # armazena o 0 na memória
    	j loop2

loop2:
    jal IsCharacterThere
    beq s0, zero, sem_tecla2

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
    li t1, 32
    beq s0, t1, PAUSE
    li t1, 27
    beq s0, t1, STOPGAME

sem_tecla2:
    jal atualiza_bombas
    addi s11, s11, 1
    lw s9, inimigo3_morte
    bne s9, zero, STOPGAME
    lw s9, inimigo1_morte
    beq s9, zero, INIMIGOFASE2
    bne s9, zero, INIMIGO2FASE2
    j loop2
    
#TUDO PARA A FASE 2!!!!
#!!!!!FASE2!!!!!!
#PRIMEIRO INIMIGO FASE 2        
INIMIGOFASE2:
    lw t0, tempo_fase_inimigo   # carrega 500 em t0
    rem t1, s11, t0             # t1 = s11 % 500
    bne t1, zero, verifica_estadoFASE2  # se NÃO for múltiplo, só verifica o estado

    # se for múltiplo, inverte o estado
    la t2, estado_inimigo
    lw t3, 0(t2)
    xori t3, t3, 1              # 0 ? 1
    sw t3, 0(t2)

verifica_estadoFASE2:
    la t2, estado_inimigo
    lw t3, 0(t2)
    beq t3, zero, inimigo1FASE2
    j inimigo2FASE2

inimigo1FASE2:
    # printa na nova posição (64, 80)
    li s5, 64 ## ao inves de ser isso, seria
    #lw s5, inimigo_x
    li s6, 80
    #lw s6, inimigo_y
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    # apaga posição antiga (48, 80)
    #adiciona -16 no inimigo_x
    li s5, 48
    li s6, 80
    la a0, inimigofase2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop2

inimigo2FASE2:
    # apaga posição antiga (48, 80)
    # se eu não me engano aqui o inimigo_x já vai ser 48, mas checa direito isso pra não dar erro
    li s5, 48
    li s6, 80
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    # printa na nova posição (64, 80)
    # adiciona 16 no inimigo_x
    li s5, 64
    li s6, 80
    la a0, inimigofase2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    j loop2

#SEGUNDO INIMIGO FASE 1
INIMIGO2FASE2:
    lw s9, inimigo2_morte
    bne s9, zero, INIMIGO3FASE2
    lw t0, tempo_fase_inimigo   # carrega 500 em t0
    rem t1, s11, t0             # t1 = s11 % 500
    bne t1, zero, verifica_estado2FASE2  # se NÃO for múltiplo, só verifica o estado

    # se for múltiplo, inverte o estado
    la t2, estado_inimigo2
    lw t3, 0(t2)
    xori t3, t3, 1              # 0 ? 1
    sw t3, 0(t2)

verifica_estado2FASE2:
    la t2, estado_inimigo2
    lw t3, 0(t2)
    beq t3, zero, inimigo3FASE2
    j inimigo4FASE2

inimigo3FASE2:
    # printa na nova posição (64, 80)
    li s5, 80 ## ao inves de ser isso, seria
    #lw s5, inimigo_x
    li s6, 80
    #lw s6, inimigo_y
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    # apaga posição antiga (48, 80)
    #adiciona -16 no inimigo_x
    li s5, 80
    li s6, 96
    la a0, inimigofase2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop2

inimigo4FASE2:
    # apaga posição antiga (48, 80)
    li s5, 80
    li s6, 96
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    # printa na nova posição (64, 80)
    # adiciona 16 no inimigo_x
    li s5, 80
    li s6, 80
    la a0, inimigofase2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    j loop2

#TERCEIRO INIMIGO FASE 1
INIMIGO3FASE2:
    lw s9, inimigo3_morte
    bne s9, zero, loop2
    lw t0, tempo_fase_inimigo   # carrega 500 em t0
    rem t1, s11, t0             # t1 = s11 % 500
    bne t1, zero, verifica_estado3FASE2  # se NÃO for múltiplo, só verifica o estado

    # se for múltiplo, inverte o estado
    la t2, estado_inimigo3
    lw t3, 0(t2)
    xori t3, t3, 1              # 0 ? 1
    sw t3, 0(t2)

verifica_estado3FASE2:
    la t2, estado_inimigo3
    lw t3, 0(t2)
    beq t3, zero, inimigo5FASE2
    j inimigo6FASE2

inimigo5FASE2:
    # printa na nova posição (64, 80)
    li s5, 80 ## ao inves de ser isso, seria
    li s6, 112
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    # apaga posição antiga (48, 80)
    #adiciona -16 no inimigo_x
    li s5, 96
    li s6, 112
    la a0, inimigofase2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop2

inimigo6FASE2:
    # apaga posição antiga (48, 80)
    li s5, 96
    li s6, 112
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    # printa na nova posição (64, 80)
    # adiciona 16 no inimigo_x
    li s5, 80
    li s6, 112
    la a0, inimigofase2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    j loop2