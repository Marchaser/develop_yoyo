# Following the discussion here https://discourse.julialang.org/t/redefining-structs-without-restart/50826/40
# which is packed here: https://github.com/FedericoStra/RedefStructs.jl
using RedefStructs
abstract type AbstractDevType end
@redef mutable struct DevType <: AbstractDevType
    a::Int
    b::Float64
    c::Float64
end

temp = DevType(1,1.0,2.0)
typeof(temp)