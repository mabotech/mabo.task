DF <- read.table(text="Rank F1     F2     F3
1    500    250    50
2    400    100    30
3    300    155    100
4    200    90     10
5    300    100     20", header=TRUE)

print(DF)

library(reshape2)
DF1 <- melt(DF, id.var="Rank")

print(DF1)

library(ggplot2)
ggplot(DF1, aes(x = Rank, y = value, fill = variable)) + 
        geom_bar(stat = "identity", alpha=0.9, position="dodge")
  
  ggsave("test1.png",width=5, height=4)