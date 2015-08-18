library("methods") # avoids weird broom error

path <- commandArgs(trailingOnly = TRUE)
# command line args should contain just one chapter name
if (length(path) == 0) {
  message("No input supplied")
} else {
  base <- bookdown::tex_chapter()
  base$knitr$opts_knit$width <- 69

  rmarkdown::render(path, base, output_dir = "book/tex", envir = globalenv(), quiet = TRUE)
}
