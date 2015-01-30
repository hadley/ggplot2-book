# ggplot2 book

[![Build Status](https://travis-ci.org/hadley/ggplot2-book.png?branch=master)](https://travis-ci.org/hadley/ggplot2-book)

This is code and text behind the [ggplot2](http://ggplot2.org/book/) book. Please help us make it better by [contributing](https://github.com/hadley/ggplot2-book/blob/master/contributing.md)!

## Build the book

You can build the pdf by cloning this repo and running make:

```
$ git clone https://github.com/hadley/ggplot2-book.git
$ cd ggplot2-book
$ make
```

If you use RStudio, you can press Cmd/Ctrl + Shift + B to run make.

## Installing dependencies

There are a number of dependencies required to build this book. We have a full installation recipe for ubuntu 12.04 [here](https://github.com/hadley/ggplot2-book/blob/master/.travis.yml). Even if run you run a different operating system, please look there for R package requirements. Most of the R packages are available on CRAN via `install.packages` except for [bookdown](https://github.com/hadley/bookdown) and [captioner](https://github.com/adletaw/captioner). You can install both with:

```r
devtools::install_github(c("adletaw/captioner/captioner", "hadley/bookdown"))
```

You might also need to install the [inconsolata](http://www.ctan.org/tex-archive/fonts/inconsolata/) font.

## Internal links

To link between sections, use internal links of the form `#header-id`.
All header references are listed in `toc.yaml`.


