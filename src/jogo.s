.include "char.s"

#CONSEGUI PRINTAR ALGUM EXEMPLO!!
.text
SETUP: la a0, char
	li a1, 0 #caso você queira printar em 0x0 você coloca 4, se quiser ir pra frente coloca 16, dps 32 e assim por diante = posição X
	li a2, 0 #caso você queira printar em 0x0 você coloca 4, se quiser ir pra frente coloca 16, dps 32 e assim por diante = posição Y
	li s3, 0 
	
	call PRINT

PRINT: li t0,0xFF0
	add t0, t0, a3
	slli t0, t0, 20
	
	add t0,t0, a1
	
	li t1,320
	mul t1,t1,a2
	add t0, t0, t1
	
	addi t1,a0,8
	
	mv t2,zero
	mv t3,zero
	
	lw t4,0(a0)
	lw t5,4(a0)
PRINT_LINHA: lw t6,0(t1)
	sw t6,0(t0)
	
	addi t0,t0,4
	addi t1,t1,4
	
	addi t3,t3,4
	blt t3,t4,PRINT_LINHA
	
	addi t0,t0,320
	sub t0,t0,t4
	
	mv t3,zero
	addi t2,t2,1
	ble t2,t5,PRINT_LINHA
	
	ret