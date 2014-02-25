Coding Dojo
========================================================
author: Etienne Low-Decarie & Vaughn DiMarco
date: 25 Feb 2014
css: my_style.css

Text Mining & Machine Learning
--------------------------------------------------------


Coding Dojo
========================================================

![Coding_dojo](dojo_logo.png)
[http://codingdojo.org](http://codingdojo.org)

DeliberatePractice using challenges (katas) to improve skills.


```
[1] "/media/v/home/v/git/MTLRUSER/CodeDojo/dojo_25FEB2014/Presentation"
```



Machine learning
========================================================

The edge between computer science and statistics

**R packages**

CRAN Task View: [Machine Learning & Statistical Learning](http://cran.r-project.org/web/views/MachineLearning.html)

and CRAN Task View: [Cluster Analysis & Finite Mixture Models] (http://cran.r-project.org/web/views/Cluster.html)

**Topic modeling**

Clustering of texts by topic
- usually using distribution of words in a corpus
- key packages (mainly tm)


Dojo
========================================================

- How to
  - get a curated corpus from a series of texts
  - example topic model

Loading data for topic modeling 
=======================================================
type: section

Loading texts into a corpus
=======================================================



```r
require(tm)
# Tell R to only use one core (if you only have two)
options(mc.cores = 1)

# Load Reuters text into a corpus
reut21578 <- system.file("texts", "crude", package = "tm")
reut21578.corpus <- Corpus(DirSource(reut21578), readerControl = list(reader = readReut21578XMLasPlain))
```


Currating the corpus (1/2)
========================================================

- removing puctuation
- text in lower case
- remove stop words


```r
reut21578.corpus <- tm_map(reut21578.corpus, removePunctuation)
reut21578.corpus <- tm_map(reut21578.corpus, tolower)
reut21578.corpus <- tm_map(reut21578.corpus, function(x) {
    removeWords(x, stopwords("english"))
})
```



Currating the corpus (2/2)
========================================================
- stemming (taking the root of words)
- extracting the word matrix for use by machine learning functions
  - Only words present in at least 5 texts
  

```r
reut21578.corpus <- tm_map(reut21578.corpus, stemDocument, language = "english")
reut21578.matrix <- as.matrix(TermDocumentMatrix(reut21578.corpus, control = list(bounds = list(global = c(5, 
    Inf)))))
```


Corpus as term matrix
========================================================


```r
head(reut21578.matrix[, 1:5])
```

```
          Docs
Terms      127 144 191 194 211
  also       0   0   0   0   0
  barrel     2   0   1   1   0
  bpd        0   4   0   0   0
  chang      0   0   1   1   0
  compani    1   1   1   1   0
  contract   2   0   1   1   0
```



Example clustering based on term matrix
========================================================


```r
fit <- kmeans(t(reut21578.matrix), 5)
head(fit$cluster)
```

```
127 144 191 194 211 236 
  1   3   1   1   2   3 
```



Let's Dojo!
========================================================
type: section

**Topics of available R packages**

Kata : Topics of available R packages
========================================================

**Main challenge**

- What is the most popular topic for R packages

**Secondary challenge**
- Can you sort package according to the functions they use internally?
- Is there a link between internal function use and topic

Kata : Get package descriptions
========================================================

Get data on available packages on cran (example extracts 100)
from their description file

Get the url to the decsription files

```r
require(plyr)
options(repos = structure(c(CRAN = "http://cran.rstudio.com/")))
pkgs <- unname(available.packages()[, 1])[1:100]
desc_urls <- paste("http://cran.r-project.org/web/packages/", pkgs, "/DESCRIPTION", 
    sep = "")
```

note: inspired by [Stack Overflow Question: packages by publication date](http://stackoverflow.com/questions/8722233/available-packages-by-publication-date)

Kata : Get package descriptions
========================================================

Remove faulty urls first
  

```r
require(plyr)
test.url <- lapply(desc_urls, function(x) {
    try.text <- NULL
    try.test <- try(read.dcf(url(x)), silent = T)
    return(class(try.test) != "try-error")
})
desc_urls <- desc_urls[unlist(test.url)]
desc <- ldply(desc_urls, function(x) read.dcf(url(x)))
```



Kata : Get package descriptions
========================================================

Get the files from the url and load in data.frame
  

```r
require(plyr)
desc <- ldply(desc_urls, function(x) read.dcf(url(x)))
```



Kata : Descriptions as corpus and term matrix
========================================================







```r
package.corpus <- Corpus(DataframeSource(data.frame(desc$Description)))
package.matrix <- as.matrix(TermDocumentMatrix(package.corpus, control = list(bounds = list(global = c(5, 
    Inf)))))
```


Kata : Package description term matrix
========================================================


```r
head(package.matrix[, 1:15])
```

```
            Docs
Terms        1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
  adaptive   0 0 0 0 0 0 0 0 0  0  0  0  0  0  0
  algorithm  0 0 0 0 0 0 0 0 0  0  0  0  0  0  0
  algorithms 0 1 0 0 0 0 0 0 0  0  0  0  1  0  0
  also       0 1 0 0 0 0 0 0 0  1  1  0  0  0  0
  analysis   0 0 2 0 0 0 0 1 0  0  0  0  0  0  0
  and        2 2 1 2 1 2 1 2 0  4  3  1  2  1  4
```



Kata : Recap
========================================================

**Main challenge**

- What is the most popular (number of packages) topic for R packages

**Secondary challenge**
- Can you sort package according to the functions they use internally?
- Is there a link between internal function use and topic

Kata : Next steps
========================================================

- corpus curration
  - stop words
  - etc
- clustering

Final notes
========================================================

To extract R code from this presentation run:

  purl("Presentation/dojo_25FEB2014.Rpres", "R/dojo_25FEB2014.R")
  
