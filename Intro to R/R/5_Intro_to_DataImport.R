## ----dirsetup------------------------------------------------------------
dataPath <- "../data"
outdir <- "../output"
if(!file.exists(outdir)) dir.create(outdir)

## ----import-scan, eval=FALSE---------------------------------------------
#  help(scan)

## ----import-google-data--------------------------------------------------
url <- file.path(dataPath,"google_stock_data.csv")
GOOG.data <- read.csv(url)
str(GOOG.data)


## ----import-scan-url-----------------------------------------------------
GOOG.data <- scan(url, skip = 1, sep = ",", what = list(Date = "", Open = 0, High = 0, Low = 0, Close = 0, Volume = 0, Adj.Close = 0))
GOOG.data <- as.data.frame(GOOG.data)

## ----import-write-table--------------------------------------------------
write.table(GOOG.data,file=file.path(outdir,'google_data.txt'))

