## Práctica 5: Traducción Dirigida por la Sintaxis (SDD)

Esta es la práctica 5 de la asignatura Procesadores del Lenguaje de la Universidad de La Laguna. 

El objetivo es implementar una calculadora con traducción dirigida por la sintaxis (SDD) utilizando Jison. Para ello se ha modificado la gramática para incluir acciones semánticas que permitan evaluar expresiones aritméticas apllicando las reglas de precedencia y asociatividad correctas. 

## Índice

1. Introducción
2. Objetivo
3. Contexto
4. Desarrollo
5. Conclusión

## Desarrollo
### 1. Análisis de Frases y Acciones Semánticas (Gramática Inicial)
Dada la siguiente gramática:

| Regla |
|-------|
| `L → E eof` |
| `E → E op T` |
| `E → T` |
| `T → number` |

### 1.1. Frase: `4.0 - 2.0 * 3.0`

#### **Derivación sintáctica:**

```
L → E eof → E op T eof → E op T op T eof → T op T op T eof → number op number op number eof → 4.0 - 2.0 * 3.0
```

#### **Árbol de análisis sintáctico:**

```text
          L
          |
        __E__
       /  |  \
      E  op   T
     /|\  (*) |
    E op T    3.0
    | (-) |
    T    2.0
    |
   4.0
```

#### **¿En qué orden se evalúan las acciones semánticas?**

| Paso | Acción |
|------|--------|
| **1** | Se identifica el terminal **4.0** y se ejecuta `convert(4.0)` para obtener **T.value** |
| **2** | El valor asciende de **T** a **E** |
| **3** | Se identifica el terminal **2.0** y se ejecuta `convert(2.0)` para obtener el valor de **T** |
| **4** | Se ejecuta la acción semántica `operate("-", 4.0, 2.0)` resultando en **E.value = 2.0** |
| **5** | Se identifica el terminal **3.0** y se ejecuta `convert(3.0)` para obtener el valor de **T** |
| **6** | Se ejecuta la acción semántica final `operate("*", 2.0, 3.0)` resultando en **E.value = 6.0** |

### 1.2. Frase: `2 ** 3 ** 2`

#### **Derivación sintáctica:**

```
L → E eof → E op T eof → E op T op T eof → T op T op T eof → 2 ** 3 ** 2
```

#### **Árbol de análisis sintáctico:**

```text
          L
          |
        __E__
       /  |  \
      E  op   T
     /|\  (**) |
    E op T      2
    | (**) |
    T      3
    |
    2
```

### **¿En qué orden se evalúan las acciones semánticas?**

| Paso | Acción |
|------|--------|
| **1** | Se identifica `number(2)`, se ejecuta `convert` y se asigna a **T.value** |
| **2** |  El valor de **T (2)** sube al primer nodo **E** |
| **3** |  Se identifica `number(3)`, se ejecuta `convert` y se asigna a **T.value** |
| **4** |  Se ejecuta la primera potencia `2 ** 3` resultando en **E.value = 8** |
| **5** |  Se identifica el último `number(2)`, se convierte y se asigna a **T.value** |
| **6** |  Se ejecuta `8 ** 2` resultando en **E.value = 64** |

### 1.3. Frase: `7 - 4 / 2`

#### **Derivación sintáctica:**

```
L → E eof → E op T eof → E op T op T eof → T op T op T eof → 7 - 4 / 2
```

#### **Árbol de análisis sintáctico:**

```text
          L
          |
        __E__
       /  |  \
      E  op   T
     /|\  (/) |
    E op T    2
    | (-) |
    T     4
    |
    7
```

### **¿En qué orden se evalúan las acciones semánticas?**

| Paso | Acción |
|------|--------|
| **1** |  Se identifica `number(7)`, se ejecuta `convert` y se asigna a **T.value** |
| **2** |  El valor de **T (7)** sube al primer nodo **E** |
| **3** |  Se identifica `number(4)`, se ejecuta `convert` y se asigna a **T.value** |
| **4** |  Se ejecuta la resta `7 - 4` resultando en **E.value = 3** |
| **5** |  Se identifica el último `number(2)`, se convierte y se asigna a **T.value** |
| **6** |  Se ejecuta la división `3 / 2` resultando en **E.value = 1.5** |

### 2. Modificación de la Gramática y Precedencia

Posteriormente, se ha modificado la gramática para resolver la ambigüedad y establecer la precedencia correcta de los operadores. La nueva gramática es la siguiente:

| Producción | 
| :--- |
| `L → E eof` | 
| `E → E1 opad T` |
| `E → T` |
| `T → T1 opmu R` | 
| `T → R` |
| `R → F opow R` | 
| `R → F` | 
| `F → number` |

Con esta nueva estructura, se han definido claramente los niveles de jerarquía entre los operadores:
* **E** para suma y resta (opad)
* **T** para multiplicación y división (opmu)
* **R** para potencia (opow)
* **F** para números (number)

A continuacion se comprobaron que los test que antes fallaban ahora pasan correctamente, confirmando que la nueva gramática maneja la precedencia y asociatividad de los operadores de forma adecuada.

### 3. Pruebas para Puntos Flotantes

Se realizaron pruebas adicionales para verificar que la calculadora maneja correctamente los números en punto flotante. Estas pruebas incluyen casos como:
* `"4.5 / 1.5 + 1` devuelve `4.0`
* `2e3 + 500` devuelve `2500.0`

### 4. Implementación de Paréntesis y Estructura Final

Finalmente, se completó la gramática para permitir el agrupamiento de expresiones mediante paréntesis, lo que permite controlar explícitamente el orden de las operaciones. La producción añadida es:

| Producción |
| :--- |
| F → `(` E `)` |

Por último, se realizaron pruebas finales para asegurar que la calculadora funciona correctamente con esta nueva capacidad, confirmando que las expresiones con paréntesis se evalúan correctamente.