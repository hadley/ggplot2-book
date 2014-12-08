l(plyr)

tabulate <- function(x) {
  align <- ifelse(laply(x, is.numeric), "right", "left")
  tbl <- do.call("cbind", mlply(cbind(as.list(x), align), format))
  paste(paste(apply(tbl, 1, paste, collapse = " & "), collapse = "\\\\\n"), "\\\\\n", sep="")
}

describe <- function(obj) {
  cat(tabulate(ldply(obj$find_all(), function(c) c(c$objname, c$desc)))  )
}

