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
    jal atualiza_bombasFASE2
    li t5, 36
    li t6, 60
    la a0, bloco_inquebravel_b
    mv a1, t5
    mv a2, t6
    li a3, 0
    call PRINT
    li s0, 0
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
    la a0, char
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
    la a0, char
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
    la a0, char
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
    la a0, char
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
    la a0, char
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    
    j loop

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
    la a0, char
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT

    j loop

# BOMBA
bombFASE2:
    li t0, 0
    la t1, bomba_x
    la t2, bomba_y
    la t6, bomba_timer

encontra_vagaFASE2:
    lw t3, 0(t1)
    li t4, -1
    beq t3, t4, salva_posFASE2
    addi t0, t0, 1
    addi t1, t1, 4
    addi t2, t2, 4
    addi t6, t6, 4
    li t5, 5
    blt t0, t5, encontra_vagaFASE2
    ret

salva_posFASE2:
    sw s1, 0(t1)
    sw s3, 0(t2)
    sw zero, 0(t6)

continua_bombaFASE2:
    la a0, bomba_vermelha
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
atualiza_bombasFASE2:
    li t0, 0
    la t1, bomba_x
    la t2, bomba_y
    la t3, bomba_timer
    li t4, 5

atualiza_loopFASE2:
    lw t5, 0(t1)
    li t6, -1
    beq t5, t6, proxima_bombaFASE2

    lw s7, 0(t3)
    addi s7, s7, 1
    sw s7, 0(t3)

    li s8, 800 #tempo q a bomba vai demorar pra explodir
    bne s7, s8, proxima_bombaFASE2

    mv a1, t5
    lw a2, 0(t2)
    li a3, 0

    # salva os ponteiros antes do jal
    addi sp, sp, -12
    sw t1, 0(sp)
    sw t2, 4(sp)
    sw t3, 8(sp)

    jal explosaoFASE2

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

proxima_bombaFASE2:
    addi t0, t0, 1
    addi t1, t1, 4
    addi t2, t2, 4
    addi t3, t3, 4
    blt t0, t4, atualiza_loopFASE2
    ret

# EXPLOSAO
explosaoFASE2:
    # limpa flag de dano
    la t6, jogador_atingido
    sw zero, 0(t6)

    # centro
    la a0, bomba_vermelha
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

    addi t2, t2, -16
    addi t2, t2, 32
    addi t2, t2, -16

    addi t1, t1, -16
    addi t1, t1, 32
    addi t1, t1, -16

    li t3, 100000
espera_explosaoFASE2:
    addi t3, t3, -1
    bnez t3, espera_explosaoFASE2

    # apagar explos?o: centro
    la a0, fundo_mapa2
    mv a1, a1
    mv a2, a2
    li a3, 0
    call PRINT
    
    # apagar posi??o do vetor da bomba correspondente ao centro
    la t0, bomba_x
    la t1, bomba_y
    li t2, 0
    
    apaga_bomba_central_loopFASE2:
    li t3, 5
    beq t2, t3, fim_apaga_bombaFASE2

    lw t4, 0(t0)       # bomba_x[i]
    lw t5, 0(t1)       # bomba_y[i]

    beq t4, a1, confere_yFASE2
    j proxima_posFASE2

confere_yFASE2:
    beq t5, a2, limpa_slotFASE2
    j proxima_posFASE2

proxima_posFASE2:
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, 1
    j apaga_bomba_central_loopFASE2

limpa_slotFASE2:
    li t6, -1
    sw t6, 0(t0)
    sw t6, 0(t1)
    j fim_apaga_bombaFASE2

fim_apaga_bombaFASE2:
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
    beq s9, zero, checa_dano_inimigoFASE2
    bne s9, zero, checa_dano_inimigo2FASE2

    # se levou dano, resetar
    la t6, jogador_atingido
    lw s10, 0(t6)
    beqz s10, voltaFASE2
checa_dano_inimigoFASE2:
    la t0, inimigo_x
    lw t1, 0(t0)     # t1 = inimigo_x
    la t0, inimigo_y
    lw t2, 0(t0)     # t2 = inimigo_y

    # centro
    beq a1, t1, compara_y_centroFASE2
    j checa_cimaFASE2
compara_y_centroFASE2:
    beq a2, t2, mata_jogoFASE2

checa_cimaFASE2:
    addi t3, a2, -16
    beq a1, t1, compara_y_cimaFASE2
    j checa_baixoFASE2
compara_y_cimaFASE2:
    beq t3, t2, mata_jogoFASE2

