library("bookdown")
library("rmarkdown")
library("xtable")
library("methods")

# Set global options for tables and precompile time-intensive tables -----------
options(xtable.include.rownames = FALSE)
options(xtable.comment = FALSE)

# 'global' convenience functions -----------------------------------------------
tex_code <- function(x) paste0("\\texttt{", x, "}")

# generate tables, if necessary  -----------------------------------------------
if (!file_test("-d", "tbls")) dir.create("tbls")
# Is render-tbls.R newer than it's target? (essentially what make does)
nt <- file_test("-nt", "render-tbls.R", list.files("tbls"))
if (length(nt) == 0 || any(nt)) source("render-tbls.R")

# Render chapters into tex  ----------------------------------------------------
render_chapter <- function(src) {
  dest <- file.path("book/tex/", gsub("\\.rmd", "\\.tex", src))
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

args <- commandArgs(trailingOnly = TRUE)
chaps <- dir(pattern = ".rmd")
lapply(args[args %in% chaps], render_chapter)