using Temporal
crude = quandl("CHRIS/CME_CL1")
typeof(crude)
crude.fields
crude.index
crude["1983-05-01/2021",[:Open,:High]]