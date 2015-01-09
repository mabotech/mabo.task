
#library(showtext)
library(ggplot2)
#library(sysfonts)

library(reshape2)

Sys.setlocale("LC_ALL", "C")

all_yearly <- function(DF){

    #Sys.getlocale()
    #Sys.setlocale("LC_ALL","Chinese")
    #l10n_info()   
    #sessionInfo() 
    #par(family='wqy')
    #getOption("encoding")

    #Encoding("中文") 

    print(DF)
    
    DF1 <- melt(DF, id.var=c("month","monthText"))
    #levels()
    print(DF1)

    plt <- ggplot(data = DF, mapping=aes(x=month,y=b)) +
    
        geom_point(color="#FF851B",shape=0) + 
        geom_line(colour="#FF851B") + 
        
        geom_point(aes(x=month,y=d), color="#0074D9",shape=4) + 
        geom_line(aes(x=month,y=d), colour="#0074D9") + 
        
        geom_point(aes(x=month,y=h), color="#2ECC40",shape=8) + 
        geom_line(aes(x=month,y=h), colour="#2ECC40") + 
        
          geom_point(aes(x=month,y=n), color="#FFDC00",shape=10) + 
         geom_line(aes(x=month,y=n), colour="#FFDC00") +
        
        #geom_bar(stat="identity") +
        xlab("月份") +
        #intToUtf8(c(20013, 25990))
        scale_x_continuous(breaks=c(1:12), labels=DF$monthText) + 
        #c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) +
        #scale_x_continuous("月份\n2014") +
        ylab("利用率 (%)") +
        # ylab(intToUtf8(c(20013, 25991))) +
        ylim(c(0,150)) +
        

           theme(axis.text.x = element_text(vjust=0.1, size=10,   color="#BBBFC2"), #angle=90, 
            
               axis.title.x=element_blank(),
                    axis.text.y = element_text(size=7,  color="#BBBFC2"),
                    axis.title.y = element_text(size=10,  color="#BBBFC2"),
                    
                                panel.grid.major=element_line(color="#444444"),
                    panel.grid.minor=element_blank(), #element_line(color="#444444"),
                    panel.background=element_blank(), 
                     strip.text.y = element_text(size=6, face="bold"),
                    #panel.border=element_rect(color= "#1F1F1F"),
                    legend.title = element_text(size=7,  color="#BBBFC2"),
                    legend.text = element_text(size=7,  color="#BBBFC2"),
                    legend.background = element_rect(colour = '#1F1F1F', fill = '#1F1F1F'),
                    plot.background=element_rect(fill = "#1F1F1F", color = "#1F1F1F")
            
            )
            
       # ggtitle(iconv("2014年设备利用情况","UTF-8","UTF-8")); #iconv
    #plt = plt +  guides(fill = guide_legend(title = "LEFT", title.position = "left"))
    ggsave(file="output/yearly_201412_1.png", width=7, height=3)

}

all_yearly_data <- data.frame(month=c(1:12),  b =130 - abs(25* sin(c(1:12))),  
                                             d =50 + abs(15* sin(c(1:12))),  
                                              h =3*c(17:28) + abs(8* cos(c(1:12))), 
                                              n =60 + abs(24* sin(c(4:15))), 
                                            #c1=c(rep(c("Odd","Even"),times=6)),  
                                            monthText=c('Jan\n一月', 'Feb', 'Mar', 'Apr', 'May', 'Jun\n六月', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec\n十二月'))

all_yearly(all_yearly_data)
