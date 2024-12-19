.data
	ImprNumNorm:	.asciiz "El numero es: "
	ImprNumIE:	.asciiz "El numero en formato IEEE754 : "
	introducción: .asciiz "Bienvenido al programa para representación en coma flotante\nIngrese: \n-1 para colocar un número en hexadecimal \n-2 para colocar un número en decimal\n"
	decimal: .asciiz "\nHa seleccionado un número decimal\n\n"
	hexadecimal: .asciiz "\nHa seleccionado un número hexadecimal\n\n"
	intruccionDecimal: .asciiz "- Ingrese su número. Puede tener parte fraccionaria  (debe separala por una coma) y debe identificar su signo (+) o (-). \n- Puede tener máx. 6 dígitos antes de la coma y máximo 2 dígitos después de la coma\n-Ejemplo: +10,75 o -20 \nNumber= "
	intruccionHexadecimal: .asciiz "- Ingrese su número. Puede tener parte fraccionaria  (debe separala por una coma) y debe identificar su signo (+) o (-). \n- Puede tener máx. 5 dígitos antes de la coma y máximo 2 dígitos después de la coma\n-Ejemplo: +7EA,4 o -10 \nNumber= "
	fallo: .asciiz "No se ha ingresado un valor entre 1 y 2. Por favor, ingrese de nuevo el número\n"
	hexaconvert: .asciiz "0123456789ABCDEF"
	savednumber: .asciiz "           "
	comalessnumber: .asciiz "       "
	pasó: .asciiz "pasó\n"
	salto: .asciiz "\n"	
	binarynumber: .asciiz "                    "
	binaryfrac: .asciiz "        "
	falloHex: .asciiz "No se ha ingresado un valor en hexadecimal entre 1 a F. Por favor, ingrese de nuevo el número\n"
	signo: .asciiz "El número que ingresó no tiene signo o es distinto de (+) y de (-). Por favor, ingrese de nuevo"
	
	bynaryFinalComaDerecha:  .asciiz "                        "
	exponentemantisa: .asciiz " 2^"
	
	ShowingExponenteS: .asciiz "El exponente sesgado en binario es:"
	exponenteSesgado: .asciiz "        "
	positivo: .asciiz "+"
	negativo: .asciiz "-"
	NumNormalizado: .asciiz "El número normalizado es: "
	bynaryFinal:  .asciiz "                        "
.text	
############################################################	INICIO	##############################################################################################################

	Start:		
		la $a0, introducción
		li $v0, 4
		syscall  
		
		li $v0, 5
		syscall
		move $s2, $v0 
		
		b CheckOption
	
	CheckOption: 
		# $s2 es la opción (transformacion) tomada (1--> Hexa | 2 ---> Deci)
		beq $s2, 1, Hexadecimal
		beq $s2, 2, Decimal
		
		la $a0, fallo
		li $v0, 4
		syscall
		
		b Start
				
	Hexadecimal: # checkiado
		la $a0, hexadecimal
		li $v0, 4
		syscall 	
		
		la $a0, intruccionHexadecimal
		li $v0, 4
		syscall
		
		li $v0, 8
		la $a0, savednumber
		li $a1, 10
		syscall
		
		la $a0, salto
		li $v0, 4
		syscall
		
		b LectureSymbol
		
	
	Decimal: # checkiado
		la $a0, decimal
		li $v0, 4
		syscall
		
		la $a0, intruccionDecimal
		li $v0, 4
		syscall
		
		li $v0, 8
		la $a0, savednumber
		li $a1, 11
		syscall
		
		la $a0, salto
		li $v0, 4
		syscall
		
		b LectureSymbol

