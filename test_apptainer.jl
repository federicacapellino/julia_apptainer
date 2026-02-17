println("--- Loading packages ---")

using Fluidum
using MonteCarloGlauber
using YAML

println("--- packages are loaded. ---")


# 2. Check Architecture
# This confirms which "slice" of your JULIA_CPU_TARGET is being used
println("CPU Arch:       ", Sys.ARCH)
println("CPU Model:      ", Sys.cpu_info()[1].model)

# 3. Check Threading
# This confirms if $SLURM_CPUS_PER_TASK was passed correctly
n_threads = Threads.nthreads()
println("Total Threads:  ", n_threads)

# 4. Stress Test / Affinity Check
# Simple parallel loop to show threads in action
println("\nTesting Thread Affinity...")
thread_ids = zeros(Int, n_threads)

Threads.@threads for i in 1:n_threads
    thread_ids[i] = Threads.threadid()
end

println("Active Thread IDs: ", thread_ids)

if n_threads > 1
    println("SUCCESS: Multi-threading is active.")
else
    println("WARNING: Only 1 thread detected. Check your SLURM --cpus-per-task.")
end
println("------------------------------")