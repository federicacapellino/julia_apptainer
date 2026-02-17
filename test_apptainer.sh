#!/bin/bash
#SBATCH --job-name=julia_test
#SBATCH --partition=debug
#SBATCH -o ./logs/%x_%A_%a.out
#SBATCH -e ./logs/%x_%A_%a.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8  
#SBATCH --mem=16G               
#SBATCH --time=00:30:00     
# --mail-type=END,FAIL          # Notify on job completion or failure
# --mail-user=f.capellino@gsi.de

# 1. Handle Julia Threading
# We map SLURM's allocated CPUs to Julia's thread count.
# Julia 1.12 handles this well, but setting it explicitly is best practice.
export JULIA_NUM_THREADS=${SLURM_CPUS_PER_TASK:-1}

# 2. Prevent Julia from trying to compile to a read-only container
# This ensures it only uses the "fat" precompiled binaries we built.
export JULIA_PKG_PRECOMPILE_AUTO=0

# 3. Define the path to your image
CONTAINER_IMG="julia_apptainer.sif"

# 4. Run the simulation
# --bind allows the container to see your current directory (where collision.jl is)
# We use 'exec' to replace the shell process with the Julia process
echo "Starting Julia collision script with $JULIA_NUM_THREADS threads..."

apptainer exec --bind $PWD:/mnt --pwd /mnt $CONTAINER_IMG \
    julia --project=. test_apptainerjl