#########################################################################################################################################################

	LectureSymbol: # checkiado
		li $t0 0 # posicion donde deberia estar el signo
		
		lb $t1 savednumber($t0)
		
		beq $t1, 45, Negativo
		bne $t1, 43, SignoIncorrecto
		
		b BusquedaComa
	
	Negativo: # chekiado
		li $s1, 1
		b BusquedaComa
	
	SignoIncorrecto: # chekiado 
		la $a0, signo
		li $v0, 4
		syscall
			
		b Start
					
	BusquedaComa: # chekiado
		addi $t0 $t0 1 # $t0 es el numero de la iteracion (index)
		lb $t1 savednumber($t0)  # $t2 carga el digito de savednumber
		move $s3 $t0
		
		beq $t1 44 Decision		
		
		beq $t1 10 prueba2
		beq $t1 0 prueba2
		beq $t1 32 prueba2
		
		b BusquedaComa		
		
	prueba2:
		li $s4 1
		b Decision
			
	Decision: #checkiado
		# $s1 es el signo ( 0 si es positivo y -1 si es negtivo)
	 	# $s2 es la opción (transformacion) tomada (1--> Hexa | 2 ---> Deci)
	 	
		addi $t1 $t0 0 # $t1 es la posicion de la coma
		li $t0 1 # $t0 nummero de la iteracion
		
		beq $s2, 1, HexatoDecEntero
		beq $s2, 2, transformation

#######################################################################################################################################
			
