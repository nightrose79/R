## ----polishing-load-data-------------------------------------------------
dataPath <- "../data"
rdataFile <- file.path(dataPath, "airline.RData")
load(rdataFile, verbose=TRUE)

library(png)
library(ggplot2)
library(gridExtra)

## ----, eval=FALSE--------------------------------------------------------
#  vignette("grid")

## ----polishing-logo-grid-1-----------------------------------------------
# Set up the layout for grid 
lo = grid.layout(nrow=3, ncol=3, 
                 widths = unit.c(unit(2, "cm"),
                                 unit(1, "npc") - 2*unit(2, "cm"),
                                 unit(2, "cm")), 
                 heights = unit.c(unit(2, "cm"),
                                  unit(1, "npc") - 2*unit(2, "cm"),
                                  unit(2, "cm")))


## ----polishing-logo-grid-2-----------------------------------------------
# Show the layout
grid.show.layout(lo)

## ----addimages-----------------------------------------------------------
# Reads an image from a PNG file/content into a raster array. & Render a raster object (bitmap image) at the given location, size, and orientation. 
Lg <- rasterGrob(readPNG(file.path(dataPath,"RA_LOGO_LG.png"), FALSE)) 
Sm <- rasterGrob(readPNG(file.path(dataPath,"RA_ICON.png"), FALSE)) 

# Get the graph
p <- ggplot(airline, aes(departure.time / 100, color=carrier)) + 
  xlab("Departure Time") + ylab("Density") + 
  ggtitle("Density") + geom_density(na.rm=TRUE)


## ----polishing-logo-grid2-src, echo =TRUE, eval = FALSE, results="hide"----
#  # Position the elements within the viewports
#  grid.newpage()
#  pushViewport(viewport(layout = lo))
#  
#  # The Logo (Upper left corner)
#  pushViewport(viewport(layout.pos.row=1, layout.pos.col=1))
#  print(grid.draw(Sm), newpage=FALSE)
#  popViewport()
#  
#  # The Plot (Center)
#  pushViewport(viewport(layout.pos.row=2, layout.pos.col=2))
#  print(p, newpage=FALSE)
#  popViewport()
#  
#  # The Banner (Bottom center)
#  pushViewport(viewport(layout.pos.row=3, layout.pos.col=2))
#  print(grid.draw(Lg), newpage=FALSE)
#  popViewport()

## ----polishing-logo-grid2-img, ref.label = "polishing-logo-grid2-src", echo =FALSE, eval = TRUE, results="hide"----
# Position the elements within the viewports
grid.newpage()
pushViewport(viewport(layout = lo))

# The Logo (Upper left corner)
pushViewport(viewport(layout.pos.row=1, layout.pos.col=1))
print(grid.draw(Sm), newpage=FALSE)
popViewport()

# The Plot (Center)
pushViewport(viewport(layout.pos.row=2, layout.pos.col=2))
print(p, newpage=FALSE)
popViewport()

# The Banner (Bottom center)
pushViewport(viewport(layout.pos.row=3, layout.pos.col=2))
print(grid.draw(Lg), newpage=FALSE)
popViewport()

