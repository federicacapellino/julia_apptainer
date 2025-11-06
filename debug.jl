using MonteCarloGlauber
using Fluidum
using YAML
using Plots
println("setting up EOS")
entropy(T)=pressure_derivative(T,Val(1),eos) #entropy as function of temperature
println("done")
