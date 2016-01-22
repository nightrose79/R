## ----manip-table---------------------------------------------------------
table(mtcars[, "gear"])

## ----manip-table-2, size='tiny'------------------------------------------
table(mtcars[,c("gear","cyl")])
table(mtcars[,c("cyl","gear")])

## ----manip-xtabs-1-------------------------------------------------------
xtabs(~gear + cyl, mtcars)

## ----formula-1, eval=FALSE-----------------------------------------------
#  ## Not evaluated again
#  xtabs(~gear + cyl, data=mtcars)

## ----manip-xtabs-2, eval=FALSE-------------------------------------------
#  xtabs(~gear, mtcars)
#  xtabs(~gear + carb, mtcars)
#  xtabs(~gear + cyl + carb, mtcars)

## ----manip-aggregate-1---------------------------------------------------
aggregate(hp ~ cyl + gear, data=mtcars, FUN=mean) 

## ----manip-aggregate-2, eval=1, size='tiny'------------------------------
aggregate(hp ~ cyl + gear, data=mtcars, FUN=median) 
aggregate(hp ~ cyl + gear, data=mtcars, FUN=min) 
aggregate(hp ~ cyl + gear, data=mtcars, FUN=max)

## ----manip-aggregate-3, size='tiny'--------------------------------------
aggregate(hp ~ cyl + gear, data=mtcars, FUN=quantile, probs=c(0.25,0.75)) 

## ----manip-aggregate-4, size='tiny'--------------------------------------
aggregate(cbind(hp,mpg) ~ cyl + gear, data=mtcars, FUN=mean) 

## ----apply-family-tapply-------------------------------------------------
# Similar to Pivot Tables (PT) in Excel
# tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE)
# ... where X are the PT Values, INDEX are the PT Row and Column Labels and FUN is the what we choose to summarize the Value field by in the PT

tapply(mtcars$mpg,mtcars[,c('gear','carb')],mean)

## ----apply-family-tapply-agg-comp,tiny=FALSE-----------------------------
aggregate(mpg ~ gear + carb, data=mtcars, FUN=mean)

