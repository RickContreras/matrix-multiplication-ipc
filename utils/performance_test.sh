#!/bin/bash
# Performance testing script for matrix multiplication

# Ensure executables exist
if [ ! -f "./bin/matrix_mul" ] || [ ! -f "./bin/gen_matrix" ]; then
    echo "Error: Required executables not found. Run 'make' first."
    exit 1
fi

# Create temp directory if it doesn't exist
TEMP_DIR="temp"
mkdir -p $TEMP_DIR

# Test parameters
SIZES=("100 100 100" "500 500 500" "1000 800 800" "2000 1500 1500" "3000 2000 2000")
PROCESS_COUNTS=(1 2 4 8 16 32)
OUTPUT_FILE="$TEMP_DIR/performance_results.csv"

# Create CSV header
echo "Matrix Size,Process Count,Sequential Time,Parallel Time,Speedup" > $OUTPUT_FILE

# Function to extract time from program output
extract_time() {
    grep "$1" $2 | head -n 1 | awk -F': ' '{print $2}' | awk '{print $1}' || echo "0"
}

# Run tests
for size in "${SIZES[@]}"; do
    read -r N M P <<< "$size"
    
    echo "Testing matrix size A(${N}x${M}) x B(${M}x${P})..."
    
    # Generate test matrices
    ./bin/gen_matrix A.txt $N $M 100
    ./bin/gen_matrix B.txt $M $P 100
    
    for procs in "${PROCESS_COUNTS[@]}"; do
        echo "  Running with $procs processes..."
        
        # Run with redirected output
        ./bin/matrix_mul ./data/generated/A.txt ./data/generated/B.txt $procs ./data/output/C.txt > $TEMP_DIR/temp_output.txt
        
        # Extract timing information
        SEQ_TIME=$(extract_time "Sequential multiplication time:" $TEMP_DIR/temp_output.txt)
        PAR_TIME=$(extract_time "Parallel multiplication time" $TEMP_DIR/temp_output.txt)
        SPEEDUP=$(extract_time "Speedup:" $TEMP_DIR/temp_output.txt | sed 's/x//') # Elimina la "x" del speedup

        # Save to CSV
        echo "${N}x${M}x${P},$procs,$SEQ_TIME,$PAR_TIME,$SPEEDUP" >> $OUTPUT_FILE
    done
done

echo "Performance testing complete. Results saved to $OUTPUT_FILE"
echo "You can now generate graphs using the provided Python script."

# Optional: Generate graph if Python and matplotlib are available
if command -v python3 &> /dev/null; then
    python3 utils/generate_graphs.py $OUTPUT_FILE
fi