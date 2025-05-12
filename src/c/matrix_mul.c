/*
* matrix_mul.c
* 
* This program performs matrix multiplication using both sequential and parallel methods.
* It reads two matrices from files, multiplies them, and writes the result to an output file.
* The parallel multiplication is done using multiple processes.
*
* Usage: ./matrix_mul <A_file> <B_file> <num_processes> <output_file>
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <sys/time.h>
#include <string.h>

// Function prototypes
void read_matrix_from_file(const char *filename, double *matrix, int rows, int cols);
void write_matrix_to_file(const char *filename, double *matrix, int rows, int cols);
void multiply_matrices_sequential(double *A, double *B, double *C, int N, int M, int P);
void multiply_matrices_parallel(double *A, double *B, double *C, int N, int M, int P, int K);
void print_matrix(double *matrix, int rows, int cols);
double get_time();

int main(int argc, char *argv[]) {
    if (argc != 5) {
        printf("Usage: %s <A_file> <B_file> <num_processes> <output_file>\n", argv[0]);
        return 1;
    }
    
    char *fileA = argv[1];
    char *fileB = argv[2];
    int K = atoi(argv[3]);      // Number of processes
    char *outputFile = argv[4]; // Output filename
    
    // Read matrix dimensions from first line of files
    FILE *fA = fopen(fileA, "r");
    FILE *fB = fopen(fileB, "r");
    
    if (!fA || !fB) {
        printf("Error opening input files\n");
        return 1;
    }
    
    int N, M, M_check, P;
    if (fscanf(fA, "%d %d", &N, &M) != 2) {
        printf("Error: No se pudieron leer las dimensiones de la matriz A\n");
        fclose(fA);
        fclose(fB);
        return 1;
    }
    if (fscanf(fB, "%d %d", &M_check, &P) != 2) {
        printf("Error: No se pudieron leer las dimensiones de la matriz B\n");
        fclose(fA);
        fclose(fB);
        return 1;
    }
    fclose(fA);
    fclose(fB);
    
    if (M != M_check) {
        printf("Error: Incompatible matrix dimensions for multiplication\n");
        return 1;
    }
    
    // Validate K <= N
    if (K > N) {
        printf("Warning: Number of processes (%d) exceeds number of rows (%d). Setting K = N\n", K, N);
        K = N;
    }
    
    // Allocate memory for matrices
    double *A = (double *)malloc(N * M * sizeof(double));
    double *B = (double *)malloc(M * P * sizeof(double));
    double *C_seq = (double *)malloc(N * P * sizeof(double));
    
    // Read matrices from files
    read_matrix_from_file(fileA, A, N, M);
    read_matrix_from_file(fileB, B, M, P);
    
    printf("Matrix dimensions: A(%d×%d) × B(%d×%d) = C(%d×%d)\n", N, M, M, P, N, P);
    
    // Perform sequential multiplication and measure time
    double start_time, end_time;
    
    start_time = get_time();
    multiply_matrices_sequential(A, B, C_seq, N, M, P);
    end_time = get_time();
    
    printf("Sequential multiplication time: %.6f seconds\n", end_time - start_time);
    // Calculate speedup
    double sequential_time = end_time - start_time;
    // Create shared memory for parallel multiplication
    int shmid_C = shmget(IPC_PRIVATE, N * P * sizeof(double), IPC_CREAT | 0666);
    if (shmid_C < 0) {
        perror("shmget");
        exit(1);
    }
    
    double *C_par = (double *)shmat(shmid_C, NULL, 0);
    if (C_par == (double *)-1) {
        perror("shmat");
        exit(1);
    }
    
    // Perform parallel multiplication and measure time
    start_time = get_time();
    multiply_matrices_parallel(A, B, C_par, N, M, P, K);
    end_time = get_time();
    
    printf("Parallel multiplication time (%d processes): %.6f seconds\n", K, end_time - start_time);
    
    // Calculate speedup

    double parallel_time = end_time - start_time;
    double speedup = sequential_time / parallel_time;
    printf("Speedup: %.2fx\n", speedup);
    
    // Verify correctness
    int identical = 1;
    for (int i = 0; i < N * P; i++) {
        if (C_seq[i] != C_par[i]) {
            identical = 0;
            break;
        }
    }
    
    if (identical) {
        printf("Verification: Sequential and parallel results match.\n");
    } else {
        printf("Verification: Sequential and parallel results DO NOT match!\n");
    }
    
    // Write result to file
    write_matrix_to_file(outputFile, C_par, N, P);
    printf("Result written to %s\n", outputFile);
    
    // Clean up
    free(A);
    free(B);
    free(C_seq);
    shmdt(C_par);
    shmctl(shmid_C, IPC_RMID, NULL);
    
    return 0;
}

// Get current time in seconds
double get_time() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + tv.tv_usec / 1000000.0;
}

// Read matrix from file
void read_matrix_from_file(const char *filename, double *matrix, int rows, int cols) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        printf("Error opening file %s\n", filename);
        exit(1);
    }
    
    // Skip dimension line
    int dummy1, dummy2;
    // Verificar fscanf en read_matrix_from_file
    if (fscanf(fp, "%d %d", &dummy1, &dummy2) != 2) {
        printf("Error: No se pudieron leer las dimensiones de la matriz en el archivo %s\n", filename);
        fclose(fp);
        exit(1);
    }
    
    // Read matrix values
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (fscanf(fp, "%lf", &matrix[i * cols + j]) != 1) {
                printf("Error reading matrix element at (%d,%d)\n", i, j);
                exit(1);
            }
        }
    }
    
    fclose(fp);
}

// Write matrix to file
void write_matrix_to_file(const char *filename, double *matrix, int rows, int cols) {
    FILE *fp = fopen(filename, "w");
    if (!fp) {
        printf("Error opening file %s for writing\n", filename);
        exit(1);
    }
    
    // Write dimensions as first line
    fprintf(fp, "%d %d\n", rows, cols);
    
    // Write matrix data
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            fprintf(fp, "%f ", matrix[i * cols + j]);
        }
        fprintf(fp, "\n");
    }
    
    fclose(fp);
}

// Print matrix (for debugging)
void print_matrix(double *matrix, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%f ", matrix[i * cols + j]);
        }
        printf("\n");
    }
}

// Sequential matrix multiplication
void multiply_matrices_sequential(double *A, double *B, double *C, int N, int M, int P) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < P; j++) {
            C[i * P + j] = 0;
            for (int k = 0; k < M; k++) {
                C[i * P + j] += A[i * M + k] * B[k * P + j];
            }
        }
    }
}

// Parallel matrix multiplication using multiple processes
void multiply_matrices_parallel(double *A, double *B, double *C, int N, int M, int P, int K) {
    // Calculate rows per process
    int rows_per_process = N / K;
    int remaining_rows = N % K;
    
    pid_t pid;
    int start_row = 0;
    
    // Create K child processes
    for (int i = 0; i < K; i++) {
        // Calculate the range of rows for this process
        int rows_for_this_process = rows_per_process + (i < remaining_rows ? 1 : 0);
        int end_row = start_row + rows_for_this_process;
        
        // Create child process
        pid = fork();
        
        if (pid < 0) {
            // Error creating process
            perror("fork");
            exit(1);
        } else if (pid == 0) {
            // Child process
            // Perform matrix multiplication for assigned rows
            for (int r = start_row; r < end_row; r++) {
                for (int j = 0; j < P; j++) {
                    C[r * P + j] = 0;
                    for (int k = 0; k < M; k++) {
                        C[r * P + j] += A[r * M + k] * B[k * P + j];
                    }
                }
            }
            
            // Child exits after computation
            exit(0);
        }
        
        // Parent continues to create next process
        start_row = end_row;
    }
    
    // Parent waits for all children to complete
    for (int i = 0; i < K; i++) {
        wait(NULL);
    }
}