# julia_apptainer
How to create a julia apptainer and submit julia jobs

First we create an apptainer `julia_to_overlay.sif` that contains julia, by downloading the desired version. Another option would be to install juliaup - still to be tried.
In the `julia_to_overlay.def` the `JULIA_DEPOT_PATH` in `%environment` is already set to the writeable overlay that we will create later.
```
apptainer build julia_to_overlay.sif julia_to_overlay.def
```
Now, since the apptainer itself is read-only (and if made writeable, its disk space is limited to 64 MiB), we create a writeable overlay. The size of the overlay can be modified by the `--size` option.
```
apptainer overlay create --size 4096 /lustre/alice/users/fcapell/julia_overlay.img
```
We can now enter the overlay through the apptainer 
```
apptainer shell --overlay /lustre/alice/users/fcapell/julia_overlay.img:rw julia_to_overlay.sif
```
where the `rw` option means that the overlay is in a read-write mode. As a test, we can enter julia from here and check that the depot path is where we set it
```
julia; println(DEPOT_PATH)
```
Now we can add the packages that we need. We can do it directly from the terminal with
```
using Pkg; Pkg.add("MyPackage")
```
or submit a job that does it for us
```
sbatch julia_add_packages_overlay.sh
```
This job could last up to 5 hours. Make sure to allocate enough time. To check that everything worked out, we can run a job that enters the overlay and uses those packages
```
sbatch debug.sh
```
If it doesn't recognize some packages, try to rerun the add packages command, to make sure it finishes. Another possibility is that you didn't allocate enough space for the overlay, that can be resized.
If everything worked out, enjoy :)
