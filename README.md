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