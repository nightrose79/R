## ----plot-ggplot-spec, eval=FALSE, tidy=FALSE----------------------------
#  ggplot(data, mapping) +
#    layer(
#      stat = "",
#      geom = "",
#      position = "",
#      geom_parms = list(),
#      stat_params = list(),
#    )

## ----plot-qplot-mtcars-bar-----------------------------------------------
library("ggplot2")
theme_set(theme_bw())
qplot(mpg, data = mtcars)

## ----plot-qplot-mtcars-scatter-------------------------------------------
qplot(x = hp, y = mpg, data = mtcars)

## ----plot-qplot-mtcars-color---------------------------------------------
qplot(x = hp, y = mpg, data = mtcars, color = cyl, size = mpg)

## ----plot-qplot-mtcars-size----------------------------------------------
qplot(x = hp, y = mpg, data = mtcars, color = cyl, size = mpg, facets = .~ gear)

## ----plot-qplot-mtcars-facet---------------------------------------------
qplot(x = hp, y = mpg, data = mtcars, color = cyl, facets = .~ gear, 
      label = rownames(mtcars), geom=c("text","point"), 
      size = .1,  hjust=-0.25)

## ----plot-ggplot-basic---------------------------------------------------
p <- ggplot(data = mtcars, aes(hp, mpg, label = rownames(mtcars))) +
  geom_point(aes(colour = cyl)) 


## ----plot-ggplot-print---------------------------------------------------
print(p)

## ----plot-ggplot-labels--------------------------------------------------
p <- p + facet_grid(.~gear) +
  geom_text(aes(colour = cyl), size = 3,  hjust=-0.25) +
  ggtitle("ggplot2 example")
print(p)

## ----plot-ggplot-finance-download, eval=FALSE----------------------------
#  msft.url <- "http://www.google.com/finance/historical?q=NASDAQ:MSFT&output=csv"
#  goog.url <- "http://www.google.com/finance/historical?q=NASDAQ:GOOG&output=csv"
#  aapl.url <- "http://www.google.com/finance/historical?q=NASDAQ:AAPL&output=csv"
#  
#  msft.data <- read.table(msft.url, header = TRUE, sep = ",")
#  msft.data$name<- "MSFT"
#  goog.data <- read.table(goog.url, header = TRUE, sep = ",")
#  goog.data$name<- "GOOG"
#  aapl.data <- read.table(aapl.url, header = TRUE, sep = ",")
#  aapl.data$name<- "AAPL"
#  stock.data <- rbind(msft.data, goog.data, aapl.data)

## ----plot-ggplot-finance-local-import------------------------------------
stock.data <- read.csv("../data/stock_data.csv")
head(stock.data)

## ----plot-ggplot-finance-date--------------------------------------------
# stock.data$Date <- as.Date(stock.data$Date , "%d-%b-%y")
stock.data$Date <- as.Date(stock.data$Date)

## ----plot-ggplot-geom-line-----------------------------------------------
ggplot(stock.data, aes(x=Date, y=Close, group=name)) +
  geom_line(aes(color = name)) 

## ----plot-ggplot-geom-corr-src, echo = TRUE, eval = FALSE----------------
#  bacf = acf(x=stock.data$Date, plot=F)
#  bacfdf <- with(bacf, data.frame(lag, acf))
#  ggplot(data=bacfdf, mapping=aes(x=lag, y=acf)) +
#         geom_bar(stat = "identity", position = "identity", width=.1)

## ----plot-ggplot-geom-corr, ref.label = "plot-ggplot-geom-corr-src", echo = FALSE, eval = TRUE----
bacf = acf(x=stock.data$Date, plot=F)
bacfdf <- with(bacf, data.frame(lag, acf))
ggplot(data=bacfdf, mapping=aes(x=lag, y=acf)) +
       geom_bar(stat = "identity", position = "identity", width=.1)

## ----plot-ggplot-finance-normalize---------------------------------------
stock.data.norm <- stock.data[, c('Date', 'Close', 'Volume', 'name')]
stock.data.norm <- do.call('rbind',
  by(stock.data.norm,stock.data$name,function(STOCK){
  	STOCK$Close <- STOCK$Close/STOCK$Close[nrow(STOCK)]
		return(STOCK)
	})
)

## ----plot-ggplot-finance-normalize-plot----------------------------------
ggplot(stock.data.norm, aes(x=Date, y=Close, group=name)) +
  geom_line(aes(color = name)) 

## ----plot-ggplot-finance-volume------------------------------------------
stock.data.norm$Volume <- stock.data.norm$Volume / max(stock.data.norm$Volume)
ggplot(stock.data.norm, aes(x=Date, y=Close, group=name)) +
  geom_line(aes(color = name, size=Volume)) 

