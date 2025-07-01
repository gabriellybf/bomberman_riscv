.data
#se for parede fixa (4)
#se for destrut�vel (5)
#se for vazio (0)

pontuacao: .word 0
vidas: .word 3 
tempo: .word 200 #o tempo limite eh 200 segundos
jogador_x: .word 1 #ele come�a na linha 1
jogador_y: .word 1 #ele come�a na coluna 1

# dados principais

.text

.global main

main:
    call TELA_INICIO
    call LER_TECLA #chama a fun��o de ler uma tecla (tem que ser ENTER para iniciar o jogo)
    li t3, 13 #ENTER NO ASCII = 13
    
    beq a0, t3, FASE1 #caso a tecla seja ENTER, v� para a FASE1
    
    #caso N�O SEJA
    j main #volta at� ler a tecla v�lida
    

LER_TECLA:
	li t1, 0xFF00
ESPERA_TECLA:
	lb t2, 0(t1) #l� a tecla
	beq t2, zero, ESPERA_TECLA #caso nenhuma tecla tenha sido pressionada
	sb, zero, 0(t1) #limpa o valor da tecla lida
	mv a0, t2 #move o conte�do da tecla aplicada do registrador t2 para a0
	ret

FASE1:
	#carregar o mapa com uma fun��o quando ele existir
	#colocar o jogador na posi��o inicial 1x1, para sempre que reiniciar a fase 1 ele aparecer no 1x1
	la, t0, jogador_x
	li t1, 1
	sw t1, 0(t0)
	
	la t0, jogador_y
	li t1, 1
	sw t1, 0(t0)
	
	call DESENHAR_JOGADOR #criar essa fun��o de desenhar o jogador na tela
	
	##ler a tecla
	call LER_TECLA