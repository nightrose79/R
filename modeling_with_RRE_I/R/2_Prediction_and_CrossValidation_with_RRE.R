## ----folder-config-------------------------------------------------------
big.data.path <- Sys.getenv("ACADEMYR_BIG_DATA_PATH")
if(big.data.path == "") {
  Sys.setenv(ACADEMYR_BIG_DATA_PATH="/usr/share/BigData")
  big.data.path <- Sys.getenv("ACADEMYR_BIG_DATA_PATH")
}
data.path <- "../data"
output.path <- "../output/xdf"
if(!file.exists(output.path)) dir.create(output.path, recursive=TRUE)
sample.data.dir <- rxGetOption("sampleDataDir")

## ----rxLinMod-args-------------------------------------------------------
args(rxLinMod)

## ----setupADS------------------------------------------------------------
inADS <- RxXdfData(file.path(sample.data.dir, "AirlineDemoSmall.xdf"))
rxGetInfo(inADS, getVarInfo = TRUE)

## ----airline-data-lm-interactions,---------------------------------------
model <- rxLinMod(ArrDelay ~ DayOfWeek + F(CRSDepTime), data = inADS)
model

## ----rxPredict=help, eval=FALSE------------------------------------------
#  ?rxPredict

## ----residuals-rxpredict-------------------------------------------------
airline.xdf <- file.path(output.path, "airline.xdf")
rxPredict(modelObject = model,
          data = inADS,
          outData = airline.xdf,
          writeModelVars = TRUE,
          computeResiduals = TRUE,
          overwrite = TRUE)
rxGetVarInfo(airline.xdf)

## ----residuals-rxpredict-info--------------------------------------------
rxGetInfo(airline.xdf, getVarInfo = TRUE, numRows=5)

## ----residuals-rxpredict-hist, fig.width = 14----------------------------
rxHistogram(formula = ~ ArrDelay_Resid, data = airline.xdf)

## ----residuals-rxpredict-hist-zoom, fig.width = 14-----------------------
rxHistogram(formula = ~ ArrDelay_Resid, 
            data = airline.xdf, 
            numBreaks = 100, startVal = -100, endVal = 100)

## ------------------------------------------------------------------------
bankXDF <- file.path(data.path,"BankXDF.xdf")
rxGetInfo(bankXDF, getVarInfo = TRUE, numRows=6)

## ----stdErr-NoCovCoef, eval=FALSE----------------------------------------
#  ## This will fail!
#  rxPredict(modelObject = model,
#            data = inADS,
#            outData = airline.xdf,
#            writeModelVars = TRUE,
#            computeStdErrors = TRUE,
#            computeResiduals = TRUE,
#            overwrite = TRUE)

## ----reCompute-Model-----------------------------------------------------
model <- rxLinMod(ArrDelay ~ DayOfWeek + F(CRSDepTime), data = inADS, covCoef = TRUE)
model$covCoef

## ----Compute-StdErrs-----------------------------------------------------
rxPredict(modelObject = model,
          data = airline.xdf,
          outData = airline.xdf,
          computeStdErrors = TRUE,
          overwrite=TRUE)
rxGetVarInfo(airline.xdf)

## ----Compute-ConfIntervals-----------------------------------------------
rxPredict(modelObject = model,
          data = airline.xdf,
          outData = airline.xdf,
          computeStdErrors = TRUE,
          interval = "confidence",
          overwrite = TRUE)
rxGetVarInfo(airline.xdf)

## ----Compute-PredIntervals-----------------------------------------------
rxPredict(modelObject = model,
          data = airline.xdf,
          outData = airline.xdf,
          computeStdErrors = TRUE,
          interval = "prediction",
          intervalVarNames = c("ArrDelay_PredInt_Lower","ArrDelay_PredInt_Upper"),
          overwrite = TRUE)
rxGetVarInfo(airline.xdf)

## ----createDataFrame-----------------------------------------------------
daylvls <- rxGetVarInfo(airline.xdf, varsToKeep = "DayOfWeek")[["DayOfWeek"]]$levels
times2use <- seq(0.5, 23.5, by = 1)
internalAirDf <- data.frame(
  DayOfWeek = gl( length(daylvls), k = length(times2use), labels = daylvls),
  CRSDepTime = times2use
    )

## ----createPredictionsDataFrame------------------------------------------
internalPredictions <- rxPredict(model, 
                                 data = internalAirDf, 
                                 writeModelVars = TRUE,
                                 computeStdErrors = TRUE,
                                 interval = "confidence")

## ----createPredictionsDataFrame-plot1------------------------------------
library(lattice)
rxLinePlot( ArrDelay_Pred ~ CRSDepTime, 
            data = internalPredictions,
            group = DayOfWeek,
            auto.key = list(space = "right", lines = TRUE, points = FALSE)
            )

## ----plotDataFrame-plot, ref.label="plotDataFrame-src", eval = TRUE, purl = TRUE, echo = FALSE, results = 'hide', message=FALSE, resize.width = "0.9\\textwidth", resize.height = "0.45\\textwidth"----
library(lattice)
rxLinePlot( ArrDelay_Pred ~ CRSDepTime | DayOfWeek, 
            subscripts = TRUE,
            curUpper = data$ArrDelay_Upper,
            curLower = data$ArrDelay_Lower,
            panel = function(x, y, subscripts, curUpper, curLower, ...){
              upper=curUpper[subscripts]
              lower=curLower[subscripts]
              panel.polygon(c(x,rev(x)),c(upper,rev(lower)),border = NA, col = "gray40")
              panel.xyplot(x, y, ...)
            },
            data = internalPredictions
            )

