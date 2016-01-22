## ----create-artificial-data----------------------------------------------
# Create artificial data
set.seed(1)
X <- rbind(
  matrix(rnorm(100, mean = 0, sd = 0.3), ncol = 2),
  matrix(rnorm(100, mean = 1, sd = 0.3), ncol = 2)
)
colnames(X) <- c("x", "y")

## ----plot-data-----------------------------------------------------------
plot(X)

## ----, eval=FALSE--------------------------------------------------------
#  # Simple code for clustering
#  kmeans(X, 5)

## ----cluster-plot-function-----------------------------------------------
# Create function to plot k-means clustering solution
clusterPlot <- function(x, n=5, nstart=1){
  cl <- kmeans(x, n, nstart=nstart)
  plot(x, col = cl$cluster)
  points(cl$centers, col = 1:n, pch = 8, cex = 2)
}

## ----cluster-different-solutions-----------------------------------------
par(mfrow=c(1, 2))
clusterPlot(X)
clusterPlot(X)
par(mfrow=c(1, 1))

## ----cluster-25-starts---------------------------------------------------
clusterPlot(X, n=5, nstart=25)

## ----, eval=FALSE--------------------------------------------------------
#  kmeans(Z, 10, iter.max = 35, nstart = 400)

## ----compute-context-----------------------------------------------------
rxSetComputeContext(RxLocalParallel())

## ----rxExec--------------------------------------------------------------
numTimes <- 8
results <- rxExec(kmeans, X, centers=5, iter.max=35, 
                  nstart=50, timesToRun=numTimes)  

## ----step-3--------------------------------------------------------------
(sumSSW <- vapply(results, function(x) sum(x$withinss), FUN.VALUE = numeric(1)))
results[[which.min(sumSSW)]]	

## ----kmeans-rsr----------------------------------------------------------
kMeansRSR <- function(x, centers=5, iter.max=10, nstart=1, numTimes=20) {
  results <- rxExec(FUN = kmeans, x=x, centers=centers, iter.max=iter.max, 
                    nstart=nstart, elemType="cores", timesToRun=numTimes)	
  sumSSW <- vapply(results, function(x) sum(x$withinss), FUN.VALUE = numeric(1))
  results[[which.min(sumSSW)]]
  }	

## ----kmeans-timing-------------------------------------------------------
# Create 5000 x 50 matrix
nrow <- 5000
ncol <- 50
Z <- matrix(rnorm(nrow*ncol), nrow, ncol)
iter.max <- 35
workers <- 8

## ----time-kmversions-----------------------------------------------------
nstart <- 800
# Time kmeans
(km1st <- system.time(km1 <- kmeans(Z, 10, iter.max, nstart))[[3]])
# Time kmeansRSR
(km8st <- system.time(kmrsr <- kMeansRSR(Z, 10, iter.max, nstart=nstart/(2*workers), numTimes=2*workers))[[3]])

## ----keans-performance-plot----------------------------------------------
plot(x=c(1, workers), y=c(km1st, km8st), type = 'b', ylim = c(0, max(km1st,km8st)+1))

