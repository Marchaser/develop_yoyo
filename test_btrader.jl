using BTester
using Accessors
using BenchmarkTools
using DataFrames
using TypedTables
using Temporal
using OffsetArrays:Origin
df = DataFrame(a=[1,2,3], b=[2.0,4.0,6.0])
function convert_df_to_table(df)
    temp = Table(b=df.b)
    return temp
end
@benchmark convert_df_to_table($df)

function process_table(table)
    @inbounds table.b[1] = 0.2
end
temp = convert_df_to_table(df)
@benchmark process_table($temp)
@code_llvm process_table(temp)

function process_table_view(table)
    @inbounds table_view = view(table.b,2:3)
    table_view[end] = 0.2
    return table_view
end
function process_view_inline(table)
    table_view = process_table_view(table)
    table_view[end]=0.3
end
process_table_view(temp)
temp
@code_llvm process_table_view(temp)
@code_llvm process_view_inline(temp)

@code_warntype convert_df_to_table(df)
df
@benchmark $df.a
@benchmark $df[1,:]

all((true,true,))

t = Table(a = [1, 2, 3], b = [2.0, 4.0, 6.0])
length(t)
typeof(t)
typeof(t) <: Table
Table{NamedTuple, 2}
typeof(t) <: Table{NamedTuple, 2}
@benchmark $t.a
@benchmark $t[1]

values = [1.0 2.0 3.0; 4.0 5.0 6.0]'
ttt = TS(values)
t = Table(a=view(ttt[:A].values,:,1))
t
t.a[1] = 0.2
ttt[1]
ttt[1,:A]
@benchmark $ttt[1]

temp = (a=:a,)
typeof(temp) <: NamedTuple{Symbol}


symbols = [:a,:b]
values = [1,2]
Dict(zip(symbols,values))
NamedTuple(zip(symbols,values))

tt = (;
a = [1,2,3],
b = [2.0,4.0,6.0],
)
@benchmark $tt.a


context = Dict(
    :a => 0.1
)
context[:b] = 0.2
temp = NamedTuple(context)
@reset temp.a = 0.5

NamedTuple{(:a,:b), NTuple{2,Int64}}((1,2))

function xxx()
    y = ntuple(x->1, 10)
end

@benchmark xxx()

temp = Dict(
    :SH00001 => 1,
    :SH00002 => 2
)
temp2 = NamedTuple(temp)
typeof(temp2) <: NamedTuple
typeof(temp2)
typeof((2,2)) <: NTuple{2,Int64}

function print_type(::NamedTuple{S, NTuple{N,Int64}}) where {S,N}
    println(S,N)
    return S
end
a = print_type(temp2)
typeof(a) <: NTuple{2}

map(x->x+1, temp2)


function init(context::Dict{Symbol,Any})
    context[:s1] = "000001.XSHE"
    context[:SHORTPERIOD] = 20
    context[:LONGPERIOD] = 120
end

function before_trading(context)
end

function handle_bar(context::NamedTuple, bar_dict)
    prices = history_bars(context.s1, context.LONGPERIOD+1, "1d", "close")

    short_avg = SMA(prices, context.SHORTPERIOD)
    long_avg = SMA(prices, context.LONGPERIOD)

    cur_position = get_position(context.s1).quantity
    shares = context.portfolio.cash / bar_dict[context.s1].close
end

function after_trading(context)
end

A = [1.0;2.0;3.0]
view(A,1:3)