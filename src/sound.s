.data

# Música do mapa 1
num1: .word 103
NOTAS1: 
    .word 67,280,64,280,67,280,72,280,69,1200,65,280,62,280,65,280,71,280,67,600,65,280,64,600,60,280,64,280,60,280,65,600,60,600,60,600,65,280,64,280,67,600,65,600,67,280,64,280,67,280,72,280,69,900,67,280,65,280,62,280,65,280,71,280,67,600,65,280,64,600,60,280,64,280,60,280,65,600,60,600,65,280,65,280,65,280,64,280,67,600,65,280,64,280,64,280,64,280,60,280,59,280,64,280,64,280,60,280,59,280,71,600,67,600,64,600,60,280,59,280,64,280,64,280,60,280,59,280,64,280,64,280,60,280,59,280,60,280,72,280,71,280,72,600,72,280,71,280,72,280,64,280,64,280,60,280,59,280,64,280,64,280,60,280,59,280,71,600,67,600,64,600,60,280,59,280,64,280,64,280,60,280,59,280,64,280,64,280,60,280,59,280,60,280,72,280,71,280,72,600,72,280,71,280,72,280

# Música do mapa 2
num2: .word 96
NOTAS2:
    .word 55,198,57,203,59,198,62,198,64,204,60,198,57,198,59,204,60,198,64,198,67,204,62,198,59,198,60,204,62,198,67,198,69,204,64,198,60,198,62,204,64,198,69,198,71,204,67,198,62,198,64,204,67,198,71,198,72,204,69,198,67,198,69,204,71,198,74,198,76,204,72,198,69,198,71,204,72,198,76,198,79,204,74,198,71,198,72,204,74,198,79,198,81,204,76,198,83,150,81,150,79,150,74,150,72,150,76,150,81,150,79,150,76,150,72,150,71,150,74,150,79,150,76,150,74,150,71,150,69,150,72,150,76,150,74,150,72,150,69,150,67,150,71,150,74,150,72,150,71,150,67,150,64,150,69,150,72,150,71,150,69,150,64,150,62,150,67,150,71,150,69,150,67,150,62,150,60,150,64,150,69,150,67,150,64,150,60,150,59,150,62,150

.text
.globl main

main:
    jal tocarMusica2 # Chama a função para tocar a música 1
    li a7, 10        # Carrega o código da syscall
    ecall            # Executa a syscall

# Função tocarMusica1

tocarMusica1:
    la s0, num1  # Carrega o endereço do número de notas em s0
    lw s1, 0(s0) # Lê o número de notas
    la s0, NOTAS1 # Define o endereço das notas
    li t0, 0     # Zera o contador de notas
    li a2, 28    # Instrumento
    li a3, 120   # Volume

.loop1:
    beq t0, s1, .fim1 # Verifica se contador chegou ao final
    lw a0, 0(s0) # Carrega a nota
    lw a1, 4(s0) # Carrega a duração da nota
    li a7, 31    # Syscall para tocar a nota
    ecall        # Faz uma pausa
    mv a0, a1    # Passa a duração da nota para a pausa
    li a7, 32    # Define a chamada se syscal
    ecall        # Faz uma pausa  
    addi s0, s0, 8 # Avança para as próximas notas
    addi t0, t0, 1 # Adiciona o contador
    j .loop1  # Repete o loop

.fim1:
    ret # Retorna a função

# Função tocarMusica2

tocarMusica2:
    la s0, num2   # Carrega o endereço do número de notas em s0
    lw s1, 0(s0) # Lê o número de notas
    la s0, NOTAS2 # Define o endereço das notas
    li t0, 0      # Zera o contador de notas
    li a2, 99    # Instrumento
    li a3, 120   # Volume

.loop2:
    beq t0, s1, .fim2 # Verifica se contador chegou ao final
    lw a0, 0(s0) # Carrega a nota
    lw a1, 4(s0) # Carrega a duração da nota
    li a7, 31    # Syscall para tocar a nota
    ecall       # Toca a nota
    mv a0, a1   # Passa a duração da nota para a pausa
    li a7, 32   # Define a chamada se syscal
    ecall       # Faz uma pausa
    addi s0, s0, 8 # Avança para as próximas notas
    addi t0, t0, 1 # Adiciona o contador
    j .loop2  # Repete o loop

.fim2:
    ret # Retorna a função
