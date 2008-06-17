source("latex.r")
source("~/Documents/eval.with.details/eval.with.details/R/weave-tex.r")

aesthetics <- function(o) sort(c(names(o$default_aes()), o$required_aes))
params <- function(x) sort(setdiff(names(x$parameters()), c(aesthetics(x), "...")))
output <- function(o) sort(names(o$desc_outputs))
comma <- function(x) paste(escape_tex(x), collapse= ", ")

ap <- function(x) paste(comma(aesthetics(x)), comma(params(x)), sep = " + ")

cat(tabulate(ldply(Geom$find_all(), function(c) c(escape_tex(c$objname), escape_tex(c$desc))))  )

cat(tabulate(ldply(Stat$find_all(), function(c) c(escape_tex(c$objname), escape_tex(c$desc)))))

