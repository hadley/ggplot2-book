library("bookdown")
library("rmarkdown")
library("xtable")

# Set global options for tables and precompile time-intensive tables -----------
options(xtable.include.rownames = FALSE)
options(xtable.comment = FALSE)

# 'global' convenience functions -----------------------------------------------
tex_code <- function(x) paste0("\\texttt{", x, "}")

# generate tables if they don't already exist  ---------------------------------
# maybe `make` should take care of this part?
if (!length(list.files("tbls"))) {
  if (!file.exists("tbls")) dir.create("tbls")
  source("render-tbls.R")
}

# Render chapters into tex  ----------------------------------------------------
needs_update <- function(src, dest) {
  if (!file.exists(dest)) return(TRUE)
  mtime <- file.info(src, dest)$mtime
  mtime[2] < mtime[1]
}

render_chapter <- function(src) {
  dest <- file.path("book/tex/", gsub("\\.rmd", "\\.tex", src))
  #if (!needs_update(src, dest)) return()
  base <- bookdown::tex_chapter()
  chap <- sub("\\.rmd", "", src)
  # set some global knitr chunk options...
  base$knitr$opts_chunk <- 
    plyr::defaults(list(message = FALSE,
                        warning = FALSE,
                        fig.show = 'hold',
                        fig.align = 'center',
                        fig.height = 4,
                        fig.width = 4,
                        out.width = "0.49\\linewidth",
                        fig.path = paste0("figures/", chap),
                        cache.path = paste0("_cache/", chap)),
                   base$knitr$opts_chunk)
  capture.output(render(src, base, output_dir = "book/tex", env = globalenv()),
                 file = "book/tex/render-log.txt")
}

# produce tex individually (useful for debugging)
#render_chapter("scales.rmd")

# produce all the tex!
chapters <- dir(".", pattern = "\\.rmd$")
lapply(chapters, render_chapter)