##################################################		HEXA TO BINARY			#############################################
	
	CeroH: 
		li $s7 1
		li $t0 19
		sb $t5 binarynumber($t0)
		li $s6, 2
		b CantidadBitsDecimal
		
	HexatoDecEntero:
		# $s1 0 si es positivo y -1 si es negativo
		# $s2 1 si es hexadecimal y 2 si es decimal
		
		# $t0 tiene la iteracion
		# $t1 posicion de la coma
		
		lb $t3 savednumber($t0)
		beq $t3 48 CeroH
		
		addi $s6 $t1 0 # Para no perder la posicion de la coma (la posicion de la coma esta en $t1 y en $s6)
		li $s0, 0 # Numero que queremos tener transformado en entero
		addi $t2 $t1 -2 # cantidad de veces a multiplicar 16 (Exponente maximo)	
		li $t3, 16 # Numero a multiplicar (Base)

		CargarDigitoHexaEntero:
			li $t4 1 # Resultado de la multiplicacion		
			lb $t5 savednumber($t0) # $t5 es el valor ASCII del numero en la posicion de $t0
			
			
			li $t6 0 # Valor NUMERICO REAL que pertenece a $t5
			
			b TablaHex
	
	HexatoDecFracionaria:
	
		
		# $s6 Tengo la posicion de la coma
		addi $s5 $t5 0 # cantidad maxima de digitos para la parte fraccionaria (lo copio para que no se pierda)
		move $t9 $t5 # $t9 tengo la cantidad maxima de digitos de l numero de la parte fraccionaria
		li $s0, 0 # Numero que queremos tener transformado en enteros
		addi $s6 $s6 1
		addi $t1 $s6 2
		move $t0 $s6
		
		li $t2 1 # cantidad de veces a multiplicar 16 (Exponente maximo)	
		li $t3, 16 # Numero a multiplicar (Base)

		CargarDigitoHexaFraccionaria:
			li $t4 1 # Resultado de la multiplicacion	
				
			lb $t5 savednumber($t0) # $t5 es el valor del numero en la posicion de $t0
			
			beq $t5 10 Decision2.0
			beq $t5 32 Decision2.0
			
			li $t6 0 # Valor nuevo que será el valor  decimal
			b TablaHex
			
	TablaHex: 
		# $t2 la cantidad de veces que se debe multiplicar (el exponente)
		# $t3 esta la base (2 o 16)
		# $t4 el resultado de las multiplicaciones
		# $t5 el valor ASCII del digito
		
		lb $t7 hexaconvert($t6)
		
		beq $t5, $t7, Conseguido
		beqz $t7, Error
		addi $t6, $t6, 1
		b TablaHex 
			
		Conseguido:	
			li $t8 0 # contador de las veces que se multiplica
			
			MultiplicacionH:
				beq $t8 $t2 SumarH
				mult $t3 $t4
				mflo $t4
				addi $t8 $t8 1
				b MultiplicacionH
				
			SumarH:
				addi $t2 $t2 -1
				
				mult $t6 $t4
				mflo $t6
				
				add  $s0 $s0 $t6
				move $a0 $t0
			
			
				addi $t0 $t0 1
				
				beq $t0 $t1 Decision2.0
				b Decision3.0
	
	Error: 
		la $a0, falloHex
		li $v0, 4
		syscall
		
		b Hexadecimal	
		
	Decision2.0:
		# $s7 0 si esta operando en la parte entera y 1 si esta  operando en la parte fraccionaria
		beq $s7 0 CantidadBitsEnteros
		b Operacion
	
	Decision3.0:
		# $s7 0 si esta operando en la parte entera y 1 si esta  operando en la parte fraccionaria
			
		beq $s7 0 CargarDigitoHexaEntero
		b CargarDigitoHexaFraccionaria
	
	CantidadBitsEnteros: # Determina el numero de divisiones necesarias para contruir el numero CantidadBits
		# $s0 El numero en decimal de la parte entera
		
		# $s1 0 si es positivo y -1 si es negativo
		# $s2 1 si es hexadecimal y 2 si es decimal
		
		# $t1 posicion de la coma
		li $s7 1 # Cambia a 1 porque ya se termino la operacion en la parte entera
		
		li $t0 1 # Resultado de l a multiplicacion
		li $t1 2 # base
		li $t2 0 # Cantidad de multiplicaciones (exponente)

		blt  $s0 $t0 BinarioEntero
		
		HallarExponente:
			addi $t2 $t2 1
			mult $t1 $t0
			mflo $t0
			
			blt  $s0 $t0 BinarioEntero
			b HallarExponente
				
	BinarioEntero: # Construir el numero entero en binario
		# $s0 El numero en decimal de la parte entera
		
		addi $t4 $t2 0 # $t4 cantidad maxima de divisiones
		addi $t0 $s0 0 # Numero
		li $t1, 2 # Divisor
		li $t2, 19 #Numero para el convertidor de CantidadBits
		li $t5 0 # Cantidad de divisiones
	
		DividirE:
			div $t0, $t1
			mflo $t0
			mfhi $t3 #Residuo de la división
			addi $t5 $t5 1
			
			addi $t3, $t3, 48
						
			sb $t3, binarynumber($t2)
			
			subi $t2, $t2,1
			beq  $t5 $t4 CantidadBitsDecimal
			b DividirE
			
	CantidadBitsDecimal: # Determina el numero de bits (divisiones) maximo para contruir el numero decimal
		beq $s4 1 end
		li $t0 0 # Numero de iteracion
		li $t1 0 # Contador de bits de la parte entera
		
		For:
			lb $t2 binarynumber($t0)
			
			bne $t2 32 SumarContador
			addi $t0 $t0 1
			beq $t0 20 BinarioFraccionario #por ahora 
			b For
			
		SumarContador:
			addi $t0 $t0 1
			addi $t1 $t1 1
			beq $t0 20 BinarioFraccionario
			b For		

	BinarioFraccionario:
		# $t1 cantidad de digitos usados para construir el numero entero binario
		li $t5 23
		sub  $t5 $t5 $t1 # Cantidad de divisiones
			
		blt $t5 8 prueba
		
		
		li $t5 8

		beq $s2, 1, HexatoDecFracionaria
		beq $s2, 2, DecimalFraccionaria
		
	prueba:
		beq $s2, 1, HexatoDecFracionaria
		beq $s2, 2, DecimalFraccionaria
		
	Operacion:
		# $t9 maximo de divisiones (bits)

		li $t0 1 # Resultado de l a multiplicacion
		li $t1 2 # base
		li $t2 0 # Cantidad de multiplicaciones (exponente)

		blt  $s0 $t0 Continuar
		
		HallarExponente2.0:
			addi $t2 $t2 1
			mult $t1 $t0
			mflo $t0
			
			blt  $s0 $t0 Continuar
			b HallarExponente2.0
				
	Continuar:
		addi $t5 $t2 0 # $t5 Cantidad de bits necesarios para representar la parte decimal	
		addi $t7 $t9 0 # $t7 tiene el maximo de divisiones (bits) se pueden realizar ( 23 - OcupacionParteEntera = $t9)
		
		#sub $t9 $t5 $t9
			
		addi $t0 $s0 0 # Numero
		li $t1, 2 # Divisor
		li $t2, 7 #Numero para el convertidor de CantidadBits
		li $t3 0 # Cantidad de divisiones
		li $t6 0 # cantidad de bits agregados al str

		DividirF:
			div $t0, $t1
			mflo $t0
			mfhi $t4 #Residuo de la división
			
			addi $t4, $t4, 48
			sb $t4, binaryfrac($t2)
			subi $t2, $t2,1
			
			beq $t2 -1 end
			b DividirF
			
		AgregarBit:
			
			
			addi $t3 $t3 1
			addi $t6 $t6 1
			beq  $s5 $t6 end
			beq $t2 -1 end
			
			b DividirF
	
