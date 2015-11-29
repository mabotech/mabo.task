
Sys.setlocale("LC_ALL", "C")

#library(reshape2)
library(ggplot2)

monthly_stats <- function(DF) {

    #print(DF)
    #DF1 <- melt(DF, id.var="Date")

    #print(DF1)
    plt <- ggplot(DF, aes(x = Date, y = F2)) + 
            ylab("效率(%)") +
            #ggtitle(iconv("月运行情况","UTF-8","UTF-8")) + #iconv
            geom_bar(stat = "identity", alpha=0.9, fill="#2ECC40", position="dodge") +
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

    ggsave("output/monthly_stats002.png",width=6, height=3)
    
}


DF <- read.table("monthly2.csv", sep=",", header=TRUE)

monthly_stats(DF)