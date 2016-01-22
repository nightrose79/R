## ----manip-merge-1-------------------------------------------------------
richest.nations <- read.csv("http://opendata.socrata.com/views/7nh3-7ib4/rows.csv?accessType=DOWNLOAD", header = TRUE)

richest.nations$Countries<- gsub(":", "",richest.nations$Countries)
richest.nations$Amount<- gsub(" per capita", "",richest.nations$Amount)
richest.nations$Amount<- gsub(",", "",richest.nations$Amount)
richest.nations$Amount<- sapply(richest.nations$Amount, function(x) substr(x, 2, nchar(x)))
richest.nations$Amount<- as.numeric(richest.nations$Amount)
head(richest.nations)

## ----manip-merge-2-------------------------------------------------------
alcohol.consumption <- read.csv("http://opendata.socrata.com/views/hj43-2bpj/rows.csv?accessType=DOWNLOAD", header = TRUE)
dim(alcohol.consumption)
head(alcohol.consumption)

## ----manip-merge-3-------------------------------------------------------
new.data.frame <- merge(x = richest.nations, y = alcohol.consumption, by.x = "Countries", by.y = "Location", all = FALSE)
dim(new.data.frame)
head(new.data.frame)

## ----manip-merge-4-------------------------------------------------------
new.data.frame.2 <- merge(x = richest.nations, y = alcohol.consumption, by.x = "Countries", by.y = "Location", all = TRUE)
dim(new.data.frame.2)