#######################################################################################################################################
			
##################################################		DECIMAL TO BINARY			#############################################
	# $s1 0 si es positivo y -1 si es negativo
	# $s2 1 si es hexadecimal y 2 si es decimal
		
	# $t0 tiene la iteracion
	# $t1 posicion de la coma
	CeroD: 
		li $s7 1
		li $t0 19
		sb $t5 binarynumber($t0)
		b CantidadBitsDecimal			
	
	transformation:
	
		lb $t3 savednumber($t0)
		beq $t3 48 CeroD
		li $s0, 0 # Numero que queremos tener transformado en entero
		addi $t2 $t1 -2 # cantidad de veces a multiplicar 16 (Exponente maximo)	
		li $t3, 10 # Numero a multiplicar (Base)
		
		CargarDigitoD:		
			li $t6 0 # Veces multiplicado	
			li $t4 1 # Resultado de la multiplicacion		
			lb $t5 savednumber($t0) # $t5 es el valor del numero en la posicion de $t0
			subi $t5, $t5, 48 # le resto para llegar al valor numerico
			
			MultiplicacionD:
				beq $t2 $t6 SumarD
				mult  $t3 $t4
				mflo $t4
				addi $t6, $t6, 1
					
				b MultiplicacionD
					
			SumarD:
			
				la $a0 salto
				li $v0 4
				syscall
				
				la $a0 salto
				li $v0 4
				syscall
				
				#move $a0 $t4
				#li $v0 1
				#syscall
				
				la $a0 salto
				li $v0 4
				syscall
				
				#move $a0 $t5
				#li $v0 1
				#syscall
				
				mult $t4 $t5
				mflo $t4
				add $s0, $s0, $t4
				addi $t0 $t0 1
				subi $t2 $t2 1
				
				beq $t0 $t1 CantidadBitsEnteros
				b CargarDigitoD
				
	DecimalFraccionaria:
		# $s6 Tengo la posicion de la coma
		
		li $s0 0
		addi $s6 $s3 3
		
		addi $t0 $s3 1 # Tengo la iteracion inicial (un posicion despues de la coma)
		
		li $t5 23
		sub  $t1 $t5 $t1  # cantidad maxima de multiplicaciones
		
		li $t7 10
		li $t9 0
		li $t8 0 # cantidad de multiplicaciones
		CargarDigitoDecimalFraccionaria:
			beq $t0 $s6 FracDecimalToBinary
			lb $t2 savednumber($t0) # $t2 es el valor ASCII del digito en la posicion de $t0
			
			beq $t2 32 FracDecimalToBinary
			beq $t2 10 FracDecimalToBinary
			li $t6 48
			
			sub $t2 $t2 $t6
			
			mult $t2 $t7
			mflo $t2
			
			add $s0 $t2 $s0
			li $t7 1
			
			addi $t0 $t0 1
			
			b CargarDigitoDecimalFraccionaria
			
		FracDecimalToBinary:
			li $t4 2
			
			mult $s0 $t4
			mflo $s0
			
			addi $t8 $t8 1
			
			bge $s0 100 AgregarUno
			
			li $t4 48
			 
			sb $t4 binaryfrac($t9)
			addi $t9 $t9 1
			
			beq $t8 $t1 end
			
			b FracDecimalToBinary
	
		AgregarUno:
			li $t4 49
			sb $t4 binaryfrac($t9)
			addi $t9 $t9 1
			beq $t8 $t1 end
			subi $s0 $s0 100
			b FracDecimalToBinary
			
#######################################################################################################################################
			
