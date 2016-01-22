## ----statistics-basics-1, eval=FALSE, size="small"-----------------------
#  prod(x)
#  sum(x)
#  length(x)
#  mean(x)
#  var(x)
#  max(x)
#  min(x)
#  range(x)
#  sd(x)
#  sort(x)
#  order(x)

## ----statistics-summary-1------------------------------------------------
summary(mtcars$mpg)
summary(mtcars)

## ----statistics-correlation, size='tiny'---------------------------------
cor(mtcars[,1:5], method='pearson')
cor(mtcars[,1:5], method='spearman')

## ----statistics-shapiro--------------------------------------------------
cars$acceleration <- (cars$speed^2) / (2*cars$dist)
shapiro.test(cars$acceleration)

## ----statistics-t-test---------------------------------------------------
x.data <- rnorm(100,3,1)
y.data <- rnorm(100,3,1)

## ----t-test-example, ouput.max=15, size='tiny'---------------------------
t.test(x.data)

## ----t-test-indp-sample, output.max=20, size='tiny'----------------------
t.test(x.data,y.data)

## ----statistics-load-iswr------------------------------------------------
library(ISwR) 

## ----statistics-lm, size='tiny', output.max=15---------------------------
fit0 <- lm(mpg ~ ., data=mtcars) # fit with all variables
fit0

## ----inference-lm, size='tiny', output.max=30, echo=1--------------------
summary(fit0)
## Note: when used on an OLS linear model (`lm`) object in R, `summary()` returns regression output. 

## ----statistics-lm-2-----------------------------------------------------
new.data <- mtcars
factor.cols <- c('cyl','gear','carb')
new.data[, factor.cols] <- lapply(new.data[, factor.cols], as.factor) 

## ----statistics-lm-3, output.max=20, size='tiny'-------------------------
fit1 <- lm(mpg ~ ., data=new.data) 
summary(fit1)

## ----statistics-lm-aic-1, size='tiny'------------------------------------
library(MASS) # package associated with Modern Applied Statistics with S 
stepAIC(fit1, direction='both')

## ----statistics-lm-aic-2, output.max=20, size='tiny'---------------------
fit2 <- lm(mpg ~ cyl + hp + wt + am, data=new.data)
summary(fit2)

## ----statistics-lm-summaries, size='tiny', output.max=20-----------------
summary(fit1)$adj.r.squared
summary(fit1)$coefficients

## ----statistics-lm-summaries-2, size='tiny', output.max=20---------------
summary(fit2)$adj.r.squared
summary(fit2)$coefficients

## ----statistics-anova----------------------------------------------------
anova(fit2, fit1)

## ----statistics-anova-plot-----------------------------------------------
plot(fit2, 1)

## ----statistics-regression-lines, resize.width = "0.6\\textwidth", resize.height = "0.3\\textwidth"----
plot(dist ~ speed, data=cars,
     xlab = "Initial Speed (mph)",
     ylab = "Stopping Distance (ft)",
     main = "Car Speed vs. Stopping Distance",
     col = "red", cex.lab = 0.9)
regression.line <- lm(dist~speed, data=cars)
abline(regression.line) 

## ----statistics-dnorm----------------------------------------------------
dnorm(5, mean = 0, sd = 1) # height of PDF at x = 5

## ----statistics-pnorm----------------------------------------------------
pnorm(5, mean = 0, sd = 1) # P(X<5 | X~N(0,1) ) 

## ----statistics-distributions, resize.width = "0.6\\textwidth", resize.height = "0.3\\textwidth"----
par(mfrow=c(1,2)) 
plot(dnorm, -5, 5)
plot(pnorm, -5, 5)
par(mfrow=c(1, 1)) 

## ----statistics-sampling-------------------------------------------------
rnorm(10, mean = 0, sd = 1)

## ----statistics-set-seed-------------------------------------------------
set.seed(100)
rnorm(5)
rnorm(5)
set.seed(100)
rnorm(5)

## ----statistics-time-series----------------------------------------------
sunspots.ts <- ts(sunspots)
plot(sunspots.ts)

