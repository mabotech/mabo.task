
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

    #print(DF)
    
    DF1 <- melt(DF, id.var= "month" )
    #levels()
    print(DF1)

    plt <- ggplot(data = DF1,  aes(x=month,y = value  , color=variable)) +
    
        geom_point(aes(shape = factor(variable))) + 
        geom_line( ) + 
        

        
        #geom_bar(stat="identity") +
        xlab("月份") +
        #intToUtf8(c(20013, 25990))
        scale_x_continuous(breaks=c(1:12), #labels=DF1$monthText) + 
        labels = c('Jan\n一月', 'Feb', 'Mar', 'Apr', 'May', 'Jun\n六月', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec\n十二月')) +
        #c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) +
        #scale_x_continuous("月份\n2014") +
        ylab("利用率 (%)") +
        # ylab(intToUtf8(c(20013, 25991))) +
        ylim(c(0,150)) +
        
            scale_color_manual(values=c("#2A9836", "#BC372F","#BCA409","red"), labels=c("重鼓","耐久","环境","高温"),
                        guide = guide_legend(title = "试验室"))  +
                        
                        
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
    ggsave(file="output/yearly_201412_4.png", width=7, height=3)

}

all_yearly_data <- data.frame(month=c(1:12),  r1 =130 - abs(25* sin(c(1:12))),  
                                             r2 =50 + abs(15* sin(c(1:12))),  
                                              r3 =3*c(17:28) + abs(8* cos(c(1:12))), 
                                              r4 =60 + abs(24* sin(c(4:15))) )
                                            #c1=c(rep(c("Odd","Even"),times=6)),  
                                            #monthText=c('Jan\n一月', 'Feb', 'Mar', 'Apr', 'May', 'Jun\n六月', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec\n十二月'))

all_yearly(all_yearly_data)
