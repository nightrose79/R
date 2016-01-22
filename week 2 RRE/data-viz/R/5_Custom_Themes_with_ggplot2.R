## ----polishing-theme-intro-recall, eval=FALSE----------------------------
#  # Recall:
#  qplot(x = departure.time / 100, data = airline,
#        geom = "density",
#        color = carrier, xlab = "Departure Time")
#  
#  # Equivalently:
#  ggplot(airline, aes(departure.time / 100, color=carrier)) +
#    geom_density(na.rm=TRUE) +
#    xlab("Departure Time") +
#    ylab("density")
#  

## ----polishing-load-data-------------------------------------------------
dataPath <- "../data"
rdataFile <- file.path(dataPath, "airline.RData")
load(rdataFile)

library(ggplot2)
library(gridExtra)
library(ggthemes)

theme <- theme_gray()
theme <- theme_update(plot.margin = unit(c(0.2, 0, 0, 0), "lines"))
theme <- theme_update(plot.background = element_blank())

## ----polishing-theme-intro-themes----------------------------------------

p1 <- ggplot(airline, aes(departure.time / 100, color=carrier)) + 
  xlab("Departure Time") + 
  ylab("Density") + 
  geom_density(na.rm=TRUE)
grid.arrange(p1, p1 + theme_tufte(), ncol=2) # gridExtra

## ----mytheme, tidy = FALSE-----------------------------------------------
mytheme <- theme(legend.title = element_blank(), 
                 legend.key = element_rect(fill = "white"),
                 axis.title.x = element_text(vjust=0, size=rel(1.5), 
                                             colour="#C34922", 
                                             face="bold"),
                 axis.title.y = element_blank(),
                 plot.title =   element_text(hjust=0, size=rel(2), 
                                             colour="#C34922", 
                                             face="bold"),
                 panel.grid.major = element_line(colour="#6699FF", 
                                                 linetype = 'dashed'),
                 panel.grid.minor = element_blank(), 
                 panel.background = element_rect(fill = 'white'),
                 axis.line = element_blank())

## ----polishing-theme-custom-args-density-src, eval=FALSE, echo = TRUE----
#  p2 <- p1 + mytheme
#  grid.arrange(p1, p2, ncol=2)

## ----polishing-theme-custom-args-density-img, ref.label = "polishing-theme-custom-args-density-src", eval=TRUE, echo=FALSE----
p2 <- p1 + mytheme
grid.arrange(p1, p2, ncol=2)

## ----polishing-theme-custom-args-box-src, eval=FALSE, echo=TRUE----------
#  p1 <- ggplot(airline, aes(x = carrier, y = air.time, fill = carrier)) +
#    xlab("Carrier") + ylab("Air Time") +
#    ggtitle("Air Time") + geom_boxplot()
#  p2 <- p1 + mytheme + theme(axis.text.x = element_text(angle = 45, hjust = 1))
#  grid.arrange(p1, p2, ncol=2)

## ----polishing-theme-custom-args-box-img, ref.label = "polishing-theme-custom-args-box-src", eval=TRUE, echo = FALSE----
p1 <- ggplot(airline, aes(x = carrier, y = air.time, fill = carrier)) + 
  xlab("Carrier") + ylab("Air Time") + 
  ggtitle("Air Time") + geom_boxplot()
p2 <- p1 + mytheme + theme(axis.text.x = element_text(angle = 45, hjust = 1))
grid.arrange(p1, p2, ncol=2)

## ----theme_tufte_src-----------------------------------------------------
theme_tufte

## ----theme_bw_src--------------------------------------------------------
theme_bw

## ----theme_grey_src------------------------------------------------------
theme_grey

## ----, eval=FALSE--------------------------------------------------------
#  # {extrafont}
#  # font_import()   #   you'll need to run this the first time
#                    #   you load extrafont (library(extrafont))
#                    #   it will take some time, but does not need to be repeated
#  library(extrafont)
#  fonts()
#  fonttable()

## ----theme_revo----------------------------------------------------------
theme_revo <- function(base_size = 14, base_family="Helvetica"){ 
  theme_grey(base_size=base_size, base_family=base_family) + 
    theme(
      legend.title = element_blank(), 
      legend.key =   element_blank(), 
      axis.title.x = element_text(vjust=0, size=rel(1.5), 
                                  colour="#C34922", face="bold"), 
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.y = element_blank(), 
      plot.title =   element_text(rel(2),hjust=0,vjust=1, family=base_family,
                                  colour="#C34922", face="bold"),
      panel.grid.major = element_line(colour = "#6699FF",
                                      linetype = 'dashed'), 
      panel.grid.minor = element_blank(), 
      panel.background = element_rect(fill = 'white'),
      axis.line = element_blank())
  }

## ----polishing-theme-revo------------------------------------------------
p3 <- p1 + labs(title="Density") + theme_revo() 
p4 <- p1 + labs(title="Density") + theme_revo() + scale_colour_tableau("colorblind10")
grid.arrange(p3, p4, ncol=2)

## ----library-png---------------------------------------------------------
library(png)

## ----polishing-logo-pattern-1-src, eval=FALSE, echo=TRUE-----------------
#  m <- readPNG(file.path(dataPath,"RA_ICON.png"), FALSE)
#  w <- matrix(rgb(m[, , 1], m[, , 2], m[, , 3], m[, , 4] * 0.1), # adjust alpha (transparency)
#              nrow=dim(m)[1])
#  (p2 <- p1 + labs(title="Density") +
#    theme_revo() +
#    scale_colour_tableau("colorblind10") +
#    annotation_custom(xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf,
#                      rpatternGrob(motif=w, motif.width = unit(3, "cm"))))

## ----polishing-logo-span-1-src, eval=FALSE, echo = TRUE------------------
#  m <- readPNG(file.path(dataPath, "RA_ICON.png"), FALSE)
#  w <- matrix(rgb(m[, , 1], m[, , 2], m[, , 3], m[, , 4] * 0.1), nrow=dim(m)[1])
#              # adjust alpha (transparency)
#  (p2 <- p1 + labs(title="Density")+
#    theme_revo() +
#    scale_colour_tableau("colorblind10") +
#    annotation_custom(xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf,
#                      rasterGrob(w)))

## ----polishing-logo-span-1-img, ref.label = "polishing-logo-span-1-src", eval=TRUE, echo = FALSE----
m <- readPNG(file.path(dataPath, "RA_ICON.png"), FALSE)
w <- matrix(rgb(m[, , 1], m[, , 2], m[, , 3], m[, , 4] * 0.1), nrow=dim(m)[1])
            # adjust alpha (transparency)
(p2 <- p1 + labs(title="Density")+ 
  theme_revo() + 
  scale_colour_tableau("colorblind10") +
  annotation_custom(xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf, 
                    rasterGrob(w)))