checa_baixoFASE2:
    addi t3, a2, 16
    beq a1, t1, compara_y_baixoFASE2
    j checa_esquerdaFASE2
compara_y_baixoFASE2:
    beq t3, t2, mata_jogoFASE2

checa_esquerdaFASE2:
    addi t3, a1, -16
    beq t3, t1, compara_y_esqFASE2
    j checa_direitaFASE2
compara_y_esqFASE2:
    beq a2, t2, mata_jogoFASE2

checa_direitaFASE2:
    addi t3, a1, 16
    beq t3, t1, compara_y_dirFASE2
    j fim_checaFASE2
compara_y_dirFASE2:
    beq a2, t2, mata_jogoFASE2

fim_checaFASE2:
    ret

mata_jogoFASE2:
    mv t1, s5
    mv t2, s6
    la a0, fundo_mapa2
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
voltaFASE2:
    j loop

checa_dano_inimigo2FASE2:
    lw s9, inimigo2_morte
    bne s9, zero, checa_dano_inimigo3FASE2
    la t0, inimigo_x2
    lw t1, 0(t0)     # t1 = inimigo_x
    la t0, inimigo_y2
    lw t2, 0(t0)     # t2 = inimigo_y

    # centro
    beq a1, t1, compara_y_centro2FASE2
    j checa_cima2FASE2
compara_y_centro2FASE2:
    beq a2, t2, mata_jogo2FASE2

checa_cima2FASE2:
    addi t3, a2, -16
    beq a1, t1, compara_y_cima2FASE2
    j checa_baixo2FASE2
compara_y_cima2FASE2:
    beq t3, t2, mata_jogo2FASE2

checa_baixo2FASE2:
    addi t3, a2, 16
    beq a1, t1, compara_y_baixo2FASE2
    j checa_esquerda2FASE2
compara_y_baixo2FASE2:
    beq t3, t2, mata_jogo2FASE2

checa_esquerda2FASE2:
    addi t3, a1, -16
    beq t3, t1, compara_y_esq2FASE2
    j checa_direita2FASE2
compara_y_esq2FASE2:
    beq a2, t2, mata_jogo2FASE2

checa_direita2FASE2:
    addi t3, a1, 16
    beq t3, t1, compara_y_dir2FASE2
    j fim_checa2FASE2
compara_y_dir2FASE2:
    beq a2, t2, mata_jogo2FASE2

fim_checa2FASE2:
    ret

mata_jogo2FASE2:
    mv t1, s5
    mv t2, s6
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    la t0, inimigo2_morte    # carrega o endereço da variável
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
volta2FASE2:
    j loop
    
checa_dano_inimigo3FASE2:
    la t0, inimigo_x3
    lw t1, 0(t0)     # t1 = inimigo_x
    la t0, inimigo_y3
    lw t2, 0(t0)     # t2 = inimigo_y

    # centro
    beq a1, t1, compara_y_centro3FASE2
    j checa_cima3FASE2
compara_y_centro3FASE2:
    beq a2, t2, mata_jogo3FASE2

checa_cima3FASE2:
    addi t3, a2, -16
    beq a1, t1, compara_y_cima3FASE2
    j checa_baixo3FASE2
compara_y_cima3FASE2:
    beq t3, t2, mata_jogo3FASE2

checa_baixo3FASE2:
    addi t3, a2, 16
    beq a1, t1, compara_y_baixo3FASE2
    j checa_esquerda3FASE2
compara_y_baixo3FASE2:
    beq t3, t2, mata_jogo3FASE2

checa_esquerda3FASE2:
    addi t3, a1, -16
    beq t3, t1, compara_y_esq3FASE2
    j checa_direita3FASE2
compara_y_esq3FASE2:
    beq a2, t2, mata_jogo3FASE2

checa_direita3FASE2:
    addi t3, a1, 16
    beq t3, t1, compara_y_dir3FASE2
    j fim_checa3FASE2
compara_y_dir3FASE2:
    beq a2, t2, mata_jogo3FASE2

fim_checa3FASE2:
    ret

mata_jogo3FASE2:
    mv t1, s5
    mv t2, s6
    la a0, fundo_mapa2
    mv a1, s5
    mv a2, s6
    li a3, 0
    call PRINT
    la t0, inimigo3_morte    # carrega o endereço da variável
    li t1, 1                 # carrega o valor 1
    sw t1, 0(t0)             # armazena o 1 na memória
    la t0, pontuacao
    li t1, 10
    sw t1, 0(t0)
    
    j loop
