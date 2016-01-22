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
sample.data.dir <- rxGetOption("sampleDataDir")

## ----plotlogistic, echo=FALSE, out.height=2, out.width=4, fig.height=2, fig.width=4, cache=FALSE, fig.align = "center"----
p <- seq(0.01,0.99,by=0.01)
par(mar=c(5,4,0,0)+0.1)
plot(x=log(p/(1-p)),y=p,type='l',lwd=3, las=1)

## ----rxLogitargs---------------------------------------------------------
args(rxLogit)

## ----rxLogit-exercise, eval=TRUE, tidy=FALSE-----------------------------
mortgages <- file.path(sample.data.dir, "mortDefaultSmall.xdf")
rxGetVarInfo(mortgages)

## ----setFormula----------------------------------------------------------
myformula <- formula(default~F(year) + ccDebt + creditScore + houseAge + yearsEmploy)

## ----rxPredictargs-------------------------------------------------------
args(rxPredict)

## ----make-new_mort-------------------------------------------------------
new_mortgages <- data.frame(year = rep(c(2006, 2009), each = 4), 
                   ccDebt = rep(c(1000, 10000), 4), 
                   creditScore = rep(c(700, 800), 4), 
                   houseAge = rep(c(1, 5, 10, 20), 2),
                   yearsEmploy = rep(7, 8))
str(new_mortgages)

## ----argsPredict2--------------------------------------------------------
args(rxPredict)

## ----check-results-------------------------------------------------------
resultsObj <- file.path(data.path, "logistic_regression_with_rre_solution_objects.RData")
load(resultsObj)

## ----mortgages-logistic-model-pred-link-2--------------------------------
library(ggplot2)
vis.dat <- data.frame(responsePred = new_predictions$default_Pred,
                      linkPred = new_predictions_link$default_Pred)
distribution.dat <- data.frame(allx = allx <- with(vis.dat, seq(min(linkPred), max(linkPred), by = 0.05)),
                               ally = ally <- plogis(allx))
ggplot(data = vis.dat, mapping = aes(x = linkPred, y = responsePred)) + 
  geom_line(data = distribution.dat, aes(x = allx, y = ally, col = ally)) + 
  geom_point(size = 4, shape = 2)+ scale_shape(solid = FALSE)

## ----oversampledversion--------------------------------------------------
logitModelOS <- rxLogit(formula = myformula,
                        fweights = "Fweight",
                        transforms = list(Fweight = ifelse(default == 1, 10, 1)),
                       data = mortgages)
summary(logitModelOS)

## ----UnderSample, tidy = FALSE-------------------------------------------
(pOutFull <- rxSummary( ~ default, data = mortgages)$sDataFrame$Mean)
myNewmort <- file.path(output.path, "myMort.xdf")
set.seed(100)
rxDataStep(inData = mortgages, outFile = myNewmort,
           transforms = list(inSubSample = ifelse( default == 1 | runif(.rxNumRows) < pOutFull*4,1,0)),
           transformObjects = list(pOutFull = pOutFull),
           overwrite = TRUE)

## ----createPweights------------------------------------------------------
pOutSub <- rxSummary( ~ default, data = myNewmort, rowSelection = inSubSample == 1)$sDataFrame$Mean
(fullDatP <- c(1 - pOutFull, pOutFull))
(subDatP <- c(1 - pOutSub, pOutSub))
logitModelUS <- rxLogit(formula = myformula,
                        pweights = "Pweight",
                        rowSelection = inSubSample == 1,
                        transforms = list(Pweight = fullProp[default + 1] / subProp[default + 1]),
                        transformObjects = list(fullProp = fullDatP, subProp = subDatP),
                       data = myNewmort)

## ----summarizeUnderSampledModel------------------------------------------
summary(logitModelUS)

