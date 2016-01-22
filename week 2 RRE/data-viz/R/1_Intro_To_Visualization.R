## ----anscombe-quartet, small.margins = TRUE, resize.width = "1\\textwidth", resize.height = "0.5\\textwidth", echo = FALSE----
data.path = "../data"
Anscombes.Quartet <- read.csv(file.path(data.path,"anscombe-quartet.csv"))
layout(matrix(1:4, nrow=2, byrow=TRUE))
par(las = 1, pch=19)
for(i in 1:4){
  curform <- as.formula(paste(paste0(c("y","x"),i),collapse = "~"))
  plot(curform, data = Anscombes.Quartet, main = sprintf("Dataset #%d",i), cex=1.5, axes=FALSE, ylim = c(0,15), xlim = c(2,20))
  axis(1, at=seq(2,20, by=3))
  axis(2, at=seq(0,15, by=5))
}

