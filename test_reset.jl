using Accessors
using BenchmarkTools
using NamedTupleTools
using StructArrays

symbols = ntuple(i->Symbol(repeat("a",i)),100)
x = ntuple(x->1.0, 100);
named = NamedTuple{symbols}(x);

@mem named.a=2.0

# Does reset allocate?
@benchmark @reset $named.a=2.0

xxx = Dict(pairs(named))
@benchmark xxx[:a]=2.0

xx = [i for i in x]
@benchmark $xx[21]=2.0

@benchmark map(x->x+1.0, $xx)
@benchmark map(x->x+1, $named)