# julia_apptainer
How to create a julia apptainer and submit julia jobs

First we create an apptainer `julia_to_overlay.sif` that contains julia, by downloading the desired version. Another option would be to install juliaup - still to be tried.
In the `julia_to_overlay.def` the `JULIA_DEPOT_PATH` in `%environment` is already set to the writeable overlay that we will create later.
```
apptainer build julia_to_overlay.sif julia_to_overlay.def
```
In `julia_to_overlay_2.def` you find the example for a more complete definition of the apptainer with the packages that you want to add in your overlay.
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
To check that everything worked out, we can run a job that enters the overlay and uses those packages
```
sbatch debug.sh
```
Notice that you can not concurrently run multiple instances of the overlay in rw mode. The best choice is to stack a second small writeable overlay per job, and delete it at the end of each job
```
sbatch temporary.sh
```

To check the occupied space of the overlay, run
```
du -sh /path/to/overlay/julia_overlay.img 
```
You can extend it with
```
truncate -s +2G /path/to/overlay/julia_overlay.img
```
If everything worked out, enjoy :)
