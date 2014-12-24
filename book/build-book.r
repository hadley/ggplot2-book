library("bookdown")
library("rmarkdown")
library("xtable")

# Global options for tables -------------------------------------------
options(xtable.include.rownames = FALSE)
options(xtable.comment = FALSE)
options(xtable.sanitize.text.function = function(x) x)
# function used in some chapters for displaying code in tables
tex_code <- function(x) paste0("\\texttt{", x, "}")

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
#render_chapter("mastery.rmd")

# produce all the tex!
chapters <- dir(".", pattern = "\\.rmd$")
lapply(chapters, render_chapter)


# Copy across additional files -------------------------------------------------
file.copy("book/ggplot2-book.tex", "book/tex/", recursive = TRUE)
file.copy("book/krantz.cls", "book/tex/", recursive = TRUE)
file.copy("diagrams/", "book/tex/", recursive = TRUE)
file.copy("tbls/", "book/tex/", recursive = TRUE)
file.copy("figures/", "book/tex/", recursive = TRUE)

# Build tex file ---------------------------------------------------------------
# (build with Rstudio to find/diagnose errors)
old <- setwd("book/tex")
unlink("ggplot2-book.ind") # delete old index
system("xelatex -interaction=batchmode ggplot2-book ")
system("makeindex ggplot2-book")
system("xelatex -interaction=batchmode ggplot2-book ")
system("xelatex -interaction=batchmode ggplot2-book ")
setwd(old)

file.copy("book/tex/ggplot2-book.pdf", "book/ggplot2-book.pdf", overwrite = TRUE)
embedFonts("book/tex/ggplot2-book.pdf")
