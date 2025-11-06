#!/bin/bash
#SBATCH --array=0-0
#SBATCH --job-name=julia_debug
#SBATCH --time=00:20:00
#SBATCH --chdir=./
#SBATCH --mem=12G
#SBATCH --cpus-per-task=1
#SBATCH --partition=debug
#SBATCH -o ./%x_%A_%a.out
#SBATCH -e ./%x_%A_%a.err

cd /lustre/alice/users/fcapell/

echo "enter overlay..."
apptainer exec --overlay /lustre/alice/users/fcapell/julia_overlay.img:rw \
  julia_to_overlay.sif \
  bash -c "julia /lustre/alice/users/fcapell/debug.jl"

echo "done."
