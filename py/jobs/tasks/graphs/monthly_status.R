
# downtime graph

Sys.setlocale("LC_ALL", "C")

library(reshape2)
library(ggplot2)
library(scales)


downtime <- function(DF){
 

    #print(DF)



    DF1 <- melt(DF, id.var=c("ID","DateString"))

    print(DF1)



    plt <- ggplot(DF1, aes(x = ID, y = value, fill = variable )) +   #, fill = variable 
            
            geom_bar(stat = "identity", width=0.7,  alpha=0.7,   position="fill")   +
            
            #ggtitle(iconv("月停线时间","UTF-8","UTF-8")) + #iconv
            theme(plot.title = element_text(lineheight=3, face="bold", color="black", size=12) )+           
            
            scale_x_continuous(breaks=DF1$ID, labels= DF1$DateString)  +
            #scale_y_continuous(breaks=DF1$value) +
            ylab("时长百分比(%)") +
            scale_y_continuous(labels = percent) + 
            
            scale_fill_manual(values=c("green", "red", "blue"), 
                        guide = guide_legend(title = "图例"))  +
           #  scale_colour_manual(
            #breaks = levels(DF1$variable),
            #values=c("#FF4136", "#2ECC40", "#FFDC00"),
            #labels=c("重鼓","耐久","环境"),
            #    guide = guide_legend(title = "图例") ) +
            #scale_alpha_manual(values = c(0.2,0.2, 0.2))+
          #  scale_fill_manual(values=c("red", "blue", "green"))
            
                  #     scale_color_manual(
                    #        values=c("#F00000", "#39CCCC","#BCA409"), 
                      #      labels=c("重鼓","耐久","环境"),
                        #    guide = guide_legend(title = "试验室"))  +
                        
                        
            theme(axis.text.x = element_text(angle=90, vjust=0.1, size=7, color="#BBBFC2"),
                    axis.title.x=element_blank(),
                    axis.text.y = element_text(size=7,  color="#BBBFC2"),
                    axis.title.y = element_text(size=10,  color="#BBBFC2"),
                    panel.grid.major=element_line(color="#444444"),
                    panel.grid.minor=element_line(color="#444444"),
                    panel.background=element_blank(), 
                    #panel.border=element_rect(color= "#1F1F1F"),
                    legend.title = element_text(size=7,  color="#BBBFC2"),
                    #legend.text = element_text(size=7,  color="#BBBFC2"),
                    legend.background = element_rect(colour = '#1F1F1F', fill = '#1F1F1F'),
                    plot.background=element_rect(fill = "#1F1F1F", color = "#1F1F1F")
                    ) 
      
    ggsave("output/monthly_status2.png",width=6, height=2.5)

}

DF <- read.table("monthly_status2.csv", sep=",", header=TRUE)

downtime(DF)



