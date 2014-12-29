
library(ggplot2)

d <- data.frame(a=c(1:12),  b = 5* sin(c(1:12)),  c1=c(rep(c("Odd","Even"),times=6)))

d



#qplot(x=a, y=b,data=d)

points <- qplot(x=a, y=b, data=d, xlab="x-", ylab="y-", colour=c1, facets = c1~., geom=c("bar","path","point"))

print(points)

print(d$c1)

