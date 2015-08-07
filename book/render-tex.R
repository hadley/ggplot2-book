library("methods") # avoids weird broom error

path <- commandArgs(trailingOnly = TRUE)
# command line args should contain just one chapter name
if (length(path) == 0) {
  message("No input supplied")
} else {
  base <- bookdown::tex_chapter()
  base$knitr$opts_chunk$fig.show <- "hold"
  base$knitr$opts_chunk$fig.align <- "center"
  base$knitr$opts_chunk$out.width <- "0.49\\linewidth"

  chap <- sub("\\.rmd", "", path)
  base$knitr$opts_chunk$fig.path <- paste0("_figures/", chap, "/")
  base$knitr$opts_chunk$cache.path <- paste0("_cache/", chap, "/")
  base$knitr$opts_chunk$cache <- TRUE

  rmarkdown::render(path, base, output_dir = "book/tex", envir = globalenv(), quiet = TRUE)
}
