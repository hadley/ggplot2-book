# ggplot2 book

[![Build Status](https://travis-ci.org/hadley/ggplot2-book.svg?branch=master)](https://travis-ci.org/hadley/ggplot2-book)

This is code and text behind the [ggplot2: elegant graphics for data analysis](http://ggplot2-book.org/) book. Please help us make it better by [contributing](contributing.md)!

## Installing dependencies

Install the R packages used by the book with:

```r
# install.packages("devtools")
devtools::install_deps()
```

## Build the book

In RStudio, press Cmd/Ctrl + Shift + B. Or run:

```R
bookdown::render_book("index.Rmd")
```


