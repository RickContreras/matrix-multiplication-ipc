package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
    "sync"
    "time"
)

// Función para leer una matriz desde un archivo
func readMatrixFromFile(filename string) ([][]float64, int, int, error) {
    file, err := os.Open(filename)
    if err != nil {
        return nil, 0, 0, fmt.Errorf("error al abrir el archivo %s: %v", filename, err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    scanner.Scan()
    dimensions := strings.Fields(scanner.Text())
    if len(dimensions) != 2 {
        return nil, 0, 0, fmt.Errorf("error al leer las dimensiones de la matriz en %s", filename)
    }

    rows, _ := strconv.Atoi(dimensions[0])
    cols, _ := strconv.Atoi(dimensions[1])

    matrix := make([][]float64, rows)
    for i := 0; i < rows; i++ {
        matrix[i] = make([]float64, cols)
        if scanner.Scan() {
            values := strings.Fields(scanner.Text())
            for j := 0; j < cols; j++ {
                matrix[i][j], _ = strconv.ParseFloat(values[j], 64)
            }
        }
    }

    return matrix, rows, cols, nil
}

// Función para escribir una matriz en un archivo
func writeMatrixToFile(filename string, matrix [][]float64) error {
    file, err := os.Create(filename)
    if err != nil {
        return fmt.Errorf("error al crear el archivo %s: %v", filename, err)
    }
    defer file.Close()

    rows := len(matrix)
    cols := len(matrix[0])
    fmt.Fprintf(file, "%d %d\n", rows, cols)

    for _, row := range matrix {
        for _, val := range row {
            fmt.Fprintf(file, "%f ", val)
        }
        fmt.Fprintln(file)
    }

    return nil
}

// Multiplicación secuencial de matrices
func multiplyMatricesSequential(A, B [][]float64) [][]float64 {
    N, M := len(A), len(A[0])
    P := len(B[0])
    C := make([][]float64, N)
    for i := range C {
        C[i] = make([]float64, P)
    }

    for i := 0; i < N; i++ {
        for j := 0; j < P; j++ {
            for k := 0; k < M; k++ {
                C[i][j] += A[i][k] * B[k][j]
            }
        }
    }

    return C
}

// Multiplicación paralela de matrices
func multiplyMatricesParallel(A, B [][]float64, K int) [][]float64 {
    N, M := len(A), len(A[0])
    P := len(B[0])
    C := make([][]float64, N)
    for i := range C {
        C[i] = make([]float64, P)
    }

    var wg sync.WaitGroup
    rowsPerProcess := N / K
    remainingRows := N % K

    startRow := 0
    for i := 0; i < K; i++ {
        rowsForThisProcess := rowsPerProcess
        if i < remainingRows {
            rowsForThisProcess++
        }
        endRow := startRow + rowsForThisProcess

        wg.Add(1)
        go func(start, end int) {
            defer wg.Done()
            for r := start; r < end; r++ {
                for j := 0; j < P; j++ {
                    for k := 0; k < M; k++ {
                        C[r][j] += A[r][k] * B[k][j]
                    }
                }
            }
        }(startRow, endRow)

        startRow = endRow
    }

    wg.Wait()
    return C
}

func main() {
    if len(os.Args) != 5 {
        fmt.Println("Uso: go run matrix_mul.go <A_file> <B_file> <num_processes> <output_file>")
        return
    }

    fileA := os.Args[1]
    fileB := os.Args[2]
    K, _ := strconv.Atoi(os.Args[3])
    outputFile := os.Args[4]

    A, N, M, err := readMatrixFromFile(fileA)
    if err != nil {
        fmt.Println(err)
        return
    }

    B, MCheck, P, err := readMatrixFromFile(fileB)
    if err != nil {
        fmt.Println(err)
        return
    }

    if M != MCheck {
        fmt.Println("Error: Las dimensiones de las matrices no son compatibles para la multiplicación")
        return
    }

    if K > N {
        fmt.Printf("Advertencia: El número de procesos (%d) excede el número de filas (%d). Ajustando K = N\n", K, N)
        K = N
    }

    fmt.Printf("Dimensiones de las matrices: A(%dx%d) × B(%dx%d) = C(%dx%d)\n", N, M, M, P, N, P)

    // Multiplicación secuencial
    start := time.Now()
    CSeq := multiplyMatricesSequential(A, B)
    end := time.Now()
    fmt.Printf("Tiempo de multiplicación secuencial: %.6f segundos\n", end.Sub(start).Seconds())

    // Multiplicación paralela
    start = time.Now()
    CPar := multiplyMatricesParallel(A, B, K)
    end = time.Now()
    fmt.Printf("Tiempo de multiplicación paralela (%d procesos): %.6f segundos\n", K, end.Sub(start).Seconds())

    // Verificación de resultados
    identical := true
    for i := 0; i < N; i++ {
        for j := 0; j < P; j++ {
            if CSeq[i][j] != CPar[i][j] {
                identical = false
                break
            }
        }
    }

    if identical {
        fmt.Println("Verificación: Los resultados secuenciales y paralelos coinciden.")
    } else {
        fmt.Println("Verificación: Los resultados secuenciales y paralelos NO coinciden.")
    }

    // Escribir el resultado en un archivo
    err = writeMatrixToFile(outputFile, CPar)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Printf("Resultado escrito en %s\n", outputFile)
}