## ----linear-model, tidy=FALSE, eval=FALSE--------------------------------
#  help(rxLinMod)

## ----rxLinMod-args-------------------------------------------------------
args(rxLinMod)

## ----folder-config-------------------------------------------------------
## dir config
big.data.path <- Sys.getenv("ACADEMYR_BIG_DATA_PATH")
data.path <- "../data"
output.path <- "../output/xdf"
if(!file.exists(output.path)) dir.create(output.path,recursive=TRUE)
sample.data.dir <- rxGetOption("sampleDataDir")

## ----airline-import------------------------------------------------------
airline.csv <- file.path(sample.data.dir, "AirlineDemoSmall.csv")
airline.xdf <- file.path(output.path, "airline.xdf")

colInfo <- list(
  DayOfWeek = list(
    type = "factor",
    levels = c("Monday", "Tuesday", "Wednesday", 
               "Thursday", "Friday", "Saturday", "Sunday"))
  )

if(!file.exists(airline.xdf)){
  rxImport(inData = airline.csv,
           outFile = airline.xdf,
           colInfo = colInfo,
           missingValueString = "M",
           overwrite = TRUE)
}

## ----airline-data-info---------------------------------------------------
rxGetInfo(airline.xdf, getVarInfo = TRUE, numRows = 5)

## ----airline-data-summary------------------------------------------------
rxSummary(~., data=airline.xdf)

## ----airline-data-summary-by-day-----------------------------------------
(delaySumm <- rxSummary(ArrDelay~DayOfWeek, data=airline.xdf))

## ----airline-data-cube---------------------------------------------------
(delayCube <- rxCube(ArrDelay~DayOfWeek, data=airline.xdf, means = TRUE))

## ----airline-data-histogram----------------------------------------------
rxHistogram(~ArrDelay, data=airline.xdf)

## ----airline-data-lm-----------------------------------------------------
model <- rxLinMod(ArrDelay ~ DayOfWeek, data = airline.xdf)

## ------------------------------------------------------------------------
model

## ------------------------------------------------------------------------
(mod.summ <- summary(model))

## ------------------------------------------------------------------------
coef(model)

## ------------------------------------------------------------------------
names(mod.summ)
coef(mod.summ$ArrDelay)

## ------------------------------------------------------------------------
names(model)

## ----airline-data-lm-covcoef-example-------------------------------------
coef(model)[1] + coef(model)[2]
rxCube(ArrDelay~DayOfWeek, data=airline.xdf, means=TRUE)["1","ArrDelay"]

## ----lm-documentation, eval=FALSE----------------------------------------
#  help(rxLinMod)

## ----airline-data-lm-cube------------------------------------------------
model_cubed <- rxLinMod(ArrDelay ~ DayOfWeek, data = airline.xdf, cube=TRUE)

## ----airline-data-lm-cube-summary----------------------------------------
print(summary(model_cubed), header=FALSE)

## ----model.mat.example---------------------------------------------------
mydf <- data.frame(y = rnorm(30), x = gl(3,1,30, labels = LETTERS[1:3]))
str(mydf)
myModelMat <- model.matrix(lm(y ~ x, data = mydf))
head(myModelMat)

## ----airline-data-lm-cube-additive-departure-----------------------------
model <- rxLinMod(ArrDelay ~ DayOfWeek + CRSDepTime, data = airline.xdf, cube = TRUE)

## ----airline-data-lm-additive-summary------------------------------------
print(summary(model), header=FALSE)

## ----airline-data-lm-cube-interaction-departure--------------------------
# add departure time into the mix: interact with days
model <- rxLinMod(ArrDelay ~ DayOfWeek:F(CRSDepTime), data = airline.xdf, cube = TRUE)

## ----airline-data-lm-interactive-summary---------------------------------
print(summary(model), header=FALSE)

## ----airline-data-lm-cube-logdelay-interaction-departure-----------------
# can use transformations
model <- rxLinMod(log(abs(ArrDelay)) ~ DayOfWeek:F(CRSDepTime), data = airline.xdf, cube = TRUE)

## ----airline-data-lm-inline-summary--------------------------------------
print(summary(model), header=FALSE)

## ----airline-data-lm-cube-transforms-interaction-departure---------------
model <- rxLinMod(ArrDelay ~ DayOfWeek + depTimeCat, 
                  data = airline.xdf, 
                  cube = TRUE, 
                  transforms = list(
                    depTimeCat = cut(CRSDepTime, breaks = seq(from=5, to=23, by=2)))
                  )

## ----airline-data-lm-transforms-summary----------------------------------
print(summary(model), header=FALSE)

## ----airline-data-lm-rxdata----------------------------------------------
airline_rxdata <- RxTextData(file=airline.csv, 
                             colInfo=colInfo,
                             missingValueString = "M"
                             )

model <- rxLinMod(ArrDelay ~ DayOfWeek+depTimeCat, 
                  data = airline_rxdata, 
                  cube = TRUE,
                  transforms=list(depTimeCat = cut(
                    CRSDepTime, breaks=seq(from=5, to=23, by=2))), 
                  dropFirst = TRUE)

## ----textdata-summary----------------------------------------------------
print(summary(model), header=FALSE)

## ----printBankData, echo=FALSE-------------------------------------------
data.path  <-  "../data"
bankXDF <- file.path(data.path,"BankXDF.xdf")
bank.info <- rxGetInfo(bankXDF, numRows=6)
subset(bank.info[["data"]], select = age:loan)

## ----printBankData2, echo=FALSE------------------------------------------
subset(bank.info[["data"]], select = contact:y)

## ----model-coefficients-size---------------------------------------------
model <- rxLinMod(ArrDelay ~ DayOfWeek:F(CRSDepTime), 
                  data = airline.xdf)
length(model$coefficients)

## ----lm-variance-covariance-failure--------------------------------------
model$covCoef

## ----lm-variance-covariance----------------------------------------------
# force return of covCoef
model <- rxLinMod(ArrDelay ~ DayOfWeek:F(CRSDepTime), 
                  data = airline.xdf, covCoef = TRUE)
model$covCoef

## ----piece-of-covmat-----------------------------------------------------
# extract covariance matrix
cov.matrix <- model$covCoef
dimnames(cov.matrix) <- NULL
cov.matrix[1:5,1:5]

