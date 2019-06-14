library("methods") # avoids weird broom error
library("rmarkdown")

tex_chapter <- function (chapter = NULL, latex_engine = c("xelatex", "pdflatex",
                                                          "lualatex"), code_width = 65) {
  options(digits = 3)
  set.seed(1014)
  latex_engine <- match.arg(latex_engine)
  rmarkdown::output_format(rmarkdown::knitr_options("html", chapter),
                           rmarkdown::pandoc_options(to = "latex",
                                                     from = "markdown_style",
                                                     ext = ".tex",
                                                     args = c("--top-level-division=chapter",
                                                              rmarkdown::pandoc_latex_engine_args(latex_engine))
                                                     ),
                           clean_supporting = FALSE)
}

path <- commandArgs(trailingOnly = TRUE)
# command line args should contain just one chapter name
if (length(path) == 0) {
  message("No input supplied")
} else {
  base <- tex_chapter()
  base$knitr$opts_knit$width <- 67
  base$pandoc$from <- "markdown"

  rmarkdown::render(path, base, output_dir = "book/tex", envir = globalenv(), quiet = TRUE)
}