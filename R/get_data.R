

library("rjson")

json_file <- "http://192.168.147.140:8086/db/monitor/series?u=root&p=root&q=select%20max(a)%20from%20lab2%20where%20time%20%3E%20now()-6h%20group%20by%20time(10m)"

json_data <- fromJSON(file=json_file)

json_data[[1]]$points