

Sys.setlocale("LC_ALL", "C")


dat <- data.frame(
    y = 1:1,
    text = c("This is text")
)

library(ggplot2)
library("scales")
library("grid")

textbox <- function (DF){

gg <- ggplot(dat, aes(x=1, y=1)) + 
       scale_y_continuous(limits=c(0.5, 3.5), breaks=NULL) +
       scale_x_continuous(breaks=NULL)

gg <- gg + geom_text(aes(x=1,y=2, label=DF$a), size=5, colour="white", fontface="bold",)

#gg <- gg + geom_text(aes(label=text), family="Times", fontface="italic", lineheight=.8) +
 #   annotate(geom="text", x=1, y=1.5, label="Annotation text", colour="red",
  #           size=7, family="Courier", fontface="bold", angle=0)
             
 gg <- gg   + theme(
 axis.title.x=element_blank(),
 axis.ticks.x = element_blank(),
 axis.text.x = element_blank(),
 axis.title.y=element_blank(),
 axis.ticks.y = element_blank(),
 axis.text.y = element_blank(),
 panel.background=element_rect(fill = "#1F1F1F", color = "#1F1F1F"),
 plot.background=element_rect(fill = "#1F1F1F", color = "#1F1F1F"),
plot.margin=unit(c(0,0,-2,-1),"mm")  #top, right, bottom, left
  )
 
 
 gg <- gg + xlab( NULL) +  ylab( NULL)
             
 ggsave(file="b001.png", width=1.1, height=0.28)
 
 
}

DF <- read.table("b001.csv", sep=",", header=TRUE)

textbox(DF)
