#!/usr/bin/env python3
"""
Script to generate performance graphs from matrix multiplication results
"""

import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <csv_file>")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    try:
        # Read the CSV file
        df = pd.read_csv(csv_file)
        
        # Create a directory for plots
        import os
        os.makedirs("plots", exist_ok=True)
        
        # Extract unique matrix sizes
        sizes = df['Matrix Size'].unique()
        
        # Plot 1: Speedup vs Process Count for each matrix size
        plt.figure(figsize=(10, 6))
        for size in sizes:
            size_df = df[df['Matrix Size'] == size]
            plt.plot(size_df['Process Count'], size_df['Speedup'], 
                     marker='o', label=f"Matrix {size}")
        
        plt.xlabel('Number of Processes')
        plt.ylabel('Speedup')
        plt.title('Speedup vs. Number of Processes')
        plt.grid(True, linestyle='--', alpha=0.7)
        plt.legend()
        plt.savefig("plots/speedup_vs_processes.png", dpi=300, bbox_inches='tight')
        
        # Plot 2: Execution time vs Process Count for each matrix size
        plt.figure(figsize=(10, 6))
        for size in sizes:
            size_df = df[df['Matrix Size'] == size]
            plt.plot(size_df['Process Count'], size_df['Parallel Time'], 
                     marker='o', label=f"Matrix {size}")
        
        plt.xlabel('Number of Processes')
        plt.ylabel('Execution Time (seconds)')
        plt.title('Execution Time vs. Number of Processes')
        plt.grid(True, linestyle='--', alpha=0.7)
        plt.legend()
        plt.savefig("plots/execution_time_vs_processes.png", dpi=300, bbox_inches='tight')
        
        # Plot 3: Efficiency vs Process Count for each matrix size
        plt.figure(figsize=(10, 6))
        for size in sizes:
            size_df = df[df['Matrix Size'] == size]
            # Calculate efficiency (speedup/process count)
            efficiency = size_df['Speedup'] / size_df['Process Count']
            plt.plot(size_df['Process Count'], efficiency, 
                     marker='o', label=f"Matrix {size}")
        
        plt.xlabel('Number of Processes')
        plt.ylabel('Efficiency (Speedup/Processes)')
        plt.title('Parallel Efficiency vs. Number of Processes')
        plt.grid(True, linestyle='--', alpha=0.7)
        plt.legend()
        plt.savefig("plots/efficiency_vs_processes.png", dpi=300, bbox_inches='tight')
        
        # Plot 4: Sequential vs Parallel Time for largest matrix
        largest_matrix = sizes[-1]
        largest_df = df[df['Matrix Size'] == largest_matrix]
        
        plt.figure(figsize=(10, 6))
        
        x = np.arange(len(largest_df['Process Count']))
        width = 0.35
        
        plt.bar(x - width/2, largest_df['Sequential Time'], width, label='Sequential')
        plt.bar(x + width/2, largest_df['Parallel Time'], width, label='Parallel')
        
        plt.xlabel('Number of Processes')
        plt.ylabel('Execution Time (seconds)')
        plt.title(f'Sequential vs. Parallel Time (Matrix {largest_matrix})')
        plt.xticks(x, largest_df['Process Count'])
        plt.legend()
        plt.grid(True, linestyle='--', alpha=0.3, axis='y')
        plt.savefig("plots/sequential_vs_parallel.png", dpi=300, bbox_inches='tight')
        
        print(f"Graphs generated successfully in the 'plots' directory")
        
    except Exception as e:
        print(f"Error generating graphs: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()