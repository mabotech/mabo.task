# 
# MIT License
# 
# Bob Rudis (@hrbrmstr) bob@rudis.net | http://rud.is/b | http://amzn.to/sudabook
#
Sys.setlocale("LC_ALL", "C")

library(ggplot2)

#
# make a bullet graph (retuns a ggplot2 object)
#
# expects a data frame with columns: measure|high|mean|low|target|value 
#
# which equates to:
#   measure: label of what's being measured
#      high: the high value for the measure
#      mean: the mean value for the measure
#       low: the low value for the measure
#    target: the target value for the measure
#     value: the actual value of the measure
#
# NOTE: you *can* put multiple rows in the data frame, but they should all be at the same
#       scale. That either means normalizing the values or representing them as pecentages.
#       you are better off making multiple, invididual bullet graphs if the scales are
#       very different.
# 
# Adapted from: http://bit.ly/1fs6ooC
#

bullet.graph <- function(bg.data){
  
  # compute max and half for the ticks and labels
  max.bg <- max(bg.data$high)
  mid.bg <- max.bg / 2

  gg <- ggplot(bg.data) 
  gg <- gg + geom_bar(aes(measure, high),  fill=c("red","blue","goldenrod2","blue"), stat="identity", width=0.5, alpha=0.3) 
  gg <- gg + geom_bar(aes(measure, mean),  fill="goldenrod3", stat="identity", width=0.5, alpha=0.3) 
  gg <- gg + geom_bar(aes(measure, low),   fill="#FFFFFF", stat="identity", width=0.5, alpha=0.2) 
  gg <- gg + geom_bar(aes(measure, value), fill="black",  stat="identity", width=0.2) 
  gg <- gg + geom_text(aes(y=target, x=measure, label = "1"))
  gg <- gg + geom_errorbar(aes(y=target, x=measure, ymin=target, ymax=target), color="red", width=0.45) 
  gg <- gg + geom_point(aes(measure, target), colour="red", size=2.5) 
  gg <- gg + scale_y_continuous(breaks=seq(0,100,10))
  gg <- gg + coord_flip() 
  #+ ggtitle("子弹图")
  gg <- gg + theme(axis.text.x=element_text(size=6, color="#BBBFC2"),
                   axis.title.x=element_blank(),
                   axis.line.y=element_blank(), 
                   axis.text.y=element_text(hjust=1, color="#BBBFC2"), 
                   axis.ticks.y=element_blank(),
                   axis.title.y=element_blank(),
                   legend.position="none",
                   panel.background=element_blank(), 
                   panel.border=element_blank(),
                   panel.grid.major=element_blank(),
                   panel.grid.minor=element_blank(),
                   plot.background=element_rect(fill = "#1F1F1F", color = "#1F1F1F"))

  return(gg)

}

# test it out!

# 5/1 seems to be a good ratio for individual bullet graphs but you
# can change it up to fit your dashboard needs

incidents.pct <- data.frame(
  measure=c("设备可用性 (%)", "设备利用效率 (%)", "设备完好率 (%)", "任务完成率 (%)"),
  high=c(100,100,100,100),
  mean=c(45,40,50,30),
  low=c(25,20,10,5), 
  target=c(55,40,45,35),
  value=c(50,45,60,25)
)

incidents.pct.bg <- bullet.graph(incidents.pct)
ggsave("output/bullet01.png", incidents.pct.bg, width=6, height=2.5)