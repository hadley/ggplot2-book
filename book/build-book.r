library("bookdown")
library("rmarkdown")
library("pander")

# Global options for pander tables -------------------------------------------
panderOptions('table.split.table', Inf)
panderOptions('table.alignment.default', 'left')
panderOptions('table.style', 'simple')

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
  # set some knitr options...
  chap <- sub("\\.rmd", "", src)
  within(base$knitr$opts_chunk, {
          message = FALSE
          warning = FALSE
          fig.show = 'hold'
          fig.height = 4
          fig.width = 4
          fig.path = paste0("figures/", chap)
          cache.path = paste0("_cache/", chap)})
  capture.output(render(src, base, output_dir = "book/tex", env = globalenv()),
                 file = "book/tex/render-log.txt")
}

# produce tex individually (useful for debugging)
# render("scales.rmd", bookdown::tex_chapter(),
#        output_dir = "book/tex", env = globalenv())

chapters <- dir(".", pattern = "\\.rmd$")
lapply(chapters, render_chapter)


# Copy across additional files -------------------------------------------------
file.copy("book/ggplot2-book.tex", "book/tex/", recursive = TRUE)
file.copy("book/krantz.cls", "book/tex/", recursive = TRUE)
file.copy("diagrams/", "book/tex/", recursive = TRUE)
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
