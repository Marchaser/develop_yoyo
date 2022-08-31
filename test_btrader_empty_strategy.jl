using BTester
using Temporal
using BenchmarkTools
using TypedTables
crude = tsread("data/crude.csv")
data = convert_to_trader_data([:crude], [crude], 
    start_date="1984",
    end_date="2020", 
    column_names=NamedTuple(Dict(
        :open => :Open,
        :high => :High,
        :low => :Low,
        :close => :Last
    ))
)
trader = construct_day_trader(data=data, cash=1000.0)

function run_simple_strategy!(trader)
    init!(trader)
    while(true)
        # Get information from trader
        # prices = get_history_bars(trader, Val(:crude), Val(:close))
        prices = get_history_bars(trader, :crude, :close)
        # use offset array to express prices

        # Strategy
        for id in get_ids(trader)
            if trader.portfolios[id]==0
                order_lots!(trader;id=id,amount=1)
            end
        end

        # Record info
        # record!(recorder, info)

        # Move forward
        step!(trader) && break
    end
end
run_simple_strategy!(trader)
@benchmark run_simple_strategy!($trader)
@code_warntype run_simple_strategy!(trader)
trader.cash
trader.portfolios
