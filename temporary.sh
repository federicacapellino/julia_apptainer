#!/bin/bash
#SBATCH --array=0-0
#SBATCH --job-name=julia_setup_project
#SBATCH --time=00:30:00
#SBATCH --chdir=./
#SBATCH --mem=16G
#SBATCH --cpus-per-task=1
#SBATCH --partition=debug
#SBATCH -o ./logs/%x_%A_%a.out
#SBATCH -e ./logs/%x_%A_%a.err

echo "trying multiple overlays"
cd /lustre/alice/users/fcapell/

WRITABLE_OVERLAY=/tmp/julia_overlay_${SLURM_JOB_ID}.img
apptainer overlay create --size 512 $WRITABLE_OVERLAY

apptainer exec \
    --overlay julia_overlay.img:ro \
    --overlay $WRITABLE_OVERLAY:rw \
    julia_to_overlay_2.sif \
    bash -c "julia /lustre/alice/users/fcapell/debug.jl"

rm $WRITABLE_OVERLAY