## ----ggplot, resize.width = "0.9\\textwidth", fig.width = 9--------------
library(ggplot2)
ggplot(internalPredictions, aes(x = CRSDepTime, y = ArrDelay_Pred, ymax = ArrDelay_Upper, ymin = ArrDelay_Lower)) + facet_grid(. ~ DayOfWeek) + geom_ribbon(fill = "gray40", alpha = 0.5) + geom_line(aes(col = ArrDelay_Pred), data = internalPredictions, size = 1.5)

## ----training-data-var---------------------------------------------------
# Construct a variable to identify training data
set.seed(100)
rxDataStep(inData = airline.xdf,
           outFile = airline.xdf,
           transforms = list(
             TrainValidate = factor(
               ifelse(rbinom(length(DayOfWeek), size=1, prob=0.8), "train", "validate")
               )
             ),
           overwrite = TRUE)

## ----getinfo-newtraintest------------------------------------------------
rxGetVarInfo(airline.xdf)

## ----residuals-rxpredict-hist-TV-----------------------------------------
rxHistogram(formula = ~ TrainValidate, data = airline.xdf)

## ----airline-train-test--------------------------------------------------
# Build a training data set
splitDS <- rxSplit(inData = airline.xdf, 
        outFilesBase=file.path(output.path, "airline"), 
        splitByFactor="TrainValidate",
        overwrite = TRUE
        )

## ----rxSplitInfo---------------------------------------------------------
splitDS
train <- splitDS[[1]]
validate <- splitDS[[2]]

## ----airline-train-model-------------------------------------------------
# Build a model on the training data
model <- rxLinMod(formula = ArrDelay ~ DayOfWeek + F(CRSDepTime), 
                  data = train)

## ----summarize-train-model-----------------------------------------------
summary(model)

## ----train-test-residuals------------------------------------------------
# use predict function to retrieve residuals from model object
rxPredict(modelObject = model,
          data = validate, 
          outData = validate,
          computeResiduals = TRUE,
          predVarNames = "ArrDelay_PredOutOfSample",
          overwrite = TRUE)

## ----OutOfSamplePredInfo-------------------------------------------------
rxGetInfo(validate, getVarInfo=TRUE, numRows = 5)

## ----cormat-pred---------------------------------------------------------
# correlation matrix
rxCor(formula = ~ArrDelay_PredOutOfSample + ArrDelay, data = validate)

## ----genKLevels----------------------------------------------------------
k = 10;
rxDataStep(inData = airline.xdf,
           outFile = airline.xdf,
           transforms = list(
             kSplits = factor(sample(LETTERS[1:k], size = .rxNumRows, replace = TRUE))
             ),
           transformObjects = list(LETTERS = LETTERS, k = k),
           append = "rows",
           overwrite = TRUE)

## ----plotKHist-----------------------------------------------------------
rxHistogram(~ kSplits, data = airline.xdf)

## ----kSplits-------------------------------------------------------------
kSplits <- rxSplit(inData = airline.xdf,
             outFilesBase = file.path(output.path, "airline"),
             splitByFactor = "kSplits", overwrite = TRUE)

## ----WriteWrapperHoldOut-------------------------------------------------
myLinModWrapper <- function(holdoutlevel, splitFiles){
    ## first, estimate the model on all data point but those including holdoutlevel
    print(holdoutlevel)
    myMod <- rxLinMod(ArrDelay ~ DayOfWeek + F(CRSDepTime), data = airline.xdf,
                      rowSelection = kSplits != holdout,
                      transformObjects = list(holdout = holdoutlevel),
                      )
    ## Then, generate predictions
    curHoldOut <- grep(paste("kSplits",holdoutlevel,"xdf", sep ="."), names(splitFiles), value=TRUE)
    rxPredict(myMod, data = splitFiles[[curHoldOut]], overwrite = TRUE, predVarNames = "ArrDelay_kFold_Pred")
    ## Generate cross-validation metric for this hold out
    curCor <- rxCor(~ ArrDelay + ArrDelay_kFold_Pred, data = curHoldOut)
    return(curCor["ArrDelay","ArrDelay_kFold_Pred"])
}

## ----runkFold------------------------------------------------------------
allCors <- vapply(LETTERS[1:k], myLinModWrapper, splitFiles = kSplits, FUN.VALUE = numeric(1))

## ----viewkFoldPerformance-src, resize.width = NULL, resize.height = NULL, out.width = "0.9\\textwidth", out.height = "0.45\\textwidth", eval = FALSE, echo = TRUE----
#  dotplot(allCors, cex = 2, scales = list(y = list(cex = 1), x = list(cex = 1.5)), xlab = list("Out-of-Sample Correlation", cex = 2), ylab = list("Hold out Sample", cex = 2), panel = function(x,y,...){
#    panel.dotplot(x,y,...)
#    panel.abline( v = mean(x), lty = 2, lwd = 3)
#  })

## ----viewkFoldPerformance-plot, ref.label = "viewkFoldPerformance-src", resize.width = "0.9\\textwidth", eval = TRUE, echo = FALSE----
dotplot(allCors, cex = 2, scales = list(y = list(cex = 1), x = list(cex = 1.5)), xlab = list("Out-of-Sample Correlation", cex = 2), ylab = list("Hold out Sample", cex = 2), panel = function(x,y,...){
  panel.dotplot(x,y,...)
  panel.abline( v = mean(x), lty = 2, lwd = 3)
})

