## ----, eval=FALSE--------------------------------------------------------
#  install.packages('randomForest') #install the package

## ------------------------------------------------------------------------
library(randomForest) # load the package into the workspace
# ?randomForest       # check package documentation 
rf.mpg <- randomForest(mpg~., data=mtcars) # fit model
rf.mpg                # display model prediction performance 

## ----, eval=FALSE--------------------------------------------------------
#  install.packages('package name')

## ----, eval=FALSE--------------------------------------------------------
#  vignette()
#  library(help = 'randomForest')

## ----lm-source-----------------------------------------------------------
lm

## ----random-forest-source------------------------------------------------
randomForest

## ----random-forest-source-correct----------------------------------------
randomForest:::randomForest.default

## ----find-invis-example--------------------------------------------------
methods(plot)

## ----getAnywhere---------------------------------------------------------
getAnywhere(plot.data.frame)$where

