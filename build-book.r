library(plyr)
l(decumar)
l(ggplot)

chapters <- c("introduction", "layers", "mastery", "position", "polishing", "qplot", "scales", "specifications", "toolbox", "book-mine")

tex <- paste(chapters, ".tex", sep="")
r <-   file.path("public", paste(chapters, ".r", sep=""))
pdf <- paste(chapters, ".pdf", sep="")

l_ply(tex, function(path) {
  cat(path, "\n")
  overwrite_file(path, T)
})
m_ply(cbind(input = tex, output = r), function(input, output) {
  cat(input, "\n")
  output_code(input, output)
})

builders <- c("pdflatex", "bibtex", "pdflatex", "pdflatex")
build_cmds <- paste(builders, rep(tex, each = length(builders)), "> /dev/null")

l_ply(build_cmds, function(cmd) {
  message(cmd)
  system(cmd)
})

l_ply(paste("cp", pdf, "public"), system)
system("mv public/book-mine.pdf public/ggplot2-book.pdf")
