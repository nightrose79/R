## ----intro-example, eval=FALSE-------------------------------------------
attach(mtcars)
  head(mtcars)
  fit0 <- lm(mpg ~ ., data=mtcars) # fit with all variables
  summary(fit0)
  library(MASS)
  fit1 <- stepAIC(fit0, direction='both')
  summary(fit1)
  plot(fit1)
  anova(fit1,fit0)

## ----getting-help, eval=FALSE, tidy=FALSE--------------------------------
  ?lm
#  help(lm)

