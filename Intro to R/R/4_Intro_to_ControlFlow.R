## ----, loop-example------------------------------------------------------
hp.sum <- 0
hp.n <- nrow(mtcars)
for(i in 1:length(mtcars$hp)){
    hp.sum <- hp.sum + mtcars$hp[i]
}
hp.mean <- hp.sum / hp.n
mtcars$hp.cent <- NA
for(i in 1:length(mtcars$hp)){
    mtcars$hp.cent[i] <- mtcars$hp[i] - hp.mean
}

## ----, vector-example----------------------------------------------------
mtcars$hp.cent2 <- mtcars$hp - mean(mtcars$hp)
head(mtcars[c('hp','hp.cent','hp.cent2')])

## ----syntax-vectorisation-1----------------------------------------------
distance <- cars$dist

## ----syntax-vectorisation-2----------------------------------------------
denominator <- 2*distance
denominator

## ----syntax-vectorisation-3----------------------------------------------
numerator <- -(cars$speed^2)

## ----syntax-vectorisation-4----------------------------------------------
cars$numerator <- numerator
cars$denominator <- denominator

## ----syntax-vectorisation-5----------------------------------------------
cars$acceleration <- cars$numerator / cars$denominator

## ----syntax-vectorisation-6----------------------------------------------
cars$acceleration <- -(cars$speed^2)/(2*cars$dist)

## ----syntax-null---------------------------------------------------------
cars$numerator <- NULL 
cars$denominator <- NULL 

## ----control-flow-1, eval=FALSE------------------------------------------
#  help(Control)

## ----while-example, eval=FALSE-------------------------------------------
#  mynum <- 8
#  while(mynum > 1){
#      print(mynum)
#      mynum <- mynum - 1
#  }

## ----, eval=FALSE--------------------------------------------------------
#  if(sample(c(FALSE,TRUE),1)){
#      print("heads")
#  }else{
#      print("tails")
#  }

## ----logical-vectors-----------------------------------------------------
mtcars$mpg > median(mtcars$mpg)

## ----syntax-logical-accel------------------------------------------------
cars$acceleration < -3

## ----syntax-logical-subset-----------------------------------------------
length(cars$acceleration[cars$acceleration < -3])

## ----syntax-logical-subset-assign----------------------------------------
cars$acceleration[cars$acceleration < -3] <- -3

## ----ifelse-example-novec------------------------------------------------
if(mtcars$mpg > median(mtcars$mpg)) print("efficient") else print("gas-guzzler")

## ----ifelse-example------------------------------------------------------
mtcars2 <- mtcars
mtcars2$efficiency <- ifelse(mtcars$mpg > median(mtcars$mpg), "efficient","gas-guzzler")
mtcars2$efficiency

## ----syntax-na-----------------------------------------------------------
x <- 1:3
x[4]

## ----syntax-nan----------------------------------------------------------
0/0

## ----syntax-inf----------------------------------------------------------
1/0

## ----syntax-na-2---------------------------------------------------------
x <- c(1, 2, 3, NA, 4, 5)

## ----syntax-na-3---------------------------------------------------------
is.na(x)
x[is.na(x)] <- 3.5
x

## ----vec-create----------------------------------------------------------
V1 <- c(1, 2, 3, 4, NA)
V2 <- c(1, NA,  4, 3, 9)

