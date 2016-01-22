## ----readData------------------------------------------------------------
library(dplyr)
dataPath <- "../data"
bankCSV <- file.path(dataPath,"bank-full.csv")
bankData <- read.csv(bankCSV, sep = ";")

## ----df------------------------------------------------------------------
(bankData <- tbl_df(bankData))

## ----filter1-------------------------------------------------------------
filter(bankData, default == 'yes')

## ----filter2-------------------------------------------------------------
filter(bankData, balance < 1000)

## ----filter3-------------------------------------------------------------
filter(bankData, month %in% c("april", "may", "jun"), 
       default == "yes")

## ----slice---------------------------------------------------------------
slice(bankData, 5:10)

## ----select1-------------------------------------------------------------
select(bankData, age, job, default, balance, housing)

## ----select2-------------------------------------------------------------
select(bankData, default:duration, contains("p"))

## ----rename1-select------------------------------------------------------
select(bankData, bought_option=y)

## ----rename1-------------------------------------------------------------
rename(bankData, bought_option=y)

## ----arrange1------------------------------------------------------------
arrange(bankData, job, default)

## ----arrange2------------------------------------------------------------
arrange(bankData, balance, default)

## ----arrange3------------------------------------------------------------
arrange(bankData, desc(balance), default)

## ----mutate1-------------------------------------------------------------
mutate(bankData, "DefaultFlag" = ifelse(default == 'yes', 1, 0))

## ----mutate2-------------------------------------------------------------
mutate(bankData, "BalanceByDuration" = balance/duration)

## ----transmute-----------------------------------------------------------
transmute(bankData, "BalanceByDuration" = balance/duration)

## ----args-group_by-------------------------------------------------------
args(group_by)

## ----summarise-----------------------------------------------------------
summarise(group_by(bankData, default), Num = n())

## ----summarise2----------------------------------------------------------
summarise(group_by(bankData, default), Ave.Balance = mean(balance))

## ----summarise3----------------------------------------------------------
summarise(group_by(bankData, default), Ave.Balance = mean(balance), Num = n())

## ----insideout-----------------------------------------------------------
arrange(filter(select(bankData, age, job, education, default), default == 'yes'), job, education, age)

## ----formatinsideout, tidy = FALSE---------------------------------------
arrange(
  filter(
    select(bankData, age, job, education, default), 
    default == 'yes'), 
  job, education, age)

## ----piping, tidy = FALSE------------------------------------------------
bankData %>% 
  select(age, job, education, default) %>%
  filter(default == 'yes') %>%
  arrange(job, education, age)

## ----chaining------------------------------------------------------------
x1 <- rnorm(10)
x2 <- rnorm(10)
sqrt(sum((x1 - x2)^2))
(x1 - x2)^2 %>% sum() %>% sqrt()

## ----groupsum------------------------------------------------------------
bankData %>% group_by(job) %>%
  summarise(Number = n(),
            Average.Balance = mean(balance),
            Number.Defaulted = sum(default == 'yes'),
            Default.Rate = Number.Defaulted/Number)

## ----pipeplot------------------------------------------------------------
library(ggplot2)
bankData %>% 
  filter(job %in% c("management", "technician", "unemployed")) %>%
  group_by(job, marital) %>% 
  summarise(Counts = n() ) %>% 
  ggplot() + 
  geom_bar(aes(x = job, y = Counts, fill = marital),
           stat = 'identity', position = 'dodge')


## ----distinct------------------------------------------------------------
bankData %>% 
  select(job, marital, education, default, housing, loan, contact) %>%
  arrange(job, marital, education, default, housing, loan, contact) %>%
  distinct()

## ----distinctkeys--------------------------------------------------------
bankData %>% 
  select(job, marital, education, default, housing, loan, contact) %>%
  arrange(job, marital, education, default, housing, loan, contact) %>%
  distinct(job, marital, education)

## ----distinctkeys2-------------------------------------------------------
bankData %>% 
  select(job, marital, education, default, housing, loan, contact) %>%
  arrange(job, marital, education, desc(default), desc(housing), desc(loan), desc(contact)) %>%
  distinct(job, marital, education)

## ----helpeach, eval=FALSE------------------------------------------------
#  help(summarise_each)

## ----summarise_each------------------------------------------------------
bankData %>%
  group_by(education) %>%
  summarise_each(funs(mean), balance, duration)

## ----summarise_each2-----------------------------------------------------
bankData %>%
  group_by(education) %>%
  summarise_each(funs(min, mean, max), balance, duration)

## ----mutate_each---------------------------------------------------------
bankData %>% 
  group_by(month) %>% 
  select(balance, duration) %>% 
  mutate_each(funs(half = ./2))

## ----helpers-------------------------------------------------------------
bankData %>% 
  group_by(job, default) %>%
  summarise(education_levels = n_distinct(education))

## ----tally---------------------------------------------------------------
bankData %>% group_by(job) %>%
  tally()

## ----tally2--------------------------------------------------------------
bankData %>% group_by(job) %>%
  summarise(n = n())

## ----count---------------------------------------------------------------
bankData %>% count(job)

## ----rankinfo------------------------------------------------------------
args(rank)

## ----rankexample, tidy = FALSE-------------------------------------------
bankData %>% slice(1:10) %>% 
  transmute(Job = job,
            jobRankAvg = rank(job), 
            jobRankRow = row_number(job), 
            jobRankMin = min_rank(job),
            jobRankDense = dense_rank(job),
            jobRankPerc = percent_rank(job),
            jobRankCume = cume_dist(job))

## ----newdf---------------------------------------------------------------
set.seed(1)
df <- data.frame(
  houseID = rep(1:10, each = 10), 
  year = 1995:2004, 
  price = ifelse(runif(10 * 10) > 0.50, NA, exp(rnorm(10 * 10)))
)
head(df)

## ----do------------------------------------------------------------------
library(xts)
df %>% 
  group_by(houseID) %>% 
  do(na.locf(.))

## ----dotest--------------------------------------------------------------
bankData %>% 
  filter(marital %in% c('married', 'single')) %>% 
  group_by(job) %>% 
  do(tTest = t.test(age ~ marital, data = .)) %>%
  mutate("tTestPVal" = get("p.value",tTest), "tTestStat" = get("statistic", tTest))

## ----remote--------------------------------------------------------------
library(DBI)
library(RSQLite)
outPath <- "../output"
if(!file.exists(outPath)) dir.create(outPath)
bankSQL <- file.path(outPath,"bank.sqlite")
db <- dbConnect(SQLite(), dbname = bankSQL)
dbWriteTable(conn = db, name = "bankfull", value = bankCSV, sep = ";", header = T, overwrite = T)

## ----argsrcsql-----------------------------------------------------------
args(src_sqlite)

## ----dplyr-sqlite--------------------------------------------------------
db.new <- src_sqlite(bankSQL)
mytbl <- tbl(db.new, 'bankfull')
mytbl %>% group_by(job) %>% tally()

## ----setops--------------------------------------------------------------
args(dplyr::intersect)

## ----args-joins, eval=FALSE----------------------------------------------
#  help(join)

