## ----manip-reshape-1-----------------------------------------------------
movie.data <- read.table("../data/MovieLens.data")
names(movie.data) <- c("user.id", "item.id", "rating", "timestamp")
movie.data = movie.data[order(movie.data$user.id, movie.data$item.id), ]

## ----view-movie-data-----------------------------------------------------
head(movie.data)

## ----manip-reshape-3-----------------------------------------------------
movie.data$timestamp <- NULL 
df.wide <- reshape(movie.data, idvar="user.id", 
                   timevar="item.id", direction="wide")
dim(df.wide)

## ----view-wide-----------------------------------------------------------
dim(df.wide)
df.wide[1:3,1:5]

## ----Indometh------------------------------------------------------------
str(Indometh)

## ----reshape-wide2long-ex------------------------------------------------
cars.long <- reshape(cars,direction="long", varying=c("speed","dist"),
                     timevar="measuretype", times=c("speed","dist"), v.names="measureval")
head(cars.long)

## ------------------------------------------------------------------------
hsb2 <- read.csv('http://www.ats.ucla.edu/stat/r/faq/hsb2.csv')
str(hsb2)

## ----, echo=FALSE--------------------------------------------------------
structure(
    list(id = c(70L, 121L, 86L, 141L, 172L, 113L),
         female = c(0L, 1L, 0L, 0L, 0L, 0L),
         race = c(4L, 4L, 4L, 4L, 4L, 4L),
         ses = c(1L, 2L, 3L, 3L, 2L, 2L),
         schtyp = c(1L, 1L, 1L, 1L, 1L, 1L),
         prog = c(1L, 3L, 1L, 3L, 2L, 2L),
         subj = c("read", "read", "read", "read", "read", "read"),
         score = c(57L, 68L, 44L, 63L, 47L, 44L)),
    .Names = c("id", "female", "race", "ses", "schtyp", "prog", "subj", "score"),
    reshapeLong = structure(
        list(
            varying = structure(
                list(score = c("read", "write", "math", "science", "socst")),
                .Names = "score",
                v.names = "score",
                times = c("read", "write", "math", "science", "socst")),
            v.names = "score", idvar = "id", timevar = "subj"),
        .Names = c("varying", "v.names", "idvar", "timevar")),
    row.names = c(NA, 6L),
    class = "data.frame")

