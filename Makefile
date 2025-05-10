CC = gcc
CFLAGS = -Wall -O2
GO = go

# Directories
SRC_C_DIR = src/c
SRC_GO_DIR = src/go
UTILS_DIR = utils
BIN_DIR = bin
DATA_DIR = data
DATA_INPUT_DIR = $(DATA_DIR)/input
DATA_OUTPUT_DIR = $(DATA_DIR)/output

# Make sure directories exist
$(shell mkdir -p $(BIN_DIR) $(DATA_INPUT_DIR) $(DATA_OUTPUT_DIR))

# Targets
all: c_implementation go_implementation utils

c_implementation: $(BIN_DIR)/matrix_mul

go_implementation: $(BIN_DIR)/matrix_mul_go

utils: $(BIN_DIR)/gen_matrix $(BIN_DIR)/child_process

# C matrix multiplication
$(BIN_DIR)/matrix_mul: $(SRC_C_DIR)/matrix_mul.c
	$(CC) $(CFLAGS) -o $@ $<

# Child process used by Go implementation
$(BIN_DIR)/child_process: $(SRC_C_DIR)/child_process.c
	$(CC) $(CFLAGS) -o $@ $<

# Matrix generator utility
$(BIN_DIR)/gen_matrix: $(UTILS_DIR)/gen_matrix.c
	$(CC) $(CFLAGS) -o $@ $<

# Go matrix multiplication
$(BIN_DIR)/matrix_mul_go: $(SRC_GO_DIR)/matrix_mul.go
	$(GO) build -o $@ $<

# Generate test matrices
gen_test_data: $(BIN_DIR)/gen_matrix
	./$(BIN_DIR)/gen_matrix $(DATA_INPUT_DIR)/A.txt 10 8 100
	./$(BIN_DIR)/gen_matrix $(DATA_INPUT_DIR)/B.txt 8 12 100

# Run tests with C implementation
test_c: $(BIN_DIR)/matrix_mul gen_test_data
	./$(BIN_DIR)/matrix_mul $(DATA_INPUT_DIR)/A.txt $(DATA_INPUT_DIR)/B.txt 4 $(DATA_OUTPUT_DIR)/C.txt

# Run tests with Go implementation
test_go: $(BIN_DIR)/matrix_mul_go gen_test_data
	./$(BIN_DIR)/matrix_mul_go $(DATA_INPUT_DIR)/A.txt $(DATA_INPUT_DIR)/B.txt 4 $(DATA_OUTPUT_DIR)/C_go.txt

# Run performance tests
performance: $(BIN_DIR)/matrix_mul $(UTILS_DIR)/performance_test.sh
	chmod +x $(UTILS_DIR)/performance_test.sh
	cd $(UTILS_DIR) && ./performance_test.sh

# Generate graphs from performance results
graphs: $(UTILS_DIR)/generate_graphs.py
	cd $(UTILS_DIR) && python3 generate_graphs.py performance_results.csv

# Clean build artifacts
clean:
	rm -f $(BIN_DIR)/*
	find . -name "*.o" -delete

# Clean all generated data
clean_all: clean
	rm -f $(DATA_INPUT_DIR)/*.txt $(DATA_OUTPUT_DIR)/*.txt
	rm -f $(UTILS_DIR)/performance_results.csv
	rm -rf plots

.PHONY: all c_implementation go_implementation utils gen_test_data test_c test_go performance graphs clean clean_all