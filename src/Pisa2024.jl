module Pisa2024

greet() = print("Hello Pisa!")
export greet

include("Sottomodulo.jl")
using .Sottomodulo
export ciao

include("orbit.jl")
export orbit

include("chisono.jl")
export chisono

end