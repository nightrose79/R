## ----plot-basic-plot, fig.height=2, fig.width=4, out.height=3, out.width=6, echo=-1----
par(mar=c(5,4,0.5,1)+0.1)
plot(x=cars$speed, y=cars$dist)

## ----plotargs, eval=1----------------------------------------------------
args(plot.default)

## ----plot-base-labels, echo=-1-------------------------------------------
par(mar=c(5,4,0.5,1)+0.1)
plot(x=cars$speed, y=cars$dist,
     xlab = "Initial Speed (mph)",
     ylab = "Stopping Distance (ft)"
     )

## ----plot-base-title, echo=-1--------------------------------------------
plot(x=cars$speed, y=cars$dist,
     xlab = "Initial Speed (mph)",
     ylab = "Stopping Distance (ft)"
     )
title("Initial Speed vs Stopping Distance")


## ----plot-base-fonts, echo=-1--------------------------------------------
plot(x=cars$speed, y=cars$dist,
     xlab = "Initial Speed (mph)",
     ylab = "Stopping Distance (ft)"
     )
title("Initial Speed vs Stopping Distance", font.main=4)



## ----plot-base-grids, echo=-1--------------------------------------------
plot(x=cars$speed, y=cars$dist,
     xlab = "Initial Speed (mph)",
     ylab = "Stopping Distance (ft)"
     )
title("Initial Speed vs Stopping Distance", font.main=4)
grid(5, 7, lwd = 1)


## ----plot-base-transform-------------------------------------------------
cars <- transform(cars, acceleration = -(speed^2)/(2*dist))
head(cars)

## ----plot-scatterplot-1, cache=TRUE, echo=-1-----------------------------
par(mar=c(5,4,0.5,1)+0.1)
plot(cars$speed, cars$dist, 
     xlab = "Car Speed (mph)",
     ylab = "Stopping Distance (ft)", 
     col = "red", cex = abs(cars$acceleration)
     )

## ----plot-scatterplot-2, tidy = TRUE-------------------------------------
par(mar=c(5,4,0.5,1)+0.1)
plot(cars$speed, cars$dist, 
     xlab = "Car Speed (mph)",
     ylab = "Stopping Distance (ft)", 
     col = "red", cex = abs(cars$acceleration)
     )
text(x = cars$speed, 
     y = cars$dist, 
     labels = row.names(cars),  
     cex = 1.5*abs(cars$acceleration) / max(abs(cars$acceleration)) 
     )

## ----plot-pairwise,echo=-1-----------------------------------------------
par(mar=c(5,4,0,0)+0.1)
plot(cars)

## ----grDeviceshelp, eval = FALSE-----------------------------------------
#  library(help = grDevices)

## ----dev.cur-------------------------------------------------------------
dev.cur() ## tell which device is current
dev.list() ## list all active devices

## ----devcopy2pdf---------------------------------------------------------
outputPath <- "../output"
if(!file.exists(outputPath)) dir.create(outputPath)
dev.copy2pdf(file = file.path(outputPath,"copiedscatter.pdf"))

## ----devcopyhelp, eval = FALSE-------------------------------------------
#  help(dev.copy)

## ----deviceshelp, eval=FALSE---------------------------------------------
#  help(Devices)

## ----pdf-example, tidy=FALSE---------------------------------------------
pdf(file.path(outputPath,"Example.pdf"))
par(mar=c(5,4,0.5,1)+0.1)
plot(cars$speed, cars$dist, 
     xlab = "Car Speed (mph)",
     ylab = "Stopping Distance (ft)", 
     col = "red", cex = abs(cars$acceleration)
     )
text(x = cars$speed, 
     y = cars$dist, 
     labels = row.names(cars),  
     cex = 1.5*abs(cars$acceleration) / max(abs(cars$acceleration)) 
     )
dev.off() ## have to turn the device off.

## ----plot-histogram, fig.show='hold', echo=-1, fig.height=2.5------------
par( mfrow = c( 1, 2 ), mar=c(5,4,1,0)+0.1)
hist(cars$acceleration, xlab = "Acceleration", main=NA)
hist(cars$acceleration, xlab = "Acceleration", density = 20, 
     border = "darkred" , col = "red", breaks = 10, main =NA)

## ----plot-density, fig.show='hold', echo=-1------------------------------
par( mfrow = c( 1, 2 ) )
plot(density(cars$acceleration))
plot(density(cars$acceleration), lwd = 4, 
     col = "darkred", main="")

## ----plot-pie, echo=-1---------------------------------------------------
pie(c(4, 5, 7, 12, 14, 16))

## ----plot-bwplot, echo=-1------------------------------------------------
par(mar=c(5,4,0.5,1)+0.1)
boxplot(cars$acceleration, las=1, ylab="Acceleration")

## ----plot-qqnorm---------------------------------------------------------
qqnorm(iris$Sepal.Length, main="Iris sepal length")
qqline(iris$Sepal.Length, col="red")

## ----plot-mfrow-qqnorm-1, fig.show='hold', echo=1:3, size='tiny'---------
par(mfrow = c(1, 2), mar=c(5,6,1.5,0)+0.1) 
qqnorm(iris$Sepal.Length, ylab="Sample Quantiles\nIris sepal length", cex.lab=0.8, main=NA)
qqnorm(iris$Sepal.Width, ylab="Sample Quantiles\nIris sepal width",cex.lab=0.8, main=NA)
par(mfrow=c(1, 1))

## ----plot-mfrow-qqnorm-2, fig.show='hold', size='tiny'-------------------
par(mfrow = c(1, 2), mar=c(5,6,1.5,0)+0.1) 
with(iris, qqnorm(Sepal.Length, ylab="Sample Quantiles\nSpecies: All", main=NA, cex.lab=0.8))
with(iris, qqline(Sepal.Length, col='red'))
with(iris[1:50, ], qqnorm(Sepal.Length, ylab="Sample Quantiles\nSpecies: Setosa", main=NA,cex.lab=0.8))
with(iris[1:50, ], qqline(Sepal.Length, col='red'))

