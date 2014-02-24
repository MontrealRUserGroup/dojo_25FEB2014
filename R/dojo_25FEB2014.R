
## ----echo=FALSE----------------------------------------------------------
  setwd("~/Documents/R/dojo_25FEB2014/")


## ----warning=FALSE,cache=TRUE, tidy=TRUE---------------------------------
require(tm)
#Tell R to only use one core (if you only have two)
options(mc.cores=1)

#Load Reuters text into a corpus
reut21578 <- system.file("texts", "crude", package = "tm")
reut21578.corpus <- Corpus(DirSource(reut21578),
                           readerControl = list(reader = readReut21578XMLasPlain))


## ----warning=FALSE,cache=TRUE, tidy=TRUE---------------------------------
reut21578.corpus <- tm_map(reut21578.corpus, removePunctuation)
reut21578.corpus <- tm_map(reut21578.corpus, tolower)
reut21578.corpus <- tm_map(reut21578.corpus,
  function(x){
    removeWords(x,stopwords("english"))
    })


## ----warning=FALSE,cache=TRUE, tidy=TRUE---------------------------------
reut21578.corpus <- tm_map(reut21578.corpus, stemDocument, language = "english")
reut21578.matrix <- as.matrix(TermDocumentMatrix(reut21578.corpus,
  control=list(bounds=list(global = c(5,Inf)))))


## ----warning=FALSE,cache=TRUE, tidy=TRUE---------------------------------
head(reut21578.matrix[,1:5])


## ----warning=FALSE,cache=TRUE, tidy=TRUE---------------------------------
fit <- kmeans(t(reut21578.matrix),5)
head(fit$cluster)


## ----warning=FALSE,error=FALSE,cache=TRUE, tidy=TRUE---------------------
require(plyr)
options(repos=structure(c(CRAN="http://cran.rstudio.com/")))
pkgs <- unname(available.packages()[, 1])[1:100]
desc_urls <- paste("http://cran.r-project.org/web/packages/", pkgs, "/DESCRIPTION", sep = "")


## ----warning=FALSE,error=FALSE,cache=TRUE, tidy=TRUE---------------------
require(plyr)
test.url <- lapply(desc_urls, function(x){ 
  try.text <- NULL
  try.test <- try(read.dcf(url(x)),silent = T)
  return(class(try.test)!="try-error")})
desc_urls <- desc_urls[unlist(test.url)]
desc <- ldply(desc_urls, function(x)read.dcf(url(x)))


## ----warning=FALSE,error=FALSE,cache=TRUE, tidy=TRUE---------------------
require(plyr)
desc <- ldply(desc_urls, function(x)read.dcf(url(x)))


## ----echo=FALSE----------------------------------------------------------
  setwd("~/Documents/R/dojo_25FEB2014/")
  load(file="./Data/package_corpus.RData")


## ----warning=FALSE,error=FALSE,cache=TRUE, tidy=TRUE---------------------
package.corpus <- Corpus(DataframeSource(data.frame(desc$Description)))
package.matrix <- as.matrix(TermDocumentMatrix(package.corpus,
  control=list(bounds=list(global = c(5,Inf)))))


## ----warning=FALSE,error=FALSE,cache=TRUE, tidy=TRUE---------------------
head(package.matrix[,1:5])


## ----warning=FALSE,error=FALSE,cache=TRUE, tidy=TRUE---------------------
install.packages("rpubmed")
require(rpubmed)


## ----warning=FALSE,error=FALSE,cache=TRUE, tidy=TRUE---------------------
require(knitr)
purl("~/Documents/R/dojo_25FEB2014/Presentation/dojo_25FEB2014.Rpres",
     "~/Documents/R/dojo_25FEB2014/R/dojo_25FEB2014.R",
     quiet=T)


