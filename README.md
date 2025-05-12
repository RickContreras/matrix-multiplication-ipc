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
- Python 3.10.12
- Sistemas Unix/Linux (Linux, macOS) o WSL para Windows
- Go 1.18.1

## Ejecución del programa para C
Primero, asegúrate de compilar el código. Puedes usar el `Makefile` proporcionado para compilar tanto la versión en C como la de Go.

```bash
make c_implementation
```
Luego ejectuta el programa de la siguiente manera:

```bash
./bin/matrix_mul data/input/A.txt data/input/B.txt 4 data/output/C.txt
```
- `A.txt`: Archivo de entrada con la primera matriz.
- `B.txt`: Archivo de entrada con la segunda matriz.
- `4`: Número de procesos a utilizar.
- `C.txt`: Archivo de salida donde se guardará el resultado de la multiplicación.

## Ejecución del programa para Go

Primera opcion:
```bash
go run src/go/matrix_mul.go data/input/A.txt data/input/B.txt 4 data/output/C.txt 
```

Segunda opcion, asegúrate de compilar el código. Puedes usar el `Makefile` proporcionado para compilar  la versión de Go.

```bash
make go_implementation
```
Luego ejectuta el programa de la siguiente manera:

```bash
./bin/matrix_mul_go data/input/A.txt data/input/B.txt 4 data/output/C.txt
```
- `A.txt`: Archivo de entrada con la primera matriz.
- `B.txt`: Archivo de entrada con la segunda matriz.
- `4`: Número de procesos a utilizar.
- `C.txt`: Archivo de salida donde se guardará el resultado de la multiplicación.

## Para la creacion de matrices de prueba
Para crear matrices de prueba, puedes usar el script `gen_matrix.c` en la carpeta `utils`. Este script genera matrices aleatorias y las guarda en archivos de texto.

### Compilación del script de generación de matrices
```bash
gcc -o bin/gen_matrix utils/gen_matrix.c
```

### Ejecución del script de generación de matrices
```bash
./bin/gen_matrix matrix.txt 10 8 100
```
- `matrix.txt`: Archivo de salida donde se guardará la matriz generada.
- `10`: Número de filas de la matriz.
- `8`: Número de columnas de la matriz.
- `100`: Valor máximo para los elementos de la matriz.

### para probar el rendimiento
Para probar el rendimiento de las implementaciones, puedes usar el script `performance_test.sh` en la carpeta `utils`. Este script ejecuta las implementaciones en C con diferente numero de procesos.

Primero, asegurate de tener instalado python3 y pip3. Luego, cree un entorno virtual y activa el entorno virtual:
```bash
python3 -m venv venv
source venv/bin/activate
```
Luego, instala las dependencias necesarias:
```bash
pip3 install -r requirements.txt
```

### Ejecución del script de prueba de rendimiento
```bash
./utils/performance_test.sh
```