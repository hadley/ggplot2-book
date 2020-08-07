# ggplot2 book

<!-- badges: start -->
[![Build status](https://github.com/hadley/ggplot2-book/workflows/workflow/badge.svg)](https://github.com/hadley/ggplot2-book/actions)
<!-- badges: end -->

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


