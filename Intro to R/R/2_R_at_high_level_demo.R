## ----intro-getwd, eval=FALSE---------------------------------------------
  getwd()
  setwd("E:/My Documents/Training/Revolution R/Intro to R/data")

## ----load-data-----------------------------------------------------------
data.path <- "../data"
datafile <- file.path(data.path, "performance.csv")
performance <- read.csv(datafile, stringsAsFactors=FALSE)

## ----load-data-str, output.max=15----------------------------------------
str(performance) ## look at the data 

## ----reformat-data-------------------------------------------------------
## Date Not character!
performance$Click.Date <- as.Date(performance$Click.Date, format='%m/%d/%y')

## Numeric, not chararacter!
numeric.cols <- c('Engine.CTR', 'LP.CTR')
removePercent <- function(x) as.numeric(sub('%', '', x))/100
performance[numeric.cols] <- lapply(performance[numeric.cols], removePercent)

## Numeric, not character!
dollar.cols <- c('Cost', 'Rev', 'Margin')
removeDollar <- function(x) as.numeric(gsub('[\\$ )]', '', sub("\\(", "-", x)))

performance[dollar.cols] <- lapply(performance[dollar.cols], removeDollar)
## write.csv(performance, file='../data/performance.refmt.csv',row.names=FALSE)

## ----load-data-str-2, output.max=15--------------------------------------
str(performance) ## look at the data 

## ----intro-plot-1--------------------------------------------------------
numeric.cols <- which(sapply(performance, is.numeric))
plot(performance[numeric.cols[1:3]])

## ----intro-plot-2--------------------------------------------------------
plot(performance[dollar.cols])

## ----intro-plot-3--------------------------------------------------------
perf <- performance[performance$Cost < 100,]
plot(perf[dollar.cols])

## ----intro-plot-cluster--------------------------------------------------

perf$Origin.Code <- factor(perf$Origin.Code)
originCol <- c("blue", "red", "green")[perf$Origin.Code]
plot(perf[, 15:ncol(perf)], col=originCol, pch=19)

## ----intro-install-packages, eval=FALSE----------------------------------
#  install.packages('ggplot2')

## ----load-ggplot, tidy=FALSE---------------------------------------------
library(ggplot2)
ggplot(perf, aes(x=Rev, y=ROI, colour=Origin.Code)) +
  geom_point(na.rm=TRUE, size=4) +
  theme(legend.justification=c(1,1), legend.position=c(1,1))

