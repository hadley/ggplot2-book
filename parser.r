# Requires highlight command line script
l(plyr)
l(eval.with.details)

# lines <- readLines(file("scales.tex"), warn=FALSE)

.defaults <- list()

blocks <- toupper(c(
  "defaults", # Set up default parameters for the remainder of the file
  "figure",   # Insert a floating figure containing graphics
  "graphic",  # Insert a graphic into the document
  "tabular",  # Insert a table
  "table",    # Insert a floating table containing data
  "output",   # Include output 
  "raw",      # Include output (unescaped) 
  "listing",  # Pretty print code
  "weave"     # Output and listing interwoven
))

re <- function(string, regexp) {
  seq_along(string) %in% grep(regexp, as.character(string))
}
is.comment <- function(x) re(x, "^\\s*%")
is.block <-  function(x)  {
  laply(x, 
    function(x) re(x[1], ps("^\\s*%\\s+(", ps(blocks, collapse="|"), ")"))
  )
}
is.block <-  function(x)  {
  regexp <- ps("^\\s*%\\s+(", ps(blocks, collapse="|"), ")")
  laply(x, function(x) re(x[1], regexp))
}
is.end <-  function(x)  {
  laply(x, function(x) re(x[1], "^\\s*% END"))
}

grp <- c(0,cumsum(diff(is.comment(lines)) != 0))
groups <- unname(split(lines, grp))


block <- groups[is.block(groups)][[1]]
strip_comment <- function(x) {
  indent <- nchar(strsplit(x[1], "%")[[1]][1])
  
  structure(
    laply(x, function(x) gsub("\\s*% ?", "", x)),
    indent = indent
  )
}
block <- strip_comment(block)

blank <- which(block == "")[1]
type <- block[1]
params <- paste(block[seq(2, blank - 1)], collapse=" ")
code <- paste(block[seq(blank + 1, length(block))], collapse="\n")
