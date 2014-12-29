
Sys.setlocale("LC_ALL", "C")

require(ggplot2)
library(scales) 
set.seed(3)

df = data.frame(
    VisitWeek = rep(as.Date(seq(Sys.time(),
	length.out = 5, by = "1 day")), 5),
	ThingAge = rep(1:5, each = 5),
	MyMetric = sample(100, 25))

print(df)

ggplot(df, aes(x = VisitWeek, y = MyMetric)) +
        geom_area(aes(fill = factor(ThingAge)),  position = "fill") +
        #scale_x_continuous(breaks=df$VisitWeek, labels= df$VisitWeek)  +
         xlab("日期") +
          ylab("时长百分比(%)") +
          scale_y_continuous(labels = percent) + 
        ggtitle("一周状态") +
        scale_x_date(breaks = unique(df$VisitWeek)) +
        scale_fill_manual(values=c("#FF4136", "#2ECC40", "#FFDC00", "#85144B", "#F012BE"), guide = guide_legend(title = "分类"))  +
        theme(axis.text.x = element_text(angle=90, vjust=0.1, size=7)) 
       
    
ggsave("area1.png", width=6, height=4)