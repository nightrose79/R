## ----foreach-intro-1, eval=FALSE-----------------------------------------
#  library(foreach)
#  foreach( range ) %do% {...}
#  ## OR ##
#  foreach( range ) %dopar% {...}

## ----foreach-intro-2-----------------------------------------------------
library(foreach)
foreach(i = 4:6) %do% sqrt(i)

## ----lapply--------------------------------------------------------------
lapply( 4:6, sqrt )

## ------------------------------------------------------------------------
## Use package parallel
library(doParallel)
cl <- makeCluster(2)
registerDoParallel(cl)
foreach(i=1:4) %dopar% sqrt(i)  
stopCluster(cl)

## ----craps-function------------------------------------------------------
playCraps <- function() {
  result <- NULL
  point <- NULL
  count <- 1
  while (is.null(result)) {
    roll <- sum(sample(6, 2, replace=TRUE))
    if (is.null(point)) { point <- roll }
    if (count == 1 && (roll == 7 || roll == 11)) { result <- "Win" }
    else if (count == 1 && (roll == 2 || roll == 3 || roll == 12)) { result <- "Loss" } 
    else if (count > 1 && roll == 7 ) { result <- "Loss" } 
    else if (count > 1 && point == roll) { result <- "Win" } 
    else { count <- count + 1 }
    result
    }
  result
  }

## ----craps-foreach-------------------------------------------------------
library(doParallel)
cl <- makeCluster(2)
registerDoParallel(cl)
z1 <- foreach(i=1:10000) %dopar% playCraps()
table(unlist(z1))

## ----iterators-----------------------------------------------------------
library(iterators)
matobj <- iter(matrix( 1:4, ncol = 2 ) )
a <- matrix( 1:4, ncol = 2 )
nextElem(matobj)

## ----foreach-iter--------------------------------------------------------
library(doParallel)
cl <- makeCluster(4)
registerDoParallel(cl)
dim <- 1000
matobj <- iter( (matrix(rnorm(dim^2), ncol = dim) ), by = "col" )
foreach(i = matobj, .combine = cbind ) %dopar% mean(i) 

## ----foreach-iter2-------------------------------------------------------
a <- matrix(rnorm(dim^2), dim )
foreach( i=1:dim, .combine = c )%dopar% mean(a[,i])
stopCluster(cl)

## ----for-loop-nested-----------------------------------------------------
sim <- function(a, b) 10 * a + b
avec <- 1:2
bvec <- 1:4
x <- matrix(0, length(avec), length(bvec))
#use for loop first:
for (j in 1:length(bvec)) {
  for (i in 1:length(avec)) {
    x[i,j] <- sim(avec[i], bvec[j])
  }
}
x

## ----foreach-nested------------------------------------------------------
x <- foreach(b=bvec, .combine='cbind') %:%
  foreach(a=avec, .combine='c') %do% { sim(a, b) }

## ----, eval=FALSE--------------------------------------------------------
#  x <- foreach(b=bvec, .combine='cbind') %:%
#    foreach(a=avec, .combine='c') %do% { sim(a, b) }

## ----, eval=FALSE--------------------------------------------------------
#  x <- foreach(b=bvec, .combine='cbind') %:%
#    foreach(a=avec, .combine='c') %dopar% { sim(a, b) }

## ------------------------------------------------------------------------
mtdata <- mtcars[ , c("mpg", "disp")]

## ------------------------------------------------------------------------
r0 <- coefficients( lm(mpg ~ disp, data=mtdata))

## ----lab-2-foreach-------------------------------------------------------

library(doParallel)
cl <- makeCluster(4)
registerDoParallel(cl)
r <- foreach(icount(1999), .combine=rbind) %dopar% {
  indices <- sample(32, 32, replace=TRUE)
	mtdataBoot <- mtdata[indices, ]  ## Create the bootstrap sample
	mod <- lm(mpg ~ disp, data=mtdataBoot)
	coefficients(mod) # return coefficient vector
}
stopCluster(cl)

## ----lab-2-combine-------------------------------------------------------
bias <- apply(r, 2, mean, na.rm=TRUE) - r0

stdErr <- sqrt(apply(r, 2L, function(r.st) var(r.st[!is.na(r.st)])))
bootObj <- cbind(r0,bias,stdErr)
bootObj

