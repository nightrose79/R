## ----syntax-vectors-1----------------------------------------------------
1:10
(1:10)^2
letters
length(month.name)

## ----syntax-vectors-2----------------------------------------------------
x <- 1:10 
x
sum(x)
class(x)

## ----syntax-combine------------------------------------------------------
x <- c(1, 1, 2, 3, 5, 8)
sum(x)
y <- c(x, 13, 21)
y

## ----syntax-character----------------------------------------------------
authors <- c("Ross", "Robert")
authors
length(authors)

## ----syntax-paste--------------------------------------------------------
paste(authors, c("Ihaka", "Gentleman"))
paste("row", 1:5, sep="_")

## ----syntax-paste0-------------------------------------------------------
paste("row", 1:5)
paste0("row", 1:5)

## ----syntax-logical------------------------------------------------------
authors == "Ross"
1:10 > 7
sum(1:10 > 7)

## ----syntax-subset-vectors-----------------------------------------------
letters[5]
letters[1:5]
letters[c(1, 3, 5)]

## ----syntax-subset-vectors-neg-int---------------------------------------
letters[-1]
letters[-(1:5)]

## ----syntax-subset-vectors-convenience-----------------------------------
head(letters)
tail(letters)

## ----syntax-named-vectors------------------------------------------------
x <- 1:5
names(x) <- letters[1:5]
x

## ----subset-named--------------------------------------------------------
x["c"]
x[c("c", "d")]

## ----syntax-factor-------------------------------------------------------
mtcars$cyl
as.factor(mtcars$cyl)

## ----matrix-1------------------------------------------------------------
matrix(1:9, nrow=3, ncol=3)

## ----matrix-2------------------------------------------------------------
mat <- matrix(1:25, nrow=5)
mat

## ----syntax-subset-matrix-2----------------------------------------------
mat[2:4, 3:5]

## ----syntax-subset-matrix------------------------------------------------
mat[-3, -4]

## ----syntax-subset-matrix-empty------------------------------------------
mat[-3, ]

## ----syntax-array--------------------------------------------------------
array.one <- array( 1:12, dim = c(3,4))
array.two <- array( 1:24, dim = c(3,4,2))

## ----syntax-array-subset-------------------------------------------------
array.two[,,1]

## ----syntax-names--------------------------------------------------------
colnames(mat) <- paste("col", 1:5, sep="")
rownames(mat) <- paste0("row", 1:5)
mat 

## ----syntax-subset-names-------------------------------------------------
mat[c("row2","row3"),c("col1","col5")]

## ----syntax-list---------------------------------------------------------
xl <- list(
  num = 1:10, 
  char = letters[1:15], 
  log = rep(c(TRUE,FALSE), 10)
)
xl

## ----syntax-subset-list-single-------------------------------------------
out.single <- xl[1]
length(out.single)
class(out.single)

## ----syntax-subset-list-double-------------------------------------------
out.double <- xl[[1]]
length(out.double)
class(out.double)

## ----syntax-data-frame-head-cars-----------------------------------------
head(mtcars)

## ----syntax-data-frame-str-cars------------------------------------------
str(mtcars)

## ----syntax-data-frame-rownames------------------------------------------
names(mtcars)
colnames(mtcars)
rownames(mtcars)

## ----syntax-df-2---------------------------------------------------------
dat <- data.frame(
  char = letters[1:5],
  num  = 1:5,
  log  =  c(TRUE,FALSE,TRUE,FALSE,TRUE)
  )

head(dat)

## ----syntax-df-----------------------------------------------------------
class(mtcars)
typeof(mtcars)

## ----syntax-subset-dollar------------------------------------------------
cars$speed[1]

## ----syntax-head-data.frame----------------------------------------------
head(cars)

## ----syntax-dim----------------------------------------------------------
nrow(mtcars)
ncol(mtcars)
dim(mtcars)

## ----syntax-class, eval=FALSE--------------------------------------------
#  help(class)

