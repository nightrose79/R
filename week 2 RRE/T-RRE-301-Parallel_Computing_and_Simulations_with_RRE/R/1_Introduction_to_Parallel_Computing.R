## ----par-matrix-multiply, warning=FALSE----------------------------------
set.seed(42)
A <- matrix(rnorm(1000000), 1000 ) 

## Check CPU time for unparallel matrix multiplication:

system.time( A %*% A )

## ----par-matrix-multiply2, warning=FALSE---------------------------------

library(snow)
cl <- makeSOCKcluster(names=3L)
system.time(parMM(cl, A, A))
stopCluster(cl)

## ----rxLogit-demo, eval=TRUE---------------------------------------------
library(rpart)
rxLogit(Kyphosis ~ Age + Start + Number, data = kyphosis)

## ----compute-context-hpc, eval=FALSE-------------------------------------
#  clusterHPC1 <- RxHpcServer(
#    headNode="cluster-head2",
#  	shareDir="\\AllShare\\richcalaway",
#  	revoPath="C:\\Revolution\\R-Enterprise-Node-6.1\\R-2.14.2\\bin\\x64\\",
#  	dataPath=c("C:\\data", "D:\\data"),
#  	computeOnHeadNode=TRUE,
#  	wait=TRUE)

## ----, rxLogit-demo-hpc, eval=FALSE--------------------------------------
#  # Just change the “compute context”
#  rxSetComputeContext(clusterHPC1) # an HPC server cluster
#  
#  # Otherwise, the code is the same
#  rxLogit(ArrDelay>15 ~ Origin + Year + Month + DayOfWeek + UniqueCarrier + F(CRSDepTime), data=airData)

## ----, compute-context-local-parallel, eval=TRUE-------------------------
rxSetComputeContext(RxLocalParallel())

## ----rxcube-demo, eval=TRUE----------------------------------------------
readPath <- system.file("SampleData", package="RevoScaleR")
censusWorkers <- file.path(readPath, "CensusWorkers.xdf")
censusWorkersCube <- rxCube(incwage ~ F(age), data=censusWorkers)
censusWorkersCube
censusWorkersCube$age <-     as.integer(levels(censusWorkersCube$F_age))[censusWorkersCube$F_age]
censusWorkersCubeDF <- as.data.frame(censusWorkersCube)

## ----rxcube-demo2, eval=TRUE---------------------------------------------
rxLinePlot(incwage ~ age, data=censusWorkersCubeDF, 
    title="Relationship of Income and Age")

## ----rxLinmod-demo, eval=TRUE--------------------------------------------
fourthgraders <- file.path(rxGetOption("sampleDataDir"),
 "fourthgraders.xdf")
fourthgradersLm <- rxLinMod(height ~ eyecolor, data = fourthgraders,
 fweights="reps")
summary(fourthgradersLm)

## ----rxGlm-demo, eval=TRUE-----------------------------------------------
library(robust)
data(breslow.dat, package = "robust")
myGlm <- rxGlm(sumY~ Base + Age + Trt, dropFirst = TRUE, 
    data=breslow.dat, family = poisson())

## ----rxGlm-demo2, eval=TRUE----------------------------------------------
library(robust)
summary(myGlm)

## ----rxexec-demo, eval=TRUE----------------------------------------------
# First, set the compute context to local parallel
rxSetComputeContext(RxLocalParallel())
rxOptions(numCoresToUse=4)

# Then, call rxExec with sqrt:
sqrt <- function(x) base::sqrt(x)
rxExec(sqrt, 1:4)

## ----rxexec-demo2, eval=TRUE---------------------------------------------
rxExec(sqrt, rxElemArg(1:4))

## ----rxexec-demo3, eval=TRUE---------------------------------------------

# The helper function rxElemArg allows you to pass different arguments to each worker. Compare to 
rxExec(sqrt, 1:4, timesToRun=4)
# which calculates the square roots of the entire sequence 1:4 four times.

## ----mandelbrot-init-----------------------------------------------------
mandelbrot <- function(x0,y0,lim) {
   x <- x0; y <- y0
   iter <- 0
   while (x^2 + y^2 < 4 && iter < lim)  {
      xtemp <- x^2 - y^2 + x0
      y <- 2 * x * y + y0
      x <- xtemp
      iter <- iter + 1
   }
  iter
}

## ----mandelbrot-vectorised-----------------------------------------------
vmandelbrot <- function(xvec, y0, lim) {
  unlist(lapply(xvec, mandelbrot, y0=y0, lim=lim))
  }

## ----mandelbrot-parallel-------------------------------------------------
size <- 240
x.in <- seq(-2.0, 0.6, length.out=size)
y.in <- seq(-1.3, 1.3, length.out=size)
m <- 100
z <- rxExec(vmandelbrot, x.in, y0=rxElemArg(y.in), m, execObjects="mandelbrot")
z <- matrix(unlist(z), ncol=size)           #order the data for the image

## ----mandelbrot-image----------------------------------------------------
image(x.in, y.in, z, col=c(rainbow(m), '#000000'))

## ----, rxexec-mandelbrot, eval=TRUE--------------------------------------
z <- rxExec(vmandelbrot, x.in, y0=rxElemArg(y.in), m, taskChunkSize=48, 	execObjects="mandelbrot")

