# julia_apptainer
How to create a julia apptainer and submit julia jobs

## Create the apptainer
First we create an apptainer `julia_apptainer.sif` that contains julia, by downloading the desired version. Another option would be to install juliaup - still to be tried.
In the `julia_apptainer.def` the `JULIA_DEPOT_PATH` in `%environment` is local to the apptainer.
```
apptainer build julia_apptainer.sif julia_apptainer.def
```

## Test the apptainer
You can enter the apptainer interactively and enter julia
```
apptainer shell julia_apptainer.sif
julia
```
```julia
using LinearAlgebra
```
Now, since the apptainer itself is read-only, you cannot add more julia packages at run time - since you would need to modify the manifest.toml and project.toml. In case you want to add a new package, you should rebuild your container (or bootstrap from the image you already built).

To check that everything worked out, we can run a job that enters the apptainer and uses those packages
```
sbatch test_apptainer.sh
```
Notice that in the `julia_apptainer.def` you specify the JULIA_CPU_TARGET: when running on different partitions that will have different cpu architectures, julia wants to recompile if the compilation for that specific cpu has not been cached already. This has to be specified at build time (with the variable in the `post`) to cache the precompilation, and at runtime (with the variable in the `environment`) to address those compilations.

If everything worked out, enjoy :)
