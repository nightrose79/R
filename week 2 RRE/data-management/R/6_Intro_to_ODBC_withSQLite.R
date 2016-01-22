## ----sql-require-rsqlite, eval=FALSE-------------------------------------
#   require(RSQLite) || { install.packages('RSQLite'); require(RSQLite) }

## ----dirsetup------------------------------------------------------------
dataPath <- "../data"
bigDataPath <- Sys.getenv("ACADEMYR_BIG_DATA_PATH")
if(bigDataPath == "") {
  bigDataPath <- Sys.setenv(ACADEMYR_BIG_DATA_PATH = "/usr/share/BigData")
}
outdir <- "../output"
if(!file.exists(outdir)) dir.create(outdir)

## ----sql-connect, cache=FALSE--------------------------------------------
library("RSQLite")
db <- dbConnect(SQLite(), dbname = file.path(bigDataPath,"airlines.sqlite"))

## ----sql-list-tables-----------------------------------------------------
dbListTables(db)

## ----sql-list-fields-2---------------------------------------------------
dbListFields(db, "airports")
dbListFields(db, "carriers")
dbListFields(db, "planes")

## ----sql-table-size------------------------------------------------------
query <- 'SELECT count(*) FROM carriers'
dbGetQuery(db, query)

## ----sql-clear-results, eval=FALSE---------------------------------------
#  dbListResults(db)
#  dbClearResult(dbListResults(db)[[1]])

## ----sql-hard-way--------------------------------------------------------
query <- "SELECT * FROM carriers"
res <- dbSendQuery(db, query)
x <- fetch(res, n = -1)
str(x)

## ----sql-hard-way2-------------------------------------------------------
dbListResults(db)
print(res)

## ----sql-sequential-reads------------------------------------------------
try(x2 <- fetch(res, n=-1))
try(str(x2))

## ----sql-hard-way3-close-------------------------------------------------
dbClearResult(res)

## ----sql-carriers--------------------------------------------------------
query <- "SELECT * FROM carriers"
x <- dbGetQuery(db, query)
str(x)
head(x)

## ----sql-where-1---------------------------------------------------------
query <- 'SELECT * FROM airlines where Dest="DAL"'
x <- dbGetQuery(db, query)
nrow(x)

## ----sql-wildcards-1-----------------------------------------------------
query <- 'SELECT * FROM carriers where Description LIKE "American%"'
x <- dbGetQuery(db, query)
x

## ----sql-wildcards-2, tidy=FALSE-----------------------------------------
query <- 'SELECT * FROM carriers where Description LIKE "%American%"'
x <- dbGetQuery(db, query)
x

## ----sql-airlines--------------------------------------------------------
dbListFields(db, "airlines")

## ----sql-american-airlines,tidy=FALSE------------------------------------
query <- 'SELECT DISTINCT Origin FROM airlines
  WHERE UniqueCarrier = "AA"'
aaCities <- dbGetQuery(db, query)
str(aaCities)

## ----sql-aa-aircraft, tidy=FALSE-----------------------------------------
query <- 'SELECT DISTINCT Origin as apcode
  FROM airlines WHERE UniqueCarrier = "AA"'
aaCities <- dbGetQuery(db, query)
str(aaCities)

## ----sql-airports-reminder-----------------------------------------------
dbListFields(db, "airports")

## ----sql-easy-airports---------------------------------------------------
query <- "SELECT * FROM airports"
airports <- dbGetQuery(db, query)
head(airports)

## ----sql-merge-r-1-------------------------------------------------------
aaAirportLocs <- merge(x=airports,by.x="iata",y=aaCities,by.y="apcode")
dim(aaAirportLocs)
head(aaAirportLocs)

## ----sql-states-map------------------------------------------------------
library(maps)
map("state")
title("American Airlines")
with(aaAirportLocs, points(long, lat, col="red"))

## ----sql-merge-sql-1-----------------------------------------------------
query <- 'SELECT DISTINCT Origin FROM airlines WHERE UniqueCarrier = "AA"'
x <- dbGetQuery(db, query)
str(x)

## ----sql-merge-sql-2, tidy=FALSE-----------------------------------------
query <- '
  SELECT *
  FROM airports
  JOIN (
    SELECT DISTINCT Origin FROM airlines
    WHERE UniqueCarrier = "AA"
  ) as airlines
  ON airlines.Origin = airports.iata
'
x <- dbGetQuery(db, query)
str(x)

