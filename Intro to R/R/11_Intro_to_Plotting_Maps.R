## ----plot-ggplot-airports-read-------------------------------------------

# airports.url <- "http://stat-computing.org/dataexpo/2009/airports.csv"

airports <- read.csv("../data/airports.csv")

## ----structure-airports--------------------------------------------------
str(airports)

## ----plot-ggplot-airports-subset-----------------------------------------
unique(airports$country)
usAirports <- airports[airports$country == "USA", ]

## ----plot-ggplot-airports-plot-------------------------------------------
library(maps)
states <- data.frame(
  map("state", plot=FALSE)[c("x", "y")]
  )
world <- data.frame(
  map("world", regions=c("USA", "canada", "mexico"), plot=FALSE, 
      xlim=c(-180, -60))[c("x", "y")]
  )

## ----plot-ggplot-airports-usa--------------------------------------------
library(ggplot2)
ggplot() + 
  geom_path(data=world, aes(x=x, y=y)) +
  geom_path(data=states, aes(x=x, y=y)) +
  geom_point(data = usAirports, aes(x=long, y=lat), alpha=0.2, size=1, color = "red") +
  coord_map()


## ----plot-ggplot-azequalarea---------------------------------------------
ggplot() + 
  geom_path(data=world, aes(x=x, y=y)) +
  geom_path(data=states, aes(x=x, y=y)) +
  geom_point(data = usAirports, aes(x=long, y=lat), alpha=0.2, size=1, color = "red") +
  coord_map("azequalarea")


