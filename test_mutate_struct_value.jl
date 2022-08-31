
using RedefStructs
@redef mutable struct TestType
    a::Int64
    b::Float64
end

temp = TestType(1,0.1)

function change!(x)
    x.a += 3
end

change!(temp)
temp
