
#library(ggplot2)

a <- c(1,2,3)

# a

d <- data.frame(a=c(0:9),  b = c(1:10), c=c(rep(c("Odd","Even"),times=5)))

d

typeof(d$c)
class(d$c)