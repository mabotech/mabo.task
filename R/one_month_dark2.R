
Sys.setlocale("LC_ALL", "C")

library(reshape2)
library(ggplot2)

monthly_stats <- function(DF) {

    #print(DF)
    DF1 <- melt(DF, id.var=c("Date","DateString"))

    print(DF1)
    plt <- ggplot(DF, aes(Date)) + 
            ylab("效率(%)") +
            #ggtitle(iconv("月运行情况","UTF-8","UTF-8")) + #iconv
            #geom_bar(stat = "identity", alpha=0.9, fill="#2ECC40", position="dodge") +
            
            geom_line(aes(y=F1, colour="red"))+
             geom_line(aes(y=F2, colour="green"))+
              geom_line(aes(y=F3, colour="blue"))+
              geom_line(aes(y=F3, colour="yellow"))+
            
            scale_x_continuous(breaks=DF$Date, labels=DF$DateString) +  
            theme(axis.text.x = element_text(angle=90, vjust=0.1, size=6, ,  color="#BBBFC2"),
            
               axis.title.x=element_blank(),
                    axis.text.y = element_text(size=7,  color="#BBBFC2"),
                    axis.title.y = element_text(size=10,  color="#BBBFC2"),
                    
                                panel.grid.major=element_line(color="#444444"),
                    panel.grid.minor=element_line(color="#444444"),
                    panel.background=element_blank(), 
                    #panel.border=element_rect(color= "#1F1F1F"),
                    legend.title = element_text(size=7,  color="#BBBFC2"),
                    legend.text = element_text(size=7,  color="#BBBFC2"),
                    legend.background = element_rect(colour = '#1F1F1F', fill = '#1F1F1F'),
                    plot.background=element_rect(fill = "#1F1F1F", color = "#1F1F1F")
            
            )

    ggsave("output/monthly_stats2.png",width=6, height=3)
    
}


DF <- read.table(text="Date DateString  F1  F2  F3  F4
1   2014-12-01   4  3  4  3
2   2014-12-02   7  10  8  7
3   2014-12-03   7  8  9  10
4   2014-12-04   7  8  6  8
5   2014-12-05   9  7  9  7
6   2014-12-06   0  0  0  0
7   2014-12-07   0  0  0  0
8   2014-12-08   5  5  5  4
9   2014-12-09   6  10  9  6
10   2014-12-10   7  7  9  8
11   2014-12-11   9  9  9  10
12   2014-12-12   6  10  6  7
13   2014-12-13   0  0  0  0
14   2014-12-14   0  0  0  0
15   2014-12-15   3  3  4  4
16   2014-12-16   7  6  8  7
17   2014-12-17   9  7  10  9
18   2014-12-18   6  9  8  6
19   2014-12-19   8  9  6  10
20   2014-12-20   0  0  0  0
21   2014-12-21   0  0  0  0
22   2014-12-22   4  4  4  5
23   2014-12-23   9  6  6  6
24   2014-12-24   6  8  8  9
25   2014-12-25   9  8  6  10
26   2014-12-26   9  8  10  6
27   2014-12-27   0  0  0  0
28   2014-12-28   0  0  0  0
29   2014-12-29   4  4  5  4
30   2014-12-30   9  8  9  10
31   2014-12-31   6  6  7  9", header=TRUE)

monthly_stats(DF)