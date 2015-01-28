# ggplot2 book

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

The book depends on a number of R packages, which you may need to install. All of these are available on CRAN via `install.packages` except for [bookdown](https://github.com/hadley/bookdown) which you can install with `devtools::install_github("hadley/bookdown")`.

## Internal links

To link between sections, use internal links of the form `#header-id`.
All header references are listed in `toc.yaml`.


