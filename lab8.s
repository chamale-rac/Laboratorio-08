/*************************************************************************** 
* @file lab8.s 
* @brief simple program that turs off and on a led. 
* 
* In this promam, one button turns off and the other turn on the led
* 
* @author Samuel A. Chamalé
* @team Daniel Valder, Emilio Solano
* @date 17/05/2022 
* 
* @course Organización de Computadoras y Assembler 
* @teacher Erick Pineda 
* @section 10 
***************************************************************************/ 

@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	 .data
	 .balign 4	
	 
Intro: 	 .asciz "Raspberry Pi wiringPi blink test\n"
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
pin1:	 .int	2					@ pin in pin16 en placa
pin2:	 .int   3					@ pin out pin18 en placa
pin0:    .int 	0
i:	 	 .int	0
delayMs: .int	250
INPUT	 =	0
OUTPUT	 =	1
	
@ ---------------------------------------
@	Code Section
@ ---------------------------------------
	
	.text
	.global main
	.extern printf
	.extern wiringPiSetup
	.extern delay
	.extern digitalWrite
	.extern pinMode
	
main:   push 	{ip, lr}	@ push return address + dummy register
				@ for alignment
	ldr r0,=Intro
	bl puts
	bl	wiringPiSetup			@ Inicializar librería wiringpi
	mov	r1,#-1					@ -1 representa un código de error
	cmp	r0, r1					@ verifica si se retornó cod error en r0
	bne	init					@ NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				@ SI error, 
	bl	printf					@ imprimir mensaje y
	b	done					@ salir del programa

@------- set pinMode
init:

    ldr	r0, =pin0				@ coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				@ lo configura como salida, r1 = 1
	bl	pinMode					@ llama funcion wiringpi para configurar

	ldr	r0, =pin1				@ coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				@ lo configura como salida, r1 = 1
	bl	pinMode					@ llama funcion wiringpi para configurar
	
	
	ldr	r0, =pin2				@ coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				@ lo configura como salida, r1 = 1
	bl	pinMode					@ llama funcion wiringpi para configurar
	
@------- if gpio in == 1		/@ si se activa switch entrada gpio4
try:
	@------- delay(50)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pin1				@ carga dirección de pin
	ldr	r0, [r0]				@ operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				@ escribe 1 en pin para activar puerto GPIO
	cmp	r0,#1
	beq	On

    ldr	r0, =pin0				@ carga dirección de pin
	ldr	r0, [r0]				@ operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				@ escribe 1 en pin para activar puerto GPIO
	cmp	r0,#1
	beq	Off

    bl try
On:		
	ldr	r0, =pin2				@ carga dirección de pin
	ldr	r0, [r0]				@ operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			@ escribe 1 en pin para activar puerto GPIO
    bl try

Off:
    ldr	r0, =pin2				@ carga dirección de pin
	ldr	r0, [r0]				@ operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			@ escribe 0 en pin para desactivar puerto GPIO
    bl try
	
done:	
        pop 	{ip, pc}	@ pop return address into pc
