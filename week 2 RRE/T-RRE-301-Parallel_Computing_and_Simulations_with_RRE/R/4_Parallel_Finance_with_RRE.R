## ----mcoption-loop-------------------------------------------------------
mcoption <- function( s0, k, t, v, r, n, m ){
   h <- t/n
   s <- matrix( 0, m, n + 1 )
   payoff <- matrix( 0, m, 1 )
   for( j in 1:m ){
       s[ j, 1 ] <- s0
       for( i in 2:( n + 1 ) ){
          s[ j, i ] <- s [ j, i - 1 ] * exp((r - 0.5 * v^2) * h + rnorm(1) * v * sqrt(h))
       }
       payoff[j] <- max( 0, s[ j, n +  1 ] - k )
   }
   callprice <- mean(payoff) * exp(-r*t)
}


## ----mcoption-apply------------------------------------------------------
mcoption2 <- function( s0, k, t, v, r, n, m ) {
  h <- t/n
  s <- matrix( s0, m, n + 1 )
  s <- t(apply(s, 1, function(x){
    for(i in 2:(n + 1) ){
      x[i] <- x [i - 1] * exp((r - 0.5 * v^2) * h + rnorm(1) * v * sqrt(h))
      }
    x
    }))
  
  final <- s[, n+1]
  payoff <- ifelse( 0 > final - k, 0, final - k )
  mean(payoff) * exp(-r*t)
  }

## ----compare-mcoption----------------------------------------------------
set.seed(42)
t1<-system.time(a <- mcoption(100, 100, 1, 0.3, 0.03, 52, 10000))
set.seed(42)
t2<-system.time(b <- mcoption2(100, 100, 1, 0.3, 0.03, 52, 10000))
all.equal(a,b)

## ----compute-row---------------------------------------------------------
computeRow <- function(s0, n, r, v, h){
  x <- rep(s0, n + 1)
  for(i in 2:(n + 1) ){
    x[i] <- x [i-1] * exp((r - 0.5 * v^2) * h + rnorm(1) * v * sqrt(h))       
    }
  x
  }

## ----mcparallel----------------------------------------------------------
mcparallel <- function(s0, k, t, v, r, n, m, numw){
  h <- t/n
  s <- unlist(
    rxExec(computeRow, s0, n, r, v, h, timesToRun=m, taskChunkSize=m/numw)
    )
  s <- matrix(s, nrow=m, ncol=n+1, byrow=TRUE)
  final <- s[, n + 1]
  payoff <- ifelse( 0 > final - k, 0, final - k )
  mean(payoff) * exp(-r*t)
  }

## ----time-mcparallel-----------------------------------------------------
rxSetComputeContext(RxLocalParallel())
rxOptions(numCoresToUse=8)
numw <- 8
set.seed(42)
t3<-system.time({
  mcparallel( s0=100, k=100, t=1, v=0.3, r=0.03, n=52, m=10000, numw ) 
  })

## ----compute-row-2-------------------------------------------------------
computeRow2 <- function(s0,n,r,v,h,   chunksize) {
	s <- matrix(s0, nrow=chunksize, ncol=n+1)
	s <- t(apply(s, 1, function(x,n,r,v,h) {
		for( i in 2:( n + 1 ) ){
			x[ i ] <- x [ i - 1 ] * exp((r - 0.5 * v^2) * h + rnorm(1) * v * sqrt(h))           
		}
		x
	}, n=n, r=r,v=v, h=h))
	s
}

## ----compute-row-2a------------------------------------------------------
mcparallel2 <- function( s0, k, t, v, r, n, 	m, numw )
{
	h <- t/n
	chunksize <- m / (2 * numw)
	s <- rxExec(computeRow2, s0=s0, n=n, r=r, v=v, h=h, chunksize=chunksize, timesToRun=m/chunksize)
	s <- do.call("rbind", s)
	final <- s[,n+1]
	payoff <- ifelse( 0 > final - k, 0, final - k )
    mean(payoff) * exp(-r*t)
}	

## ----time-mcparallel2----------------------------------------------------
rxSetComputeContext(RxLocalParallel())
rxOptions(numCoresToUse=8)
numw <- 8
set.seed(42)
t4<-system.time({
  out2 <- mcparallel2( s0=100, k=100, t=1, v=0.3, r=0.03, n=52, m=10000, numw ) 
  })

## ----runtime-compare-----------------------------------------------------
t1
t2
t3
t4

