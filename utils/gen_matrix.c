/*
 * gen_matrix.c - Utility to generate test matrices
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void generate_matrix(const char *filename, int rows, int cols, int max_value) {
    FILE *fp = fopen(filename, "w");
    if (!fp) {
        printf("Error opening file %s for writing\n", filename);
        exit(1);
    }
    
    // Write dimensions as first line
    fprintf(fp, "%d %d\n", rows, cols);
    
    // Write random matrix data
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            fprintf(fp, "%d ", rand() % max_value);
        }
        fprintf(fp, "\n");
    }
    
    fclose(fp);
    printf("Generated %dx%d matrix in %s\n", rows, cols, filename);
}

int main(int argc, char *argv[]) {
    if (argc != 5) {
        printf("Usage: %s <output_file> <rows> <columns> <max_value>\n", argv[0]);
        return 1;
    }
    
    char *filename = argv[1];
    int rows = atoi(argv[2]);
    int cols = atoi(argv[3]);
    int max_value = atoi(argv[4]);
    
    // Seed random number generator
    srand(time(NULL));
    
    generate_matrix(filename, rows, cols, max_value);
    
    return 0;
}