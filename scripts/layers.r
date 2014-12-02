source("latex.r")
l(decumar)

aesthetics <- function(o) sort(c(names(o$default_aes()), o$required_aes))
params <- function(x) sort(setdiff(names(x$parameters()), c(aesthetics(x), "...")))
output <- function(o) sort(names(o$desc_outputs))
comma <- function(x) paste(escape_tex(x), collapse= ", ")

ap <- function(x) paste(comma(aesthetics(x)), comma(params(x)), sep = " + ")

g <- GeomPoint
aesthetics2 <- function(g) {
  a <- aesthetics(g)
  req <- a %in% g$required_aes
  
  a[req] <- paste("\\textbf{", a[req], "}", sep = "")
  paste(a, collapse = ", ")
}

cat(tabulate(ldply(Geom$find_all(), function(c) c(escape_tex(c$objname), escape_tex(c$desc)))))

cat(tabulate(ldply(Geom$find_all(), function(c) c(escape_tex(c$objname),escape_tex(c$default_stat()$objname), aesthetics2(c))))  )


cat(tabulate(ldply(Stat$find_all(), function(c) c(escape_tex(c$objname), escape_tex(c$desc)))))

