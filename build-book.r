l(plyr)
l(decumar)
tex <- c("grid", "introduction", "layers", "mastery", "position", "qplot", "scales", "specifications", "theming", "toolbox", "book-mine")
r <- file.path("public", paste(tex, ".r", sep=""))
pdf <- paste(tex, ".pdf", sep="")

l_ply(tex, overwrite_file)
m_ply(cbind(tex, r), output_code)

builders <- c("xelatex", "bibtex", "xelatex", "xelatex")
build_cmds <- paste(builders, rep(tex, each = length(builders)), "> /dev/null")

l_ply(build_cmds, function(cmd) {
  message(cmd)
  system(cmd)
})

l_ply(paste("cp", pdf, "public"), system)
system("mv public/book-mine.pdf public/ggplot2-book.pdf")
