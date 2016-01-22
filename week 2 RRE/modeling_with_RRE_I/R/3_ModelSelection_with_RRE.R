## ----folder-config-------------------------------------------------------
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

## ------------------------------------------------------------------------
inADS <- RxXdfData(file.path(sample.data.dir, "AirlineDemoSmall.xdf"))
rxGetInfo(inADS, getVarInfo = TRUE)

## ----rxLinMod-args-------------------------------------------------------
args(rxLinMod)

## ----mainEffects---------------------------------------------------------
model.main <- rxLinMod(ArrDelay ~ DayOfWeek + F(CRSDepTime), data =inADS)
length(coef(model.main))
summary(model.main)

## ----interactiveEffects--------------------------------------------------
model.interaction <- rxLinMod(ArrDelay ~ DayOfWeek * F(CRSDepTime), data =inADS, dropMain = FALSE)
length(coef(model.interaction))
summary(model.interaction)

## ----getAIC--------------------------------------------------------------
model.main$aic
model.interaction$aic

## ----compareAIC----------------------------------------------------------
exp((model.interaction$aic - model.main$aic)/2)

## ----computeF------------------------------------------------------------
Df <- c(model.interaction$df[1] - model.main$df[1], model.interaction$df[2])
SS <- c((model.main$residual.squares - model.interaction$residual.squares), model.interaction$residual.squares)
MS <- SS / Df
fVal <- c(MS[-length(MS)]/MS[length(MS)],NA)
pVal <- pf(fVal, df1 = Df[-length(Df)], df2 = Df[length(Df)], lower = FALSE)
anova.tbl <- data.frame(  Df,  SS,  MS, fVal, pVal)
dimnames(anova.tbl)<- list(
  c("modelDiff","Residuals"),
  c("Df", "Sum Sq", "Mean Sq", "F value", "Pr(>F)"))
stats:::print.anova(anova.tbl)

## ----argsLinMod2---------------------------------------------------------
args(rxLinMod)

## ----argsStepControl-----------------------------------------------------
args(rxStepControl)

## ----forwardMethod-------------------------------------------------------
myStepControl <- rxStepControl(method = "stepwise", 
                               scope = list(lower = ~ DayOfWeek + F(CRSDepTime),
                                            upper = ~ DayOfWeek * F(CRSDepTime)
                                            ),
                               test = "F"
                               )
model.step1 <- rxLinMod(ArrDelay ~ DayOfWeek + F(CRSDepTime) , 
                          variableSelection = myStepControl,
                          data =inADS, 
                          dropMain = FALSE)

## ----firstAnva-----------------------------------------------------------
model.step1$anova

## ----outputFromCall------------------------------------------------------
summary(model.step1)

## ----newBiggerData-------------------------------------------------------
bigger.ADS <- file.path(big.data.path,"AirOnTime7Pct.xdf")
rxGetInfo(bigger.ADS,getVarInfo=TRUE)

## ----moreComplexModel----------------------------------------------------
mySel <- rxStepControl(method="stepwise",
                       scope = ~ DayOfWeek * F(CRSDepTime) + DepDelay + TaxiOut + UniqueCarrier + Distance
                       )
model.complex1 <- rxLinMod(ArrDelay ~ 1, 
                          data = bigger.ADS,
                          variableSelection = mySel)
summary(model.complex1)

## ----stepwise-steps------------------------------------------------------
model.complex1$anova

## ----stepwithSigCrit-----------------------------------------------------
mySel$stepCriterion = "SigLevel"
model.complex2 <- rxLinMod(ArrDelay ~ 1, 
                          data = bigger.ADS,
                          variableSelection = mySel)

## ----diffCriteria--------------------------------------------------------
formula(model.complex1)
formula(model.complex2)

## ----bankXDFreminder-----------------------------------------------------
bankXDF <- RxXdfData(file.path(data.path, "BankXDF.xdf"))
rxGetVarNames(bankXDF)

