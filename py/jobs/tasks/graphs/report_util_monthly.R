
#library(showtext)
library(ggplot2)
#library(sysfonts)

Sys.setlocale("LC_ALL", "C")

all_monthly <- function(DF){

    #Sys.getlocale()
    #Sys.setlocale("LC_ALL","Chinese")
    #l10n_info()   
    #sessionInfo() 
    #par(family='wqy')
    #getOption("encoding")

    #Encoding("中文") 

    print(DF)

    plt <- ggplot(data = DF, mapping=aes(x=id,y=util)) +
        #geom_point(color="#FF851B",shape=0) + 
        #geom_line(colour="red") + 
      #  geom_bar(stat="identity", fill="white", color="blue", position="dodge") +
        # blue
        geom_bar( mapping=aes(x=id,y=plan), stat="identity", width=.7, fill="white", alpha=I(.9), color="#0074D9") +
        # green
        geom_bar( mapping=aes(x=id,y=util), stat="identity", width=.7, fill="green", alpha=I(.3), color="#2ECC40") +
        xlab("设备") +
        #intToUtf8(c(20013, 25990))
        scale_x_continuous(breaks=c(1:10), labels=DF$e) + 
        #c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) +
        #scale_x_continuous("月份\n2014") +
        ylab("利用率(%)") +
        # ylab(intToUtf8(c(20013, 25991))) +
        #ylim(c(80,100)) +
        ggtitle(iconv("2015年4月设备利用率","UTF-8","UTF-8")) + #iconv
        
        theme()
        
    #print(summary(diamonds))
    #ggplot(diamonds, aes(clarity, fill=cut)) + geom_bar(position="dodge")
    ggsave(file="output/report_util.png", width=6, height=3)

}

all_monthly_data1 <- data.frame(a=c(1:7),  b =100-4*c(1:7), d=5*c(11:17),
                                                e=c("里程\n耐久1#","里程\n耐久2#","里程\n耐久3#","环境1","环境2","环境3","结构\n耐久1"))

all_monthly_data <- read.table("monthlyU.csv", sep=",", quote="\"" , header=TRUE)

all_monthly_data$e <- c("高低温\n环境舱",
"高低温\n转鼓",
"排放\n分析仪",
"常温间\n转鼓",
"耐久\n转鼓#1",
"耐久\n转鼓#2",
"耐久\n转鼓#3",
"重型\n转鼓",
"四驱高温\n环境舱",
"四驱\n高温转鼓")
 
print(all_monthly_data)

all_monthly(all_monthly_data)
