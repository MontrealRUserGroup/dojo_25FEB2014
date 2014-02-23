
## ----warning=FALSE,cache=T-----------------------------------------------
require(tm)
#Tell R to only use one core (if you only have two)
options(mc.cores=1)

#Load Reuters text into a corpus
reut21578 <- system.file("texts", "crude", package = "tm")
reut21578.corpus <- Corpus(DirSource(reut21578),
                           readerControl = list(reader = readReut21578XMLasPlain))


## ----warning=FALSE,cache=TRUE,-------------------------------------------
reut21578.corpus <- tm_map(reut21578.corpus, removePunctuation)
reut21578.corpus <- tm_map(reut21578.corpus, tolower)
reut21578.corpus <- tm_map(reut21578.corpus,
  function(x){
    removeWords(x,stopwords("english"))
    })


## ----warning=FALSE,cache=T-----------------------------------------------
reut21578.corpus <- tm_map(reut21578.corpus, stemDocument, language = "english")
reut21578.matrix <- as.matrix(TermDocumentMatrix(reut21578.corpus,
  control=list(bounds=list(global = c(5,Inf)))))


## ----warning=FALSE,cache=T-----------------------------------------------
head(reut21578.matrix[,1:5])


## ----warning=FALSE,cache=T-----------------------------------------------
fit <- kmeans(t(reut21578.matrix),5)
head(fit$cluster)


## ----warning=FALSE,cache=T-----------------------------------------------
require(plyr)
options(repos=structure(c(CRAN="http://cran.rstudio.com/")))
pkgs <- unname(available.packages()[, 1])[1:100]
desc_urls <- paste("http://cran.r-project.org/web/packages/", pkgs, "/DESCRIPTION", sep = "")


## ----warning=FALSE,cache=T-----------------------------------------------
test.url <- lapply(desc_urls, function(x){ 
  try.text <- NULL
  try.test <- try(read.dcf(url(x)))
  return(class(try.test)!="try-error")})
desc_urls <- desc_urls[unlist(test.url)]
desc <- ldply(desc_urls, function(x)read.dcf(url(x)))


## ----warning=FALSE,cache=T-----------------------------------------------
package.corpus <- Corpus(DataframeSource(data.frame(desc$Description)))
package.matrix <- as.matrix(TermDocumentMatrix(package.corpus,
  control=list(bounds=list(global = c(5,Inf)))))


## ----warning=FALSE,cache=T-----------------------------------------------
head(package.matrix[,1:5])


## ----,cache=T------------------------------------------------------------
install.packages("rpubmed")
require(rpubmed)


## ----,warning=FALSE,error=FALSE,cache=T----------------------------------
require(knitr)
purl("./Presentation/dojo_25FEB2014.Rpres", "./R/dojo_25FEB2014.R")


