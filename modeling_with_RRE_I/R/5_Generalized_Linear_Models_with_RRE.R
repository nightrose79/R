## ----dirconfig-----------------------------------------------------------
## dir config
big.data.path <- Sys.getenv("ACADEMYR_BIG_DATA_PATH")
if(big.data.path == "") {
  Sys.setenv(ACADEMYR_BIG_DATA_PATH="/usr/share/BigData")
  big.data.path <- Sys.getenv("ACADEMYR_BIG_DATA_PATH")
}
data.path <- "../data"
output.path <- "../output/xdf"
if(!file.exists(output.path)) dir.create(output.path,recursive=TRUE)
sample.data.dir <- rxOptions()[["sampleDataDir"]]

## ----glmUsage------------------------------------------------------------
args(rxGlm)

## ----census-transform-subset, eval=TRUE----------------------------------
census2000 <- file.path(big.data.path, "Census5PCT2000.xdf")
census_insurance <- file.path(output.path, "Census5PCT2000_insurance.xdf")
if(!file.exists(census_insurance)){
  rxDataStep(inData = census2000, outFile = census_insurance,
             rowSelection = (related == 'Head/Householder') & (age > 20) & (age < 90),
             varsToKeep = c("propinsr", "age", "sex", "region", "perwt"),
             blocksPerRead = 1, 
             overwrite = TRUE)
}

## ----check-subset--------------------------------------------------------
rxGetVarInfo(census_insurance)

## ----census-summary-region-----------------------------------------------
p <- rxSummary(~region, data = census_insurance)
print(p, head=FALSE)

## ----census-hist-propinsr, resize.width = '0.9\\textwidth', resize.width = '0.45\\textwidth', fig.align="center"----
rxHistogram(~propinsr, data = census_insurance, pweights = "perwt")

## ----hist-again, ref.label="census-hist-propinsr", echo = FALSE----------
rxHistogram(~propinsr, data = census_insurance, pweights = "perwt")

## ----census-model-propinsr-----------------------------------------------
propinGlm <- rxGlm(propinsr~sex + F(age) + region,
                   pweights = "perwt", 
                   data = census_insurance,
                   family = rxTweedie(var.power = 1.5),
                   dropFirst = TRUE)

p <- summary(propinGlm)
print(p, head=FALSE)

## ----mort-data-setup-----------------------------------------------------
mortgages <- file.path(sample.data.dir, "mortDefaultSmall.xdf")

## ----census-model-propinsr-newdata-1-------------------------------------
varInfo <- rxGetVarInfo(census_insurance)
regionLabels <- varInfo$region$levels
ages <- 21:89
regionIndices <- c(grep("South Atlantic",regionLabels), grep("Middle Atlantic", regionLabels))
predData <- data.frame(
  age = rep(ages, times=4),
  sex = gl(n=2, k=length(ages), 
           length=length(ages)*2*2,
           labels=c("Male","Female")),
  region = factor(rep(regionIndices, each=length(ages)*2), 
                  levels = 1:length(regionLabels), 
                  labels = regionLabels)
  )

## ----census-model-propinsr-newdata-2-------------------------------------
head(predData,3)
tail(predData,3)

## ----census-model-propinsr-predictions-----------------------------------
outData <- rxPredict(propinGlm, data = predData)
head(outData)

## ----census-model-propinsr-predictions-plot, out.height=3, out.width=3, echo=FALSE----
predData$predicted_response <- outData$propinsr_Pred
rxLinePlot( predicted_response ~age | region, group = sex, data = predData,
            title = NA,
            xlab = list("Age of Head of Household", cex=0.5),
            ylab = list("Predicted Costs", cex=0.5)
            )

## ----argsPredict2--------------------------------------------------------
args(rxPredict)

## ----census-model-propinsr-predictions-link------------------------------
outDataLink <- rxPredict(propinGlm, data = predData, type='link')
head(outDataLink)

## ----census-model-propinsr-predictions-plot-link, out.height=3, out.width=3, echo=FALSE----
predData$predicted_link <- outDataLink$propinsr_Pred
rxLinePlot( predicted_link ~age | region, group = sex, data = predData,
            title = NA,
            xlab = list("Age of Head of Household", cex=0.5),
            ylab = list("Linear Predictor for Costs", cex=0.5)
            )

