rnws <- Sys.glob("*.Rnw")
for (i in rnws) {
  knitr::knit2pdf(i,)
}
