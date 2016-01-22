## ----carsdemo------------------------------------------------------------
head(mtcars)

## ----apply-family-for----------------------------------------------------
cars.means <- numeric(ncol(mtcars))
for(i in 1:ncol(mtcars)){ 
  cars.means[i] <- mean(mtcars[,i])
  }
cars.means

## ----apply-family-apply--------------------------------------------------
apply(mtcars, 2, mean)

## ----apply-family-speed-comparison---------------------------------------
set.seed(42)
dims <- c(360,720,120)
mat.stack <- array(rnorm(prod(dims)), dim=dims)
avgs.mat1 <- matrix(NA,nrow(mat.stack), ncol(mat.stack))
avgs.mat2 <- avgs.mat1

## ----apply-family-speed-comparison-1b------------------------------------
system.time({  for(i in 1:nrow(mat.stack)){
    for(j in 1:ncol(mat.stack)){      avgs.mat1[i,j] <- mean(mat.stack[i,j,])      }
}  })

system.time({
  avgs.mat2 <- apply(mat.stack,c(1,2),mean)
  })

## ----apply-family-speed-comparison-2-------------------------------------
table(avgs.mat1 - avgs.mat2)

## ----apply-family-lapply-1-----------------------------------------------
mins.list.lapply <- lapply(mtcars,min)
mins.list.apply <- apply(mtcars,2,min)

## ----results-lapply------------------------------------------------------
mins.list.lapply
mins.list.apply

## ----apply-family-lapply-1b----------------------------------------------
is.list(mtcars)
is.matrix(mtcars)

## ----applyfamily-lapply-1c, echo=4, eval=TRUE, size='tiny', output.max = 20----
mtcars2 <- mtcars
mtcars2$efficient <- "efficient"
mtcars2$efficient[mtcars2$mpg < 20] <- "gas-guzzler"
head(mtcars2)

## ----applyfamily-lapply-1e-----------------------------------------------
apply(mtcars2,2,mean)

## ----applyfamily-lapply-1f-----------------------------------------------
lapply(mtcars2,mean)

## ----applyfamily-lapply-numcoerce----------------------------------------
apply(mtcars2,2,is.numeric)

## ----applyfamily-apply-charcoerce----------------------------------------
apply(mtcars2,2,is.character)

## ----apply-family-lapply-2-----------------------------------------------
test.frame <- data.frame(X = rnorm(20),Y=rnorm(20,2,10),Z=rnorm(20,2,3))
test.results <- apply(test.frame,2,t.test) # apply t-test to columns of the dataframe

class(test.results)
length(test.results)

## ----apply-family-lapply-3a----------------------------------------------
test.names1 <- list()
for(i in 1:length(test.results)){
    test.names1[[i]] <- names(test.results[[i]])
}
names(test.names1) <- names(test.results)
test.names1

## ----apply-family-lapply-3-----------------------------------------------
test.names <- lapply(test.results,names)
test.names
length(test.names)

## ----apply-family-lapply-4, eval=FALSE-----------------------------------
#  apply(test.results, 2, names)

## ----apply-family-lapply-6-----------------------------------------------
test.pvals <- lapply(test.results,getElement, "p.value")
test.pvals
length(test.pvals)

## ----apply-family-lapply-lab---------------------------------------------
data.list <- lapply(sample(0:1, 100, replace=TRUE),
                    function(x) if(x==0) rnorm(10) else letters[sample(1:26,1)]
                    ) 
data.list

## ----apply-family-by-----------------------------------------------------
# Average of all Variables at each level of Cyl

by(mtcars,mtcars$cyl,colMeans)


## ----apply-family-replicate----------------------------------------------
replicate(10, sample(1:100, 100,replace=TRUE))

