
Sys.setlocale("LC_ALL", "C")

DF <- read.table(text=iconv("ID    Equipment    Downtime     Running     Idle
1    设备1    1.7    6.15    1
2    设备2    1.0    6.6    0.5
3    设备3    0.9    7.6    0
4    设备4    1.8    6.6    1.5
5    设备5    1.5    4.9    2
6    设备6    0.45    5.55    1
7    设备7    1.25    4.55    2","UTF-8","UTF-8"), header=TRUE)

#print(DF)

library(reshape2)
DF1 <- melt(DF, id.var=c("ID","Equipment"))

#print(DF1)

library(ggplot2)

library(scales)

ggplot(DF1, aes(x = ID, y = value, fill = variable )) +   #, fill = variable 
        ylab("时长百分比(%)") +
        ggtitle(iconv("月停线时间","UTF-8","UTF-8")) + #iconv
        geom_bar(stat = "identity", width=0.7,  alpha=0.7,   position="fill")   +
        scale_x_continuous(breaks=DF1$ID, labels= DF1$Equipment)  +
        #scale_y_continuous(breaks=DF1$value) +
        scale_y_continuous(labels = percent) + 
         scale_fill_manual(values=c("#FF4136", "#2ECC40", "#FFDC00"),  guide = guide_legend(title = "分类"))  +
        theme(axis.text.x = element_text(angle=90, vjust=0.1, size=7)) 
  
  ggsave("test03.png",width=7, height=5)