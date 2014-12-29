
#library(showtext)
library(ggplot2)
#library(sysfonts)

Sys.setlocale("LC_ALL", "C")

monthly_stat_graph <- function(d){

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
        #geom_bar(stat="identity") +
         xlab("月份") +
        #intToUtf8(c(20013, 25990))
        scale_x_continuous(breaks=c(1:12), labels=d$e) + 
        #c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) +
        #scale_x_continuous("月份\n2014") +
        ylab("利用率 (%)") +
        # ylab(intToUtf8(c(20013, 25991))) +
        ylim(c(80,100)) +
        ggtitle(iconv("2014年设备利用情况","UTF-8","UTF-8")); #iconv

    ggsave(file="plot04.png", width=6, height=3)

}

monthly_data <- data.frame(a=c(1:12),  b =100 - abs(15* sin(c(1:12))),  c1=c(rep(c("Odd","Even"),times=6)),  e=c('一月\nJan', 'Feb', 'Mar', 'Apr', 'May', '六月\nJun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))

monthly_stat_graph(monthly_data)