volta3FASE2:
    j loop
# fun??o que remove obst?culos destrut?veis (valor 255) da mem?ria de colis?o
# n?o modifica obst?culos fixos (valor 50)
# entradas:
# a1 = x (pos_x da explos?o)
# a2 = y (pos_y da explos?o)
destruir_obstaculoFASE2:
    la t0, mapa_colisao_mem     # base da mem?ria de colis?o

    srli t1, a1, 4              # t1 = coluna (x / 16)
    srli t2, a2, 4              # t2 = linha (y / 16)

    li t3, 20                   # largura do mapa em c?lulas
    mul t2, t2, t3              # t2 = linha * largura
    add t1, t1, t2              # offset = linha * largura + coluna

    add t1, t0, t1              # endere?o = base + offset
    lbu t4, 0(t1)               # l? valor atual

    li t5, 50
    beq t4, t5, fim_destruirFASE2    # s? modifica se for exatamente 255

    li t6, 0
    sb t6, 0(t1)                # zera a posi??o (remove obst?culo)
    li t5, 50
    beq t4, t5, printar_fixo    # se for 50 (fixo), apenas printa e sai

    # Caso não seja fixo, destrói:
    li t6, 0
    sb t6, 0(t1)                # zera a célula (remove obstáculo)
    j fim_destruirFASE2

# Se a célula era 50, printa ela novamente no mapa
printar_fixoFASE2:
    
    li t5, 32
    li t4, 64
    la a0, bloco_inquebravel                 # caractere a desenhar
    mv a1, t5                   # x
    mv a2, t4                   # y
    li a3, 0                    # camada ou plano
    call PRINT

fim_destruirFASE2:
    ret

##******** DIREITA
rightFASE2:
	li t0, 304           # limite do mapa na horizontal
	addi t1, s1, 16
	bgt t1, t0, loop2     # se passar do limite, n?o anda
	
	mv a1, t1
    	mv a2, s3
    	jal verifica_colisao
    	beqz t6, loop2       # impede andar se colidiu
    
	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_dFASE2:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_dFASE2
	bne t4, s3, proxima_bomba_dFASE2
	la a0, bomba_vermelha
	j printa_saida_dFASE2

proxima_bomba_dFASE2:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_dFASE2

	la a0, fundo_mapa2

printa_saida_dFASE2:
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
leftFASE2:
	ble s1, zero, loop
	
	addi t1, s1, -16   # destino: 16 px ? esquerda
    	mv a1, t1          # novo X
    	mv a2, s3          # Y atual
    	jal verifica_colisaoFASE2
    	beqz t6, loop2      # colidiu? volta ao loop
    	
	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_eFASE2:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_eFASE2
	bne t4, s3, proxima_bomba_eFASE2
	la a0, bomba_vermelha
	j printa_saida_eFASE2

proxima_bomba_eFASE2:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_eFASE2

	la a0, fundo_mapa2

printa_saida_eFASE2:
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
	j loop2

##******** CIMA
upFASE2:
	ble s3, zero, loop2
	
	addi t1, s3, -16   # destino: 16 px acima
    	mv a1, s1          # x atual
    	mv a2, t1          # novo y
    	jal verifica_colisao
    	beqz t6, loop2
    	
	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_cFASE2:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_cFASE2
	bne t4, s3, proxima_bomba_cFASE2
	la a0, bomba_vermelha
	j printa_saida_cFASE2

proxima_bomba_cFASE2:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_cFASE2

	la a0, fundo_mapa2

printa_saida_cFASE2:
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
downFASE2:
	li t0, 224
	bge s3, t0, loop2
	
	addi t1, s3, 16    # destino: 16 px abaixo
    	mv a1, s1          # x atual
    	mv a2, t1          # novo y
    	jal verifica_colisao
    	beqz t6, loop2

	li t0, 0
	la t1, bomba_x
	la t2, bomba_y

loop_bombas_bFASE2:
	lw t3, 0(t1)
	lw t4, 0(t2)
	bne t3, s1, proxima_bomba_bFASE2
	bne t4, s3, proxima_bomba_bFASE2
	la a0, bomba_vermelha
	j printa_saida_bFASE2

proxima_bomba_bFASE2:
	addi t1, t1, 4
	addi t2, t2, 4
	addi t0, t0, 1
	li t5, 5
	blt t0, t5, loop_bombas_bFASE2

	la a0, fundo_mapa2

printa_saida_bFASE2:
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
	j loop2