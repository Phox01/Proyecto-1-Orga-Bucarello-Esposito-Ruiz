# Proyecto N°1: Representación en Coma Flotante

## Introducción
La representación de coma flotante es una forma compacta y eficiente de expresar números reales extremadamente grandes o pequeños en computadoras. El estándar IEEE 754 es el modelo más utilizado para representar números en coma flotante. Este proyecto tiene como objetivo desarrollar un programa en lenguaje ensamblador para la arquitectura MIPS 2000 que convierta un número decimal o hexadecimal ingresado por el usuario a su representación en coma flotante bajo este estándar.

---

## Objetivos
1. Diseñar y desarrollar un programa en MIPS que acepte un número decimal o hexadecimal ingresado por el usuario.
2. Convertir el número ingresado a su forma normalizada en base 2.
3. Mostrar la representación en coma flotante de 32 bits según el estándar IEEE 754.

---

## Requerimientos

### Entrada del Usuario
1. **Formato de entrada:**
   - Decimal: El número puede tener hasta 6 dígitos a la izquierda y 2 dígitos después del punto decimal.
     - Rango permitido: de **-999999,99** a **+999999,99**.
   - Hexadecimal: El número puede tener hasta 5 dígitos a la izquierda y 2 dígitos después del punto hexadecimal.
     - Rango permitido: de **-FFFFF,FF** a **+FFFFF,FF**.
2. El número se ingresa utilizando **syscall 8**.
3. El signo del número debe estar incluido: “+” o “-”.

### Proceso
1. Identificar el formato del número ingresado (decimal o hexadecimal).
2. Convertir el número a su forma normalizada en base 2. Ejemplo:
   - Entrada: **+10,75**
   - Normalizado: **+1,1101 * 2^3**
3. Representar el número en el formato IEEE 754 de 32 bits:
   - Signo (1 bit): 0 para positivo, 1 para negativo.
   - Exponente (8 bits): Representado en exceso 127.
   - Mantisa (23 bits): Parte fraccionaria normalizada.

### Salida
1. Mostrar el número normalizado en formato base 2 utilizando **syscall 4**. Ejemplo:
   - **+1,1101 * 2^3**
2. Mostrar el resultado final en formato IEEE 754 utilizando **syscall 4**. Ejemplo:
   - **0 10000011 11010000000000000000000**

---

## Tecnologías y Herramientas
- **Lenguaje:** Ensamblador MIPS 2000.
- **Simulador:** [MARS (MIPS Assembler and Runtime Simulator)](http://courses.missouristate.edu/KenVollmar/MARS/).
- **Syscalls utilizadas:**
  - **Syscall 8:** Entrada de cadena.
  - **Syscall 4:** Salida de cadena.

---

## Estructura del Programa
1. **Sección de Entrada:**
   - Leer el número decimal o hexadecimal ingresado por el usuario.
   - Validar el formato y el rango del número.
2. **Conversión:**
   - Determinar si el número es decimal o hexadecimal.
   - Convertir el número al formato de punto flotante normalizado (base 2).
   - Calcular los campos del formato IEEE 754 (signo, exponente y mantisa).
3. **Sección de Salida:**
   - Mostrar el número en formato normalizado.
   - Mostrar la representación en coma flotante de 32 bits.
