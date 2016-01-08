# ggplot2 book

[![Build Status](https://travis-ci.org/hadley/ggplot2-book.png?branch=master)](https://travis-ci.org/hadley/ggplot2-book)

This is code and text behind the [ggplot2](http://ggplot2.org/book/) book. Please help us make it better by [contributing](https://github.com/hadley/ggplot2-book/blob/master/contributing.md)!

## Build the book

You can build the pdf by cloning this repo and running make:

```bash
git clone https://github.com/hadley/ggplot2-book.git
cd ggplot2-book
make clean
make
```

If you use RStudio, you can press Cmd/Ctrl + Shift + B to run make.

## Installing dependencies

To successfully build this book, you'll need:

* R [package development prerequisites](https://support.rstudio.com/hc/en-us/articles/200486498-Package-Development-Prerequisites)
* [pandoc and pandoc-citeproc](http://pandoc.org/installing.html),
* the [Inconsolata font](http://www.ctan.org/tex-archive/fonts/inconsolata/)

Install the R dependencies with:

```r
library(devtools)
if (packageVersion("devtools") < "1.9.1") {
  message("Please upgrade devtools")
}
devtools::install_deps()
```

## Internal links

To link between sections, use internal links of the form `#header-id`.
All header references are listed in `toc.yaml`.
