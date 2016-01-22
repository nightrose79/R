## ------------------------------------------------------------------------
test <- function(a,b) return(a + b)
test
test(1,2)

## ----, eval=FALSE--------------------------------------------------------
#  function.name <- function(arguments){
#    # everything the function does in here
#  }

## ------------------------------------------------------------------------
test <- function(a=1, b=2) return(a + b)
test()
test(a=3,b=5)

## ------------------------------------------------------------------------
my.var <- 1
temp.func <- function() my.var <- 5
temp.func()
my.var

## ------------------------------------------------------------------------
my.var <- 1
temp.func2 <- function() print(5 + my.var) 
temp.func2()

## ------------------------------------------------------------------------
a <- 0
env.function <- function(){
  a <<- 1
}
env.function()
a

