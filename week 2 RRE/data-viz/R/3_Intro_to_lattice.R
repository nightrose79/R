## ----lattice-formula, eval = FALSE---------------------------------------
#  help(formula)

## ----loadData------------------------------------------------------------
dataPath <- "../data"
load(file.path(dataPath,"airline.RData"))
str(airline)

## ----lattice-xyplot------------------------------------------------------
xyplot(air.time ~ distance, data = airline)

## ----lattice-xyplot-condition--------------------------------------------
xyplot(air.time ~ distance | carrier, data = airline)

## ----lattice-xyplot-panel-src, eval=FALSE, echo=TRUE---------------------
#  # Define a panel function to plot xyplot and lmline
#  panelFun <- function(x, y) {
#    panel.xyplot(x, y)
#    panel.lmline(x, y)
#  }
#  xyplot(air.time ~ distance | carrier, data = airline,
#         panel = panelFun, xlab = "Air Time", ylab = "Distance")

## ----lattice-xyplot-panel, ref.label = "lattice-xyplot-panel-src", eval=TRUE, echo=FALSE----
# Define a panel function to plot xyplot and lmline
panelFun <- function(x, y) {
  panel.xyplot(x, y)
  panel.lmline(x, y)
}
xyplot(air.time ~ distance | carrier, data = airline, 
       panel = panelFun, xlab = "Air Time", ylab = "Distance")

## ----lattice-densityplot-incorrect, eval=FALSE---------------------------
#  densityplot(distance, data = airline)         # doesn't work
#  densityplot(airline$distance, data = airline) # throws an error

## ----lattice-densityplot-correct-----------------------------------------
# Have to use formula for single variable
densityplot(~ distance, data = airline)       # proper syntax

## ----lattice-densityplot-rug---------------------------------------------
densityplot(~ distance, data = airline, plot.point = "rug")

## ----lattice-histogram---------------------------------------------------
# Histogram of departure time for each carrier
histogram(~ departure.time | carrier, data = airline, 
          xlab = "Departure Time (HHMM)")

## ----lattice-histogram-transform-----------------------------------------
histogram(~ departure.time / 100 | carrier, data = airline, 
          xlab = "Departure Time (HH)")

## ----lattice-histogram-weekday-------------------------------------------
# Histogram of departure time for each carrier and day of the week
histogram(~ departure.time / 100 | weekday + carrier, data = airline, 
          xlab = "Departure Time (HH)")

## ----lattice-barchart----------------------------------------------------
# Barchart using tabulated values we created previously
table <- table(airline$weekday, airline$carrier)
barchart(table, auto.key = TRUE)

## ----lattice-barchart-sorted---------------------------------------------
airline$weekday = factor(
  airline$weekday,
  levels(airline$weekday)[c(4,2,6,7,5,1,3)]
  )
table <- table(airline$weekday)
barchart(sort(table), auto.key = TRUE)

## ----lattice-barchart-table----------------------------------------------
# Barchart using new tablulated values
barchart(table(airline$carrier, airline$weekday), auto.key = TRUE)

## ----lattice-barchart-prop-table-----------------------------------------
# Barchart using new tablulated values and showing proportions
tabdata <- with(airline, prop.table(table(carrier, weekday), margin=1))
barchart(tabdata, auto.key = TRUE)

## ----lattice-data-shape, comment = NA------------------------------------
# Create a new cross table with binned air time using quantile(), cut() and table()
cbreaks <- quantile(airline$air.time, na.rm = TRUE)
airline$time.cut <- cut(airline$air.time, breaks=cbreaks)
(tabdata <- with(airline, table(time.cut, carrier)))

## ----lattice-barchart-groups---------------------------------------------
barchart(tabdata, auto.key = TRUE)

## ----lattice-barchart-groups-separated-----------------------------------
barchart(tabdata, groups = FALSE)

## ----lattice-barchart-groups-stacked-src, eval=FALSE, echo = TRUE--------
#  # Plot previous barchart but stack them with layout and add title
#  barchart(tabdata, auto.key = TRUE, groups = FALSE,
#           layout = c(5,1), horizontal = FALSE,
#           main = "Airline Carrier Flight Times",
#           scales = list(x = list(rot = 45)))

## ----lattice-barchart-groups-stacked-img, ref.label = "lattice-barchart-groups-stacked-src", eval=TRUE, echo = FALSE----
# Plot previous barchart but stack them with layout and add title
barchart(tabdata, auto.key = TRUE, groups = FALSE, 
         layout = c(5,1), horizontal = FALSE,
         main = "Airline Carrier Flight Times",
         scales = list(x = list(rot = 45)))

## ----lattice-dotplot-----------------------------------------------------
# Dotplot showing early arrivals
dotplot(tabdata, layout = c(5,1), 
        auto.key = TRUE, groups = FALSE, horizontal = FALSE,
        scales = list(x = list(rot = 45)),
        main = "Early Arrivals")

## ----lattice-dotplot-par-src, eval=FALSE, echo =TRUE---------------------
#  # Dotplot showing early arrivals
#  pars <- trellis.par.get("superpose.symbol")
#  pars$cex  <- 2;
#  pars$pch <- 17:23
#  trellis.par.set(superpose.symbol = pars)
#  dotplot(tabdata,
#          auto.key = list(space = "right"),
#          main = "Early Arrivals")

## ----lattice-dotplot-par, ref.label = "lattice-dotplot-par-src", eval=TRUE, echo =FALSE----
# Dotplot showing early arrivals
pars <- trellis.par.get("superpose.symbol")
pars$cex  <- 2; 
pars$pch <- 17:23
trellis.par.set(superpose.symbol = pars)
dotplot(tabdata, 
        auto.key = list(space = "right"), 
        main = "Early Arrivals")

## ----lattice-dotplot-prop-table------------------------------------------
tabdata <- with(airline, table(carrier, weekday))
tabdata <- prop.table(tabdata, margin = 1)
dotplot(tabdata, layout = c(7,1), horizontal = FALSE,
        scales = list(x = list(rot = 45)),
        auto.key = TRUE, groups = FALSE)

## ----lattice-box-whisker-plot--------------------------------------------
# Box and whiskers plot showing each airline carrier's distance
bwplot(distance ~ carrier, data = airline)

## ----lattice-box-whisker-plot-monthly------------------------------------
bwplot(distance ~ carrier | month, data = airline)

## ----lattice-violin------------------------------------------------------
# Violin plot using panel.violin
bwplot(departure.delay ~ carrier, data = airline, 
       panel = panel.violin, main = "Violins or hanging lamps?")

## ----lattice-qqmath------------------------------------------------------
qqmath(~ air.time, data = airline)

## ----lattice-qqmath-log-transform----------------------------------------
qqmath(~ log(air.time) | weekday, groups = carrier, 
       data = airline, auto.key = TRUE)

## ----lattice-qqmath-logit------------------------------------------------
qqmath(~ cancelled | weekday, groups = carrier, 
       data = airline, 
       auto.key = TRUE)

## ----lattice-splom, fig.width=14, fig.height=14--------------------------
# Scatterplot matrix using sample data
set.seed(42)
airSample <- airline[sample.int(nrow(airline), 500), ]
airSample <- airSample[c("departure.time", "arrival.time", "arrival.delay", "departure.delay")]
splom(airSample)

## ----lattice-cloud-------------------------------------------------------
cloud(distance ~ departure.time * elapsed.time | carrier, 
      data = airline)

## ----lattice-cloud-rotate------------------------------------------------
cloud(distance ~ departure.time * elapsed.time | carrier, 
      data = airline,
      screen = list(z = 80, x = -70), zoom = 0.7)

