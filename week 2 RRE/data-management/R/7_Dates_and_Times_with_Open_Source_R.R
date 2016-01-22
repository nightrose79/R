## ----coercion-example-Dates----------------------------------------------
SampleDate1 <- as.Date("2010-07-31")
SampleDate2 <- as.Date("08 / 01 / 2012", format = "%m / %d / %Y")

## ----, eval = FALSE------------------------------------------------------
#  help(as.Date)
#  help(strptime)

## ----date-calculations-1-------------------------------------------------
diff <- SampleDate2 - SampleDate1
diffWeeks <- difftime(SampleDate2, SampleDate1, units = "weeks")

## ----r-date-read---------------------------------------------------------
dataPath <- "../data"
Dates101Csv <- file.path(dataPath, "101Dates.csv")
Dates101 <- read.csv(Dates101Csv, header = TRUE, as.is = TRUE)$Date
Dates101 <- as.Date(Dates101, format = "%m/%d/%Y")
head(Dates101)

## ----date-summary--------------------------------------------------------
summary(Dates101)

## ----date-calculations-2-------------------------------------------------
dateDiff <- diff(Dates101)
head(dateDiff)

## ----date-sequence-------------------------------------------------------
DateSequence1 <- seq(SampleDate2, length = 50, by = "week")
DateSequence2 <- seq(SampleDate2, length = 50, by = "year")
DateSequence3 <- seq(SampleDate2, length = 50, by = "2 years")

## ----integer-representation----------------------------------------------
unclass(SampleDate1)

## ----posixct-manipulate--------------------------------------------------
SampleDate1 <- as.POSIXct("2014-02-20 23:50:26")
SampleDate2 <- as.POSIXct("02 202012 12:15:26", format = "%m %d%Y %H:%M:%S")
SampleDate3 <- as.POSIXct("05112000 02:16:10", format = "%m%d%Y %H:%M:%S", tz = "EST")

## ----posixct-compute-----------------------------------------------------
SampleDate2 <= SampleDate3
SampleDate1 + 100
diff <- SampleDate1 - SampleDate2

## ----system-time-posixct-------------------------------------------------
class(Sys.time())
class(Sys.Date())

## ----difftime-posixct----------------------------------------------------
difftime(SampleDate1, SampleDate2, tz = "GMT",  units = "secs")

## ----posixlt-example-----------------------------------------------------
as.POSIXlt("1999-02-28 11:13:25")
SampleDate2 <- as.POSIXlt("08 / 01 / 2012 >>> 10>10>10", format = "%m / %d / %Y >>> %H>%M>%S")

## ----posixlt-components--------------------------------------------------
names(unclass(SampleDate2))
SampleDate2$sec

## ----trunc-example-------------------------------------------------------
trunc(SampleDate3, "day")
trunc(SampleDate3, "mins")

## ----load-chron----------------------------------------------------------
library(chron)
## library(help = chron)

## ----chron-manipulate, eval = FALSE--------------------------------------
#  as.chron("2014-02-20 23:50:26")
#  class(SampleDate1)
#  dates(SampleDate1)

## ----use-lubridate-------------------------------------------------------
library(lubridate)

## ----read-dates-lubridate------------------------------------------------
lubri_read1 <- ymd_hms("2010-02-24 02:45:56")
(lubri_read2 <- mdy_hm("08/13/12 09:23"))
lubri_read3 <- ydm_hm("2014-29-01 5:00am")
(lubri_read4 <- dmy("13082012"))

## ----extract-reassign-lubridate------------------------------------------
year(lubri_read1) 
week(lubri_read2) 
wday(lubri_read1, label = TRUE)

## ----extract-lubridate-2-------------------------------------------------
tz(lubri_read1)
second(lubri_read1)
minute(lubri_read2)

## ----date-time-instant---------------------------------------------------
is.instant(lubri_read2)
is.interval(lubri_read2)

## ----different-timezone--------------------------------------------------
with_tz(lubri_read1, "America/New_York")
force_tz(lubri_read2, "America/Los_Angeles")

## ----lubridate-manipulate------------------------------------------------
round_date(lubri_read1, "minute")
round_date(lubri_read2, "day")

## ----lubridate-system----------------------------------------------------
today()
now()

## ----lubridate_interval--------------------------------------------------
(span34 <- new_interval(lubri_read4, lubri_read3))
(span23 <- lubri_read2 %--% lubri_read3)

## ----interval-boundary---------------------------------------------------
int_start(span34)
int_end(span23)

## ----interval-length-----------------------------------------------------
int_length(span34)

## ----interval-shift------------------------------------------------------
int_shift(span34, dyears(3))

## ----instant_inside_interval---------------------------------------------
lubri_read1 %within% span34

## ----interval-overlap----------------------------------------------------
interval1 <-  new_interval(ymd_hm("2014-08-23 06:03"), ymd_hm("2014-08-25 11:02"))
int_overlaps(interval1, span34)
int_overlaps(span23, span34)

## ----lubridate-duration--------------------------------------------------
(FiftyMins <- dminutes(50))
(ThreeYears <- dyears(3))
(IntervalDuration <- as.duration(interval1))

## ----lubridate_computations----------------------------------------------
lubri_read2 - FiftyMins
ThreeYears + dyears(10)
IntervalDuration / as.duration(span34)

## ----lubridate-period----------------------------------------------------
(FourHours <- hours(4))
(TwoWeeks <- weeks(2))

## ----lubridate-period-compute--------------------------------------------
FourHours + TwoWeeks

