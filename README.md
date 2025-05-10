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
- GCC 9.4.0
- Python 3.12.1
- Sistemas Unix/Linux (Linux, macOS) o WSL para Windows

## Ejecución del programa
Primero, asegúrate de compilar el código. Puedes usar el `Makefile` proporcionado para compilar tanto la versión en C como la de Go.

```bash
make c_implementation
```
Luego ejectuta el programa de la siguiente manera:

```bash
./bin/matrix_mul data/input/A_small.txt data/input/B_small.txt 4 data/output/C_small.txt
```
- `A_small.txt`: Archivo de entrada con la primera matriz.
- `B_small.txt`: Archivo de entrada con la segunda matriz.
- `4`: Número de procesos a utilizar.
- `C_small.txt`: Archivo de salida donde se guardará el resultado de la multiplicación.