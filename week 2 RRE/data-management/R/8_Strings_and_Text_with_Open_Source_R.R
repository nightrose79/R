## ----know-more-about-string-functions, eval = FALSE----------------------
#  help.search("character", package = "base")
#  help.search("string", package = "base")

## ----load-stringr-package------------------------------------------------
library(stringr)

## ----using-the-input-output----------------------------------------------
SampleData1 <- readLines("http://www.gutenberg.org/files/12345/12345-8.txt",encoding="UTF-8")
head(SampleData1)

## ----using-readLines-alternate-------------------------------------------
SampleData1 <- readLines("http://lib.stat.cmu.edu/datasets/csb/ch1a.dat")
head(SampleData1)

## ----using-readLines-alternate-2-----------------------------------------
SampleData1Descr <- readLines("http://lib.stat.cmu.edu/datasets/csb/ch1a.txt")
head(SampleData1Descr)

## ----using-read-csv------------------------------------------------------
dataPath <- "../data"
SampleData2 <- read.csv(file.path(dataPath,"AppleStockPrice_2014.csv"),
                        header=TRUE,colClasses=rep("character",7))

## ----using-the-write-functions-------------------------------------------
outputPath = "../output"
if(!file.exists(outputPath)) dir.create(outputPath, recursive=TRUE)
writeLines(SampleData1Descr, con = file.path(outputPath,"description.txt"), sep = "\n")

## ----using-paste---------------------------------------------------------
paste("part 1", "part 2")
paste("part 1", "part 2", sep = ">>>")
paste0("part 1", "part 2")

## ----splitting-strings---------------------------------------------------
strsplit("This is an example string", split = " ")

## ----num-of-charaters----------------------------------------------------
curstr <- "ZyXwVuT"
nchar(curstr)
str_length(curstr)

## ----num-of-occurences, tidy=FALSE---------------------------------------
library(tau)
StringSample <- "This is an example text that will be used in the training. 
The objective is to count the number of times the individual words appear in the text."
(A <- textcnt(x = StringSample, n = 1, method = "string"))

## ----substring-position--------------------------------------------------
curstr <- "ABCDEABCI"
(PosOf1stMatch <- regexpr("ABC", curstr))

## ----substring-position-all----------------------------------------------
(PosOfAllMatches <- gregexpr("ABC", curstr))

## ----substring-position-2------------------------------------------------
(PosOf1stMatch <- str_locate(curstr,"ABC"))
(PosOfAllMatches <- str_locate_all(curstr, "ABC"))

## ----extract-substring---------------------------------------------------
substr("my sample string", start = 2, stop = 7)
str_sub("second sample string", start = 10, end = -3)

## ----substitute-string---------------------------------------------------
SampleText <- "abc def ghi"
sub(" ", replacement = "", SampleText)

## ----global-substitute-string--------------------------------------------
gsub(" ", replacement = "", SampleText)

## ----changing-cases------------------------------------------------------
tolower("Change aLL to Lower CasE")
toupper("cHange All to uPPer case")

## ----capitalize----------------------------------------------------------
library(Hmisc)
capitalize("capitalize the first word only")

## ----dat2capitalize-create-----------------------------------------------
dat2capitalize <- "MAKE tHIs tEXt upPEr CASE for ONLY tHE fIRST LETTER of eACH Word."

## ----remove-white-trailing-leading-spaces--------------------------------
(SampleString <- "  the quick brown fox jumps ")
str_trim(SampleString)

## ----side-arg-str_trim---------------------------------------------------
str_trim(SampleString, side = "left")
str_trim(SampleString, side = "right")

## ----string-comparision--------------------------------------------------
SampleString == "  the quick brown fox jumps "
"  the quick brown fox jumpS " == SampleString

