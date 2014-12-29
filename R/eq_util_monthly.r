
#library(showtext)
library(ggplot2)
#library(sysfonts)

Sys.setlocale("LC_ALL", "C")

all_monthly <- function(d){

    #Sys.getlocale()
    #Sys.setlocale("LC_ALL","Chinese")
    #l10n_info()   
    #sessionInfo() 
    #par(family='wqy')
    #getOption("encoding")

    #Encoding("中文") 

    print(d)

    plt <- ggplot(data = d, mapping=aes(x=a,y=d)) +
        #geom_point(color="#FF851B",shape=0) + 
        #geom_line(colour="red") + 
      #  geom_bar(stat="identity", fill="white", color="blue", position="dodge") +
        # blue
        geom_bar( mapping=aes(x=a,y=b), stat="identity", width=.7, fill="white", alpha=I(.9), color="#0074D9") +
        # green
        geom_bar( mapping=aes(x=a,y=d), stat="identity", width=.7, fill="green", alpha=I(.3), color="#2ECC40") +
        xlab("试验室") +
        #intToUtf8(c(20013, 25990))
        scale_x_continuous(breaks=c(1:7), labels=d$e) + 
        #c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) +
        #scale_x_continuous("月份\n2014") +
        ylab("利用率(%)") +
        # ylab(intToUtf8(c(20013, 25991))) +
        #ylim(c(80,100)) +
        ggtitle(iconv("2014年12月设备利用率","UTF-8","UTF-8")) + #iconv
        
        theme()
        
    #print(summary(diamonds))
    #ggplot(diamonds, aes(clarity, fill=cut)) + geom_bar(position="dodge")
    ggsave(file="monthly_util_201412.png", width=6, height=3)

}

all_monthly_data <- data.frame(a=c(1:7),  b =100-4*c(1:7), d=5*c(11:17),
                                                e=c("里程\n耐久1#","里程\n耐久2#","里程\n耐久3#","环境1","环境2","环境3","结构\n耐久1"))

all_monthly(all_monthly_data)
