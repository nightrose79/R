## ----manip-sort----------------------------------------------------------
(test <- sample(letters, 10))
sort(test)

## ----manip-sort-order----------------------------------------------------
order(test)
test[order(test)]

## ----sor-decreasing------------------------------------------------------
sort(test,decreasing=TRUE)
order(test,decreasing=TRUE)

## ----manip-order-dataframe-----------------------------------------------
mtcars[order(mtcars$mpg, decreasing=TRUE), ]

## ----manip-order-dataframe-2---------------------------------------------
mtcars[order(mtcars$mpg, mtcars$hp, decreasing=TRUE), ]

## ----manip-which---------------------------------------------------------
which(mtcars$hp == max(mtcars$hp)) 

## ----rownames-which------------------------------------------------------
rownames(mtcars)[which(mtcars$hp == max(mtcars$hp))]

## ----rowvals-which-------------------------------------------------------
mtcars[which(mtcars$hp == max(mtcars$hp)),]

## ----NA-which,echo=-(1:2)------------------------------------------------
vec <- 1:length(letters)
vec[sample(length(letters),6)] <- NA
vec
vec %% 2 == 0
which(vec %% 2 == 0)

## ----NA-which2-----------------------------------------------------------
letters[vec %% 2 == 0]
letters[which(vec %% 2 == 0)]

## ----assignwhich, echo=1:2-----------------------------------------------
mtcars2 <- mtcars
mtcars2$hp[mtcars2$hp > 250] <- 250
boxplot(cbind(mtcars$hp,mtcars2$hp))

## ----columnindexing------------------------------------------------------
head(mtcars)

## ----columnindexing-2----------------------------------------------------
mtcars2 <- mtcars[,which(names(mtcars) %in% c("hp","mpg"))]
head(mtcars2)

## ----columnindexing2-----------------------------------------------------
mtcars[which(mtcars$am == 0),which(names(mtcars) %in% c("hp","mpg"))]

