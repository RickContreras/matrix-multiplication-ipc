# Multiplicación de Matrices Paralela usando Procesos

Este proyecto implementa multiplicación de matrices utilizando procesos para paralelizar el cálculo, comparando el rendimiento entre implementaciones secuenciales y paralelas usando mecanismos de comunicación entre procesos (IPC).

## Descripción

La multiplicación de matrices es una operación computacionalmente intensiva que puede beneficiarse significativamente de la paralelización. Este proyecto divide la operación entre múltiples procesos usando `fork()` en C y técnicas de paralelismo en Go, permitiendo una comparación directa de rendimiento.

## Características Principales

## Estructura del Repositorio

```
matrix-multiplication-ipc/
├── src/             # Código fuente principal
│   ├── c/           # Implementación en C
│   └── go/          # Implementación en Go
├── utils/           # Utilidades y scripts
├── docs/            # Documentación y reporte
├── data/            # Matrices de entrada/salida
│   ├── input/
│   └── output/
├── tests/           # Casos de prueba
├── Makefile
└── README.md
```

## Requisitos

## Ejecución del programa
```bash
./matrix_mul A.txt B.txt 4 C.txt
```
- `A.txt`: Archivo de entrada con la primera matriz.
- `B.txt`: Archivo de entrada con la segunda matriz.
- `4`: Número de procesos a utilizar.
- `C.txt`: Archivo de salida donde se guardará el resultado de la multiplicación.