##################################################		FINAL			#############################################

	end:
		li $t0 20 # limite de iteracion
		
		li $t1 0 # nro de iteracion actual
		li $t9 0 # nro de iteracion en bynary final
		
		li $s0 0 # 0 si esta en la parte entera
		
		beq $s4 1 Relleno
		
		b For9.0
		
		
	Relleno:
		li $s4 0
		li $t2 48
		sb $t2 binaryfrac($t1)
		
		addi $t1 $t1 1
		beq $t1 8 end
		b Relleno
		
	For9.0: 
		lb $t2 binarynumber($t1)
		addi $t1 $t1 1
		bne $t2 32 cargarFinalE
		
		beq $t1 $t0 end3.0
		
		b For9.0
	
	end3.0:
		li $t8 44
		sb $t8 bynaryFinal($t9)
		addi $t9 $t9 1
		
		li $s5 24
		sub $t0 $s5 $t9 

		li $t1 0
		b For10.0

	cargarFinalE:
		sb $t2 bynaryFinal($t9)
		addi $t9 $t9 1
		beq $t1 $t0 end3.0
		b For9.0
		
	For10.0:
		lb $t2 binaryfrac($t1)
		addi $t1 $t1 1
		bne $t2 32 cargarFinalF
		beq $t1 $s4 end2.0 
		b For10.0
		
	cargarFinalF:
		sb $t2 bynaryFinal($t9)
		addi $t9 $t9 1

		beq $t1 $t0 end2.0
		beq $t9 24 end2.0
		b For10.0
	
	end2.0:
		
		li $t0 -1
		verificacion:
			addi $t0 $t0 1
			beq $t0 24 endd
			lb $t1 bynaryFinal($t0)
			
			beq $t1 44 verificacion
			bne $t1 48 addCero
			b verificacion
		
		addCero:
			beq $t1 49 verificacion
			li $t1 48
			sb $t1 bynaryFinal($t0)	
			b verificacion
	endd:
		la $a0, ImprNumNorm
		li $v0 4
		syscall
		
		la $a0, bynaryFinal
		li $v0 4
		syscall
		
		la $a0, salto
		li $v0, 4		
		syscall
		
#######################################################################################################################################
			
