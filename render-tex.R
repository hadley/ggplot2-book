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
  capture.output(render(src, base, output_dir = "book/tex", envir = new.env()),
                 file = "book/tex/render-log.txt")
}

# list the chapters in order they should appear
# this is necessary to handle figure/table bumping properly
chap_order <- c("introduction", "qplot", "mastery", "layers", "toolbox",
                "scales", "position", "polishing", "duplication",
                "data",  "data-transformation", "modelling",
                "translating", "specifications", "grid")
chap_ord <- paste0(chap_order, ".rmd")
if (!setequal(chap_ord, dir(pattern = ".rmd"))) 
  warning("Detected a difference in actual and expected chapters.")

# command line arguments should be the chapter names
args <- commandArgs(trailingOnly = TRUE)
# Chapter "id numbers"  (used to 'bump' figure/table numbering)
chap_id <- sort(match(args, chap_ord))
# The number of times to 'bump' before rendering each chapter
bump_n <- c(chap_id[1], diff(chap_id))

# Initiate captioner functions
figs <- captioner(levels = 2, type = c("n", "n"), infix = ".")
tbls <- captioner(prefix = "Table", 
                  levels = 2, type = c("n", "n"), infix = ".")
# Bump figure/table numbering a specified number of times *before*
# rendering a chapter
bumper <- function(times, chap, ...) {
  if (times == 0) return(invisible())
  for (i in seq_len(times)) {
    bump(figs, level = 1)
    bump(tbls, level = 1)
  }
  render_chapter(chap)
}

res <- mapply(bumper, bump_n, chap_ord[chap_id], SIMPLIFY = FALSE)
