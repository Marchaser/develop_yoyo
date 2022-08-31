# Some desired interface

# Initiate trader to read from data
symbol = "AAPL"
data = load_data_from_yahoo(symbol)
trader = construct_offline_trader(data,start_date="20150101",end_date="20151231",frequency=:day)

# The backtesting loop
while(true)
    # Get information from trader
    prices = get_history_bars(trader, symbol, :close, 30)
    # use offset array to express prices
    ind1 = mma(prices[-15:0])
    ind2 = mmb(prices[-30:0])
    signal = ind1 ↑ ind2 # crossing from below
    order = MarketOrder(symbol=symbol, quantity=100)
    # a list of orders
    orders = [order]

    # Make order
    info = place_order!(trader, orders)

    # Record info
    record!(recorder, info)

    # Break if some condition
    cond && break

    # Move forward
    step!(trader)
end

# performance
performance = get_performance(trader)

# Should trader maintain the transaction history?
# No. Should be delegated to a recorder