
Sys.setlocale("LC_ALL", "C")

library(reshape2)
library(ggplot2)

monthly_stats <- function(DF) {

    #print(DF)
    DF1 <- melt(DF, id.var=c("Date","DateString"))
    
    DF1$variable <- factor(DF1$variable, labels = c("重鼓", "耐久", "环境","高温"))
    #levels()
    print(DF1)
    plt <- ggplot(data = DF1, aes(x = Date, y = value  , color=variable)) + 
            ylab("数量") +
            #ggtitle(iconv("月运行情况","UTF-8","UTF-8")) + #iconv
            #geom_bar(stat = "identity", alpha=0.9, fill="#2ECC40", position="dodge") +
            
            geom_line()+
            geom_point(size=2 )+
            facet_grid("variable~.")+
            
            #ylim(c(0,10)) +
            scale_y_continuous(breaks=c(0, 4,  8 )) + 
            scale_x_continuous(breaks=DF1$Date, labels=DF1$DateString) +  
            
             scale_fill_discrete(name="Experimental\nCondition",
                  
                         labels=c("Control", "Treatment 1", "Treatment 2","11") ) +
            
           # scale_color_manual(values=c("#2A9836", "#BC372F","#BCA409","red"), labels=c("重鼓","耐久","环境","高温"),  guide = guide_legend(title = "试验室"))  +

 
                       
            theme(axis.text.x = element_text(angle=90, vjust=0.1, size=6, ,  color="#BBBFC2"),
            
               axis.title.x=element_blank(),
                    axis.text.y = element_text(size=7,  color="#BBBFC2"),
                    axis.title.y = element_text(size=10,  color="#BBBFC2"),
                    panel.grid.major=element_line(color="#444444"),
                    panel.grid.minor=element_line(color="#444444"),
                    panel.background= element_rect(colour = '#1F1F1F', fill = '#2F2F2F'),#element_blank(), 
                    
                     strip.text.y = element_text(size=6, face="bold"),
                    #panel.border=element_rect(color= "#1F1F1F"),
                    legend.position = "none",
                    #legend.title = element_blank(), #element_text(size=7,  color="#BBBFC2"),
                    #legend.text = element_blank(), #element_text(size=7,  color="#BBBFC2"),
                    #legend.background = element_rect(colour = '#1F1F1F', fill = '#1F1F1F'),
                    plot.background=element_rect(fill = "#1F1F1F", color = "#1F1F1F")
            
            )

    ggsave("output/monthly_stats8.png",width=6, height=3)
    
}


DF <- read.table(text="Date DateString  R1  R2  R3  R4
1   2014-12-01   1  3  3  4
2   2014-12-02   1  9  9  8
3   2014-12-03   3  8  8  7
4   2014-12-04   3  8  8  10
5   2014-12-05   2  7  9  10
8   2014-12-08   1  3  4  3
9   2014-12-09   3  6  10  10
10   2014-12-10   1  8  9  10
11   2014-12-11   1  10  9  9
12   2014-12-12   1  6  10  7
15   2014-12-15   1  5  3  4
16   2014-12-16   2  6  10  9
17   2014-12-17   1  9  6  10
18   2014-12-18   1  6  6  10
19   2014-12-19   2  9  7  6
22   2014-12-22   1  4  3  4
23   2014-12-23   2  7  6  8
24   2014-12-24   3  6  7  8
25   2014-12-25   2  10  10  8
26   2014-12-26   2  9  8  6
29   2014-12-29   1  4  5  4
30   2014-12-30   1  9  6  10
31   2014-12-31   1  8  8  7", header=TRUE)

monthly_stats(DF)