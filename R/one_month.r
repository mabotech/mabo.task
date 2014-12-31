
Sys.setlocale("LC_ALL", "C")

#library(reshape2)
library(ggplot2)

monthly_stats <- function(DF) {

    #print(DF)
    #DF1 <- melt(DF, id.var="Date")

    #print(DF1)
    plt <- ggplot(DF, aes(x = Date, y = F2)) + 
            ylab("效率(%)") +
            ggtitle(iconv("月运行情况","UTF-8","UTF-8")) + #iconv
            geom_bar(stat = "identity", alpha=0.9, fill="#2ECC40", position="dodge") +
            scale_x_continuous(breaks=DF$Date, labels=DF$DateString) +  
            theme(axis.text.x = element_text(angle=90, vjust=0.1, size=6))

    ggsave("output/monthly_stats.png",width=6, height=4)
    
}


DF <- read.table(text="Date    DateString    F1     F2     F3
1    2014-12-1    0    41    59
2    2014-12-2    1    59    62
3    2014-12-3    2    75    96
4    2014-12-4    3    93    92
5    2014-12-5    4    65    95
6    2014-12-6    5    0    0
7    2014-12-7    6    0    0
8    2014-12-8    0    99    50
9    2014-12-9    1    55    93
10    2014-12-10    2    51    71
11    2014-12-11    3    47    82
12    2014-12-12    4    61    91
13    2014-12-13    5    0    0
14    2014-12-14    6    0    0
15    2014-12-15    0    64    67
16    2014-12-16    1    61    72
17    2014-12-17    2    99    69
18    2014-12-18    3    76    93
19    2014-12-19    4    98    82
20    2014-12-20    5    0    0
21    2014-12-21    6    0    0
22    2014-12-22    0    59    62
23    2014-12-23    1    91    86
24    2014-12-24    2    42    81
25    2014-12-25    3    96    93
26    2014-12-26    4    97    80
27    2014-12-27    5    0    0
28    2014-12-28    6    0    0
29    2014-12-29    0    96    55
30    2014-12-30    1    76    91
31    2014-12-31    2    97    94", header=TRUE)

monthly_stats(DF)