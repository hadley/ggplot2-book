load("~/Documents/ggplot/ggplot/data/msleep.rda")
load("~/Documents/ggplot/ggplot/data/presidential.rda")
l(plyr)
l(decumar)
l(ggplot)
library(MASS)
library(mgcv)
options(width = 60)

# Clean out include directory
system("rm -rf _include/")
system("mkdir _include")

# Run decumar on each file
chapters <- c("position", "introduction", "layers", "mastery", "polishing", "qplot", "scales", "grid", "specifications", "toolbox", "translating",  "data", "duplication", "book-springer")

tex <- paste(chapters, ".tex", sep="")
r <-   file.path("public", paste(chapters, ".r", sep=""))
pdf <- paste(chapters, ".pdf", sep="")

cache_clear()
l_ply(tex, function(path) {
  cat(path, "\n")
  overwrite_file(path)
})
m_ply(cbind(input = tex, output = r), function(input, output) {
  cat(input, "\n")
  output_code(input, output)
})

# Run full sequence of commands to build book
build_cmds <- c(
  "pdflatex -interaction=batchmode book-springer.tex", 
  "pdflatex -interaction=batchmode book-springer.tex",
  "bibtool -x book-springer.aux -o references.bib",
  "makeindex book-springer", 
  "makeindex -o book-springer.and  book-springer.adx",
  "bibtex book-springer", 
  "pdflatex -interaction=batchmode book-springer.tex",
  "pdflatex -interaction=batchmode book-springer.tex"
)

# build_cmds <- paste(builders, rep(tex, each = length(builders)), "> /dev/null")

l_ply(build_cmds, function(cmd) {
  message(cmd)
  system(cmd)
})

# l_ply(paste("cp", pdf, "public"), system)
# system("mv public/book-springer.pdf public/ggplot2-book.pdf")
# 
# 
# cat("Remember to:
#   * Change date on webpage
#   * Update changelog
# ")

# git log --date=short --abbrev-commit  --stat