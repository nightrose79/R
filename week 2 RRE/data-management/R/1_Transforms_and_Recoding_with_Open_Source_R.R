## ----mtcars-str----------------------------------------------------------
mymtcars <- mtcars
str(mymtcars)

## ----weight2-------------------------------------------------------------
mymtcars$wt2 <- mymtcars[["wt"]] * 1000
mymtcars$HpPerThouPound <- mymtcars[["hp"]] / mymtcars$wt
mymtcars$RaRSqr <- mymtcars$drat ^ 2

## ----newVars-str---------------------------------------------------------
str(mymtcars)
head(mymtcars)

## ----transform-with-functions--------------------------------------------
mymtcars$logdisp <- log(mymtcars$disp)
head(mymtcars)

## ----change-variable-----------------------------------------------------
mymtcars$disp <- mymtcars$disp * 2.54^3

## ----create-cat----------------------------------------------------------
mymtcars$cylFact <- factor(mymtcars$cyl)
qbreaks  <- quantile(mymtcars$qsec)
qbreaks[1] <- qbreaks[1]-0.01
mymtcars$qsecCut <- cut(mymtcars$qsec, qbreaks)
summary(mymtcars$qsecCut)

## ----conditional-trans---------------------------------------------------
mymtcars$wt[mymtcars$am == 0] <- mymtcars$wt[mymtcars$am == 0] * 1000
head(mymtcars)

## ----conditionl-trans-bad, eval = FALSE----------------------------------
#  for (i in 1:nrow(mymtcars)) {
#    if(mymtcars$am[i] == 0) {mymtcars$wt[i] <- mymtcars$wt[i] * 1000 }
#  }

## ----rename-variables----------------------------------------------------
names(mymtcars)
names(mymtcars)[2:4] <- c("cylinder","displacement","horsepower")
names(mymtcars)

## ----rename-variables-with-reshape---------------------------------------
library(reshape)
mymtcars <- rename(mymtcars, c(displacement = "D", horsepower = "H")) 

