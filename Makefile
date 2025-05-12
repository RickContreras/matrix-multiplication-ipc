# Compiladores y configuraciones
CC = gcc
CFLAGS = -Wall -O2
GO = go
PYTHON = python3
PIP = pip3

# Directorios
SRC_C_DIR = src/c
SRC_GO_DIR = src/go
UTILS_DIR = utils
BIN_DIR = bin
DATA_DIR = data
DATA_INPUT_DIR = $(DATA_DIR)/input
DATA_OUTPUT_DIR = $(DATA_DIR)/output
DATA_GENERATED_DIR = $(DATA_DIR)/generated
TEMP_DIR = temp
DOCS_IMG_DIR = docs/imgs
VENV_DIR = venv

# Asegurar que los directorios necesarios existan
$(shell mkdir -p $(BIN_DIR) $(DATA_INPUT_DIR) $(DATA_OUTPUT_DIR) $(DATA_GENERATED_DIR) $(TEMP_DIR) $(DOCS_IMG_DIR))

# Objetivo principal
all: c_implementation go_implementation utils

# Compilación de implementaciones
c_implementation: $(BIN_DIR)/matrix_mul
go_implementation: $(BIN_DIR)/matrix_mul_go
utils: $(BIN_DIR)/gen_matrix

# Compilación de la implementación en C
$(BIN_DIR)/matrix_mul: $(SRC_C_DIR)/matrix_mul.c
	$(CC) $(CFLAGS) -o $@ $<

# Compilación de la utilidad para generar matrices
$(BIN_DIR)/gen_matrix: $(UTILS_DIR)/gen_matrix.c
	$(CC) $(CFLAGS) -o $@ $<

# Compilación de la implementación en Go
$(BIN_DIR)/matrix_mul_go: $(SRC_GO_DIR)/matrix_mul.go
	$(GO) build -o $@ $<

# Configuración del entorno virtual
venv:
	$(PYTHON) -m venv $(VENV_DIR)

install_deps: venv
	$(PIP) install -r requirements.txt

# Generación de matrices de prueba
gen_test_data: $(BIN_DIR)/gen_matrix
	./$(BIN_DIR)/gen_matrix A_generated.txt 12 15 100
	./$(BIN_DIR)/gen_matrix B_generated.txt 15 10 100

# Ejecución de las implementaciones
run_c: $(BIN_DIR)/matrix_mul gen_test_data
	./$(BIN_DIR)/matrix_mul $(DATA_GENERATED_DIR)/A_generated.txt $(DATA_GENERATED_DIR)/B_generated.txt 4 $(DATA_OUTPUT_DIR)/C_new.txt

run_go: $(BIN_DIR)/matrix_mul_go gen_test_data
	./$(BIN_DIR)/matrix_mul_go $(DATA_GENERATED_DIR)/A_generated.txt $(DATA_GENERATED_DIR)/B_generated.txt 4 $(DATA_OUTPUT_DIR)/C_go_new.txt

# Pruebas de rendimiento
performance: $(BIN_DIR)/matrix_mul $(UTILS_DIR)/performance_test.sh
	chmod +x $(UTILS_DIR)/performance_test.sh
	./$(UTILS_DIR)/performance_test.sh

# Generación de gráficos
graphs: $(UTILS_DIR)/generate_graphs.py
	$(PYTHON) $(UTILS_DIR)/generate_graphs.py $(TEMP_DIR)/performance_results.csv

# Validación de resultados
validate_results: $(DATA_OUTPUT_DIR)/C.txt $(DATA_OUTPUT_DIR)/C_go.txt tests/test_matrices/expected_result.txt
	diff -q $(DATA_OUTPUT_DIR)/C.txt tests/test_matrices/expected_result.txt && echo "C implementation results match expected output."
	diff -q $(DATA_OUTPUT_DIR)/C_go.txt tests/test_matrices/expected_result.txt && echo "Go implementation results match expected output."

# Limpieza
clean:
	rm -f $(BIN_DIR)/*
	find . -name "*.o" -delete

clean_all: clean
	rm -f $(DATA_INPUT_DIR)/*.txt $(DATA_OUTPUT_DIR)/*.txt $(DATA_GENERATED_DIR)/*.txt
	rm -f $(TEMP_DIR)/*.csv $(TEMP_DIR)/*.txt

.PHONY: all c_implementation go_implementation utils venv install_deps gen_test_data run_c run_go performance graphs validate_results clean clean_all