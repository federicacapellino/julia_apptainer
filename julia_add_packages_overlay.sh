#!/bin/bash
#SBATCH --array=0-0
#SBATCH --job-name=julia_setup_project
#SBATCH --time=02:00:00
#SBATCH --chdir=./
#SBATCH --mem=12G
#SBATCH --cpus-per-task=1
#SBATCH --partition=main
#SBATCH -o ./%x_%A_%a.out
#SBATCH -e ./%x_%A_%a.err

echo "adding julia packages to the overlay.."
cd /lustre/alice/users/fcapell/


apptainer exec --overlay /lustre/alice/users/fcapell/julia_overlay.img:rw \
  julia_to_overlay.sif \
  bash -c "julia -e 'using Pkg; \
           Pkg.add(url=\"https://github.com/fafafrens/Fluidum.jl\"); \
           Pkg.add(url=\"https://github.com/AndreasKirchner/MonteCarloGlauber.jl\"); \
           Pkg.add([\"Plots\", \"YAML\"]); Pkg.precompile();\'"


echo "done."