##################################################	Mantisa y Exponente	#############################################

	NormalizarMantisa:
	 	li $t0, 0
	 	li $s3, 0
	 	
	 	lb $t1 bynaryFinal($t0) ##Si la primera posición resulta 0, entonces debo rodar la coma a la derecha
		beq $t1, 48, BuscarUnoDerecha
		 
	BusquedaComa2: # chekiado
		addi $t0 $t0 1 # $t0 es contador que me dice la posicion de la coma cuando $t1 sea 44
		lb $t1 bynaryFinal($t0)  # $t2 carga el digito de savednumber
		
		beq $t1 44 MoverComa		
		
		b BusquedaComa2
	
	MoverComa:
		beq $t0, 1, ShowMantisa
		subi $t2, $t0, 1
		lb $t1, bynaryFinal($t0)
		lb $t3, bynaryFinal($t2)
		sb $t3, bynaryFinal($t0)
		sb $t1, bynaryFinal($t2)
		
		subi $t0, $t0, 1
		addi $s3, $s3, 1 #Cuantas veces movi la coma a la izquierda
		
		b MoverComa
		
	BuscarUnoDerecha:
		li $t0, 2
	Loop2.0:
		lb $t1 bynaryFinal($t0)
		subi $s3, $s3, 1 #Cuantas veces moveré la coma a la derecha
		beq $t1, 49, RehacerBynaryFinal
		addi $t0, $t0, 1
		
		b Loop2.0
		
	RehacerBynaryFinal:	
		li $t2, 0
		lb $t1, bynaryFinal($t0)
		sb $t1, bynaryFinal($t2)
		addi $t2, $t2, 2
		addi $t0, $t0, 1
	Loop3.0:
		lb $t1, bynaryFinal($t0)
		beqz $t1, Ceros
		sb $t1, bynaryFinal($t2)
		addi $t2, $t2, 1
		addi $t0, $t0, 1
		
		b Loop3.0
		
	Ceros:
		li $t1, 48
		
	RellenoDeCeros:
		sb $t1, bynaryFinal($t0)
		beq $t0, 24 ShowMantisa
		addi $t0, $t0, 1
		
		la $a0, bynaryFinal
		li $v0 4
		syscall
		
		la $a0, salto
		li $v0, 4		
		syscall
		
		b RellenoDeCeros
		
	ShowMantisa:
		li $t0, 24 #Me va indicar la posición del último número significativo de la parte fraccionaria
	For11.0:
		lb $t2, bynaryFinal($t0)
		beq $t2, 49, Imprimir
		subi $t0, $t0, 1
		b For11.0
		
	Imprimir:
	
		Imprimir2.0:
		la $a0, NumNormalizado
		li $v0, 4		
		syscall
		
		beq $s1, 0, positivoo
		negativoo:
		la $a0, negativo
		li $v0, 4		
		syscall
		
		b Continue
		
		positivoo:
		la $a0, positivo
		li $v0, 4		
		syscall		
		
		Continue:
		
		li $t3, 0
		addi $t0, $t0, 1 #Le sumo uno porque si no no da
		
		num:
		
		
	ImprimirCaracterBynaryFinal: #Imprimirá caracter por caracter hasta el último 1, denotado por $t0
		
		lb $t2, bynaryFinal($t3)
		move $a0, $t2
		li $v0, 11    # printing character
		syscall
		
		addi $t3, $t3, 1
		beq $t0, $t3, Exponente
		
		b ImprimirCaracterBynaryFinal 
	
	Exponente:
	
		la $a0, exponentemantisa
		li $v0 4
		syscall
		
		move $a0 $s3
		li $v0, 1
		syscall
		
		la $a0, salto
		li $v0, 4		
		syscall	
				
	DeleteOne:
		li $t4, 1 #Haré esta secuencia de eliminar mover todos los números 2 veces. 
		##Borraré el primer 1 y la coma 
		##li $t5, 24 #Tamaño del bynaryfinal
		#li $t0, 3 #Posición del primer número despues de coma
	Loop:
		
		addi $t0, $t4, 1
		move $t5, $t0 
		beq $t4, -1 Agregar2ceros
		lb $t1, bynaryFinal($t0)
		sb $t1, bynaryFinal($t4)
		
	DesplazarBits:
		
		addi $t6, $t5, 1
		#subi $t6, $t5, 1
		lb $t1, bynaryFinal($t6)
		sb $t1, bynaryFinal($t5)
		
		addi $t5, $t5, 1
		bne $t5, 24 DesplazarBits
				
		subi $t4, $t4, 1
		b Loop
		
	Agregar2ceros:
		li $t2, 24
		subi $t3, $t2, 1
		
		li $t6, 48
		sb $t6, bynaryFinal($t2)
		sb $t6, bynaryFinal($t3)		
		
	ExponenteABinarioExponenteSesgado:
		addi $s3, $s3, 127
		li $t1 7
		li $t2, 2 #división entre dos para convertir en binario
	For12.0:
		div $s3, $t2
		mflo $s3
		mfhi $t0 #Residuo de la división
		
		addi $t0, $t0, 48
		sb $t0, exponenteSesgado($t1)
		subi $t1, $t1,1
		
		beqz $s3, ConfirmarRelleno
		b For12.0
			
	ConfirmarRelleno:
		addi $s3, $s3, 48		
		beq $t1, -1 end4.0
			
	Rellenoo:
		sb $s3, exponenteSesgado($t1)
		beq $t1, -1 end4.0
		subi $t1, $t1,1
		b Rellenoo
			
	end4.0:

		#la $a0, exponenteSesgado
		#li $v0 4
		#syscall
		
		#la $a0, salto
		#li $v0, 4		
		#syscall
		
	Last2zeros:
		li $t1, 23
		li $s3, 32
		sb $s3, bynaryFinal($t1)
		li $t1, 24
		sb $s3, bynaryFinal($t1)
		
		
	FinalPrint:
		la $a0, ImprNumIE
		li $v0 4
		syscall
		
		move $a0 $s1
		li $v0, 1
		syscall
		

		la $a0, exponenteSesgado
		li $v0 4
		syscall
		
		
		la $a0, bynaryFinal
		li $v0 4
		syscall
		
		
		li $v0, 10
		syscall
	
