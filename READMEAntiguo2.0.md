## Práctica 4: Calculadora con SDD y Análisis Léxico

Esta es la práctica 4 de la asignatura Procesadores del Lenguaje de la Universidad de La Laguna. 

El objetivo es extender las capacidades de una calculadora basada en Jison. Para ello se configuro el analizador léxico para reconocer nuevos tipos de números y gestionar comentarios.

## Índice

1. Introducción
2. Objetivo
3. Contexto
4. Desarrollo
5. Conclusión

## Desarrollo
### 1. Configuración del entorno de desarrollo
Para esta práctica, se ha utilizado __Jison__, una herramienta de generación de analizadores sintácticos y léxicos. En primer lugar, se ha configurado el entorno de desarrollo para trabajar con Jison, instalando las dependencias necesarias `(npm i)`.
### 2. Preguntas Teoricas
#### 2.1. Describa la diferencia entre /* skip whitespace */ y devolver un token.
- __Saltar espacios (/* skip whitespace */)__: El Lexer ve el espacio, lo "borra" y sigue buscando algo importante. De forma que el Parser ni siquiera se entera de que había espacios. 

- __Devolver un token (return 'TOKEN')__: Aquí el Lexer encuentra algo valioso. Se detiene e informa al Parser. Esto ocurre con el fin  de que el Parser pueda trabajar y saber qué operación realizar.
#### 2.2. Escriba la secuencia exacta de tokens producidos para la entrada 123**45+@.
El lexer analiza la entrada de izquierda a derecha. La secuencia producida es la siguiente:
* **123** $\rightarrow$ `NUMBER`
* **\*\*** $\rightarrow$ `OP`
* **45** $\rightarrow$ `NUMBER`
* **+** $\rightarrow$ `OP`
* **@** $\rightarrow$ `INVALID` (Coincide con la regla `.` porque ninguna otra regla lo reconoce)
* **(Final de cadena)** $\rightarrow$ `EOF`
#### 2.3. Indique por qué ** debe aparecer antes que [-+*/].
**Jison** aplica la regla de **prioridad por orden**. Si el lexer encuentra un `*`, ambas reglas podrían coincidir (la de `**` y la de `*` dentro de los corchetes).

* **Si `**` está primero:** Al leer el primer `*`, el lexer mira el siguiente carácter. Si es otro `*`, devuelve un único token **OP** (potencia).
* **Si `[-+*/]` estuviera primero:** Al leer `**`, el lexer identificaría el primer `*` como un operador de multiplicación y luego el segundo `*` como otro operador de multiplicación por separado, lo cual **rompería la lógica de la potencia**.
#### 2.4. Explique cuándo se devuelve EOF.
El token **EOF** (End Of File) se devuelve cuando el analizador léxico llega al **final de la entrada**. Es una señal es importante para el Parser para saber que la expresión ha terminado y puede devolver el resultado final.
#### 2.5. Explique por qué existe la regla . que devuelve INVALID.
La regla `.` actúa como un **comodín**. Su función, en el analizador, es la **gestión de errores**:
* Si el usuario introduce un símbolo que no es ni número ni operador (como `&`, `@` o `!`), el lexer no se cuelga. 
* En su lugar, captura ese carácter extraño y avisa al Parser. Así el programa puede informar del error de forma controlada.
### 3 y 4 Modificaciones sobre la calculadora.
Posteriormente, se ha añadido nuevas capacidades al lexer modificando el archivo `grammar.jison`. Los cambios principales han sido:

#### 3. Reconocimiento para Comentarios
Se ha añadido una regla para que la calculadora ignore los comentarios de una sola línea. Esto permite que el usuario escriban notas sin que el programa falle.
* **Regla añadida:** `"//".* { /* skip comments */ }`
* **Funcionamiento:** Cuando el lexer detecta `//`, usa todo lo que haya después hasta el final de la línea y **no devuelve ningún token**, por lo que el parser no se entera de su existencia.

#### 4. Números en Punto Flotante y Notación Científica
Se ha mejorado la detección de números para que la calculadora no solo funcione con enteros. Ahora puede leer decimales y números en notación científica.
* **Regla actualizada:** `[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)? { return 'NUMBER'; }`
* **Partes de la expresión:**
    * `[0-9]+`: Parte entera.
    * `(\.[0-9]+)?`: Parte decimal (opcional) (ej. `.35`).
    * `([eE][-+]?[0-9]+)?`: Exponente (opcional) (ej. `e-3` o `E+2`).
### 5. Pruebas
Para asegurar que todo funciona, se ha añadido algunas de pruebas con **Jest**. Estas pruebas verifican:
1. Que los **comentarios** no afecten al cálculo: `10 + 20 // suma` devuelve `30`.
2. Que los **decimales** se calculen bien: `10.5 / 2` devuelve `5.25`.
3. Que la **notación científica** se reconozca correctamente: `2.35e+3` devuelve `2350`.
## 5. Conclusión
En esta práctica, he tenido la oportunidad de extender las capacidades de una calculadora basada en __Jison__ para manejar comentarios y nuevos formatos de números. Con ello he aprendido a modificar el comportamiento del analizador léxico para reconocer nuevos tipos de tokens y he podido comprender parte de la sintaxis de __Jison__. Además, he podido apreciar la importancia de gestionar errores de forma controlada y cómo las __reglas de prioridad__ afectan al análisis. Finalmente, las pruebas con __Jest__ me han permitido validar que las nuevas funcionalidades funcionan correctamente.