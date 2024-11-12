module Project

# Write your package code here.
using Plots
using DifferentialEquations 
include("level2.jl")
include("level3.jl")
include("level4.jl")
include("level4error.jl")
include("level5.jl")
include("level5a.jl")
include("level5b.jl")
export plot_level2, plot_level3, plot_level4, plot_level4e, plot_level5, plot_level5a, plot_level5b

end
