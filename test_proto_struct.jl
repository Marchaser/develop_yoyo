using ProtoStructs

abstract type AbstractDevType end
@proto mutable struct DevType <: AbstractDevType
    a::Int = 1
    b::Float64 = 2.0
end

temp = DevType()


typeof(temp) <: AbstractDevType
temp = DevType()
temp.a=2