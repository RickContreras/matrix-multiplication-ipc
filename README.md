# 🚀 Multiplicación de Matrices Paralela usando Procesos

[![Licencia: MIT](https://img.shields.io/badge/Licencia-MIT-blue.svg)](https://opensource.org/licenses/MIT)
![C](https://img.shields.io/badge/C-11-00599C?logo=c&logoColor=white)
![Go](https://img.shields.io/badge/Go-1.18-00ADD8?logo=go&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10-3776AB?logo=python&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Compatible-FCC624?logo=linux&logoColor=black)
![GCC](https://img.shields.io/badge/GCC-9.4.0-4EAA25?logo=gnu&logoColor=white)
![Makefile](https://img.shields.io/badge/Makefile-Automation-064F8C?logo=gnu&logoColor=white)
![Codespaces](https://img.shields.io/badge/Codespaces-Enabled-blue?logo=github)
![DevContainer](https://img.shields.io/badge/DevContainer-Enabled-blue?logo=visualstudiocode)

Este proyecto implementa la **multiplicación de matrices** utilizando procesos para paralelizar el cálculo, comparando el rendimiento entre implementaciones secuenciales y paralelas mediante mecanismos de comunicación entre procesos (IPC).

---

## ⚡ Abrir en Codespaces

Si deseas trabajar en este proyecto directamente en un entorno preconfigurado, haz clic en el siguiente botón para abrirlo en **GitHub Codespaces**:

<div align="center">

[![Abrir en Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?template_repository=RickContreras/matrix-multiplication-ipc)

</div>

---

## 📖 Descripción

La multiplicación de matrices es una operación computacionalmente intensiva que puede beneficiarse significativamente de la paralelización. Este proyecto divide la operación entre múltiples procesos usando:
- **`fork()` en C** para paralelismo a nivel de procesos.
- **Técnicas de paralelismo en Go** para una comparación directa de rendimiento.

---

## 📂 Estructura del Repositorio

```plaintext
matrix-multiplication-ipc/
├── src/             # Código fuente principal
│   ├── c/           # Implementación en C
│   └── go/          # Implementación en Go
├── utils/           # Utilidades y scripts
├── docs/            # Documentación y reporte
│   └── imgs/        # Gráficos generados
├── data/            # Matrices de entrada/salida
│   ├── input/
│   └── output/
├── tests/           # Casos de prueba
│   └── test_matrices/
├── .devcontainer/   # Configuración para Codespaces y devcontainer
├── Makefile         # Archivo para automatización de tareas
└── README.md        # Este archivo
```

---

## 🛠️ Requisitos

- **GCC** 9.4.0
- **Python** 3.10.12
- **Go** 1.18.1
- Sistemas **Unix/Linux** o **WSL** para Windows

---

## ⚙️ Configuración Inicial

### 🔹 Crear y Configurar el Entorno de trabajo

1. **Crear y activar el entorno virtual**:
   ```bash
   make venv
   source venv/bin/activate
   ```

2. **Instalar las dependencias necesarias**:
   ```bash
   make install_deps
   ```

3. **Compila todos los archivos importantes**:
   ```bash
   make
   ```

---

## 🚀 Ejecución del Programa

### 🔹 Para la Implementación en C

1. **Compila el código**:
   ```bash
   make c_implementation
   ```

2. **Ejecuta el programa**:
   ```bash
   make run_c
   ```

> **🔔 Alternativa**:
> ```bash  
> ./bin/matrix_mul data/input/A.txt data/input/B.txt 4 data/output/C.txt
> ```

---

### 🔹 Para la Implementación en Go

#### Opción 1: Ejecutar directamente

   ```bash
   go run src/go/matrix_mul.go data/input/A.txt data/input/B.txt 4 data/output/C.txt
   ```

#### Opción 2: Compilar y ejecutar

1. **Compila el código**:
   ```bash
   make go_implementation
   ```

2. **Ejecuta el programa**:
   ```bash
   make run_go 
   ```


> **🔔 Alternativa**:
> ```bash  
> ./bin/matrix_mul_go data/input/A.txt data/input/B.txt 4 data/output/C.txt 
> ```

---

## 🧪 Generación de Matrices de Prueba

1. **Compila el script de generación de matrices**:
   ```bash
   gcc -o bin/gen_matrix utils/gen_matrix.c
   ```

2. **Genera una matriz de prueba**:
   ```bash
   ./bin/gen_matrix matrix.txt 10 8 100
   ```
   - `matrix.txt`: Archivo de salida que se guardará en `data/generated`.
   - `10`: Número de filas de la matriz.
   - `8`: Número de columnas de la matriz.
   - `100`: Valor máximo para los elementos de la matriz.

---

## 📊 Pruebas de Rendimiento

1. **Ejecuta las pruebas de rendimiento**:
   ```bash
   make performance
   ```

#### Alternativa

```bash
./utils/performance_test.sh
```

2. **Genera gráficos a partir de los resultados**:
   ```bash
   make graphs
   ```

> **⚠️ Importante**:
> * Debes tener instalado los requirements.txt en local o en tu venv.

---

## 🧹 Limpieza

- **Eliminar archivos binarios**:
  ```bash
  make clean
  ```

- **Eliminar todos los datos generados**:
  ```bash
  make clean_all
  ```

---

## 📋 Casos de Prueba

Los casos de prueba se encuentran en la carpeta `tests/test_matrices`. Puedes validar los resultados generados comparándolos con los resultados esperados:

```bash
make validate_results
```

---

## 📜 Licencia

Este proyecto está bajo la licencia **MIT**. Consulta el archivo `LICENSE` para más detalles.

---

## 👨‍💻 Autor

Desarrollado por RickContreras. Si tienes preguntas o sugerencias, no dudes en contactarme.

---

## 🌟 ¡Contribuye!

¿Tienes ideas para mejorar este proyecto? ¡Las contribuciones son bienvenidas! Por favor, abre un **issue** o envía un **pull request**.