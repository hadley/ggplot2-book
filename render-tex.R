library("bookdown")
library("rmarkdown")
library("xtable")
library("captioner")
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
  capture.output(render(src, base, output_dir = "book/tex", envir = globalenv()),
                 file = "book/tex/render-log.txt")
}

args <- commandArgs(trailingOnly = TRUE)
# command line args should contain just one chapter name
stopifnot(length(args) == 1)
chap <- sub("\\.[R-r]md", "", args)
# this csv records the order in which the chapters should appear
chaps <- read.csv("chapter_order.csv")
idx <- chaps$chapter %in% chap
if (!any(idx)) warning("Chapter ", chap, " not found in chapter_order.csv!")
n <- chaps[idx, "num"]

# Initiate captioner functions
figs <- captioner(levels = 2, type = c("n", "n"), infix = ".")
tbls <- captioner(prefix = "Table", levels = 2, type = c("n", "n"), infix = ".")
# Bump the chapter number for figure/table referencing
for (i in seq_len(n)) {
  bump(figs, level = 1)
  bump(tbls, level = 1)
}
render_chapter(args)