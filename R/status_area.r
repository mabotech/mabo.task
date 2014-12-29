
Sys.setlocale("LC_ALL", "C")

require(ggplot2)
library(scales) 

area <- function(){

    set.seed(3)

    df = data.frame(
        VisitWeek = rep(as.Date(seq(Sys.time(),
        length.out = 7, by = "1 day")), 4),
        ThingAge = rep(1:4, each = 7),
        MyMetric = c(sample(80,7)/10 ,sample(8,7)/10 ,sample(8,7)/10, sample(8,7)/10) )

    print(df)

    ggplot(df, aes(x = VisitWeek, y = MyMetric)) +
            geom_area(aes(fill = factor(ThingAge)), alpha=0.7,  position = "fill") +
            #scale_x_continuous(breaks=df$VisitWeek, labels= df$VisitWeek)  +
            xlab("日期") +
            scale_x_date(breaks = unique(df$VisitWeek)) +
            
            ylab("时长百分比(%)") +
            scale_y_continuous(labels = percent) + 
            
            ggtitle("重点试验设备一周状态汇总") +
            theme(plot.title = element_text(lineheight=3, face="bold", color="black", size=12) )+
            
            scale_fill_manual(values=c("#2ECC40", "#FFDC00", "#FF4136", "#85144B"), 
                                        labels=c("试验中","闲置","故障","维护"),
                                        guide = guide_legend(title = "图例"))  +
            theme(axis.text.x = element_text(angle=15, hjust=1, vjust=1, size=7),
                      axis.title=element_text(size=10,face="bold") )

    ggsave("output/status_sum_area1.png", width=6, height=3.5)

}

area()