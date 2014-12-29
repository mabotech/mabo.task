
#library(showtext)
library(ggplot2)
#library(sysfonts)

Sys.setlocale("LC_ALL", "C")

all_yearly <- function(d){

    #Sys.getlocale()
    #Sys.setlocale("LC_ALL","Chinese")
    #l10n_info()   
    #sessionInfo() 
    #par(family='wqy')
    #getOption("encoding")

    #Encoding("中文") 

    print(d)

    plt <- ggplot(data = d, mapping=aes(x=a,y=b)) +
    
        geom_point(color="#FF851B",shape=0) + 
        geom_line(colour="red") + 
        
        geom_point(aes(x=a,y=d), color="#0074D9",shape=4) + 
        geom_line(aes(x=a,y=d), colour="blue") + 
        
        geom_point(aes(x=a,y=h), color="#2ECC40",shape=8) + 
        geom_line(aes(x=a,y=h), colour="green") + 
        
        #geom_bar(stat="identity") +
        xlab("月份") +
        #intToUtf8(c(20013, 25990))
        scale_x_continuous(breaks=c(1:12), labels=d$e) + 
        #c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) +
        #scale_x_continuous("月份\n2014") +
        ylab("利用率 (%)") +
        # ylab(intToUtf8(c(20013, 25991))) +
        ylim(c(0,100)) +
        ggtitle(iconv("2014年设备利用情况","UTF-8","UTF-8")); #iconv
    #plt = plt +  guides(fill = guide_legend(title = "LEFT", title.position = "left"))
    ggsave(file="yearly_201412.png", width=7, height=3)

}

all_yearly_data <- data.frame(a=c(1:12),  b =100 - abs(15* sin(c(1:12))),  
                                             d =50 + abs(15* sin(c(1:12))),  
                                              h =3*c(17:28) + abs(8* cos(c(1:12))), 
                                            c1=c(rep(c("Odd","Even"),times=6)),  
                                            e=c('Jan\n一月', 'Feb', 'Mar', 'Apr', 'May', 'Jun\n六月', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec\n十二月'))

all_yearly(all_yearly_data)
