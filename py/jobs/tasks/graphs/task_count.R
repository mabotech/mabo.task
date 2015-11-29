
Sys.setlocale("LC_ALL", "C")

library(reshape2)
library(ggplot2)

monthly_stats <- function(DF1) {

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

    ggsave("output/task_count.png",width=6, height=3)
    
}


DF <- read.table("task_count.csv", sep=",", header=TRUE)
print(DF)
monthly_stats(DF)