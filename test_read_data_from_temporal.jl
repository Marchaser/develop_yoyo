using BTester
using Temporal
using BenchmarkTools
# crude = quandl("CHRIS/CME_CL1")
crude = tsread("data/crude.csv")

# Get data
data = convert_to_trader_data([:crude], [crude], "1984", "2020", 
    NamedTuple(Dict(
        :open => :Open,
        :high => :High,
        :low => :Low,
        :close => :Last
    ))
)

# Construct data trade
temp = (crude=1,)
typeof((1,)) <: NTuple{1,Any}
typeof(temp)
temp = NamedTuple{(:crude,), NTuple{1,Int64}}(1)
typeof(temp) <: NamedTuple{(:crude,), NTuple{1,Int64}}

function print_tuple_info(temp::NamedTuple{S,NTuple{N,T}}) where {S,N,T}
    println(S,N,T)
end
print_tuple_info(temp)

struct tuple_with_info{S,N,T}
    t::NamedTuple{S,NTuple{N,T}}
end

temp = (crude=1,oil=2)
print_tuple_info(::tuple_with_info{S,N,T}) where{S,N,T} = println(S,N,T)
print_tuple_info(tuple_with_info(temp))

trader = construct_day_trader(data=data, cash=1000.0)
@code_warntype construct_day_trader(data=data, cash=1000.0)
@benchmark trader = construct_day_trader(data=data, cash=1000.0)

trader = DayTrader(data=data, cash=1000.0)

