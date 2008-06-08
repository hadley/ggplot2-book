source("~/Documents/ggplot/ggplot/load.r")
setwd("_include/")

# Defaults and overriding ----------------------------------------------------

qplot(mpg, wt, data=mtcars, colour=cyl)
qplot(mpg, wt, data=mtcars, colour=factor(cyl))
qplot(mpg, wt, data=mtcars, colour=factor(cyl)) + scale_colour_brewer(pal="Set1")


# Scales and params ----------------------------------------------------------

aes_type <- function(scale) {
  common <- scale$common
  
  if (is.null(common)) {
    input <- scale$input()
    if (input == "") return(NULL)
    return(input)
  }
  if ("x" %in% common) return("position")
  if ("colour" %in% common) return("colour")
}

names <- invert(compact(lapply(Scales$find_all(), aes_type)))
scales <- lapply(names, function(x) lapply(x, get))

tabulate <- function(x) {
  align <- ifelse(laply(x, is.numeric), "right", "left")
  tbl <- do.call("cbind", mlply(cbind(as.list(x), align), format))
  paste(paste(apply(tbl, 1, paste, collapse = " & "), collapse = "\\\\\n"), "\\\\\n", sep="")
}

type_table <- function(type) tabulate(ldply(scales[[type]], function(s) c(s$objname, s$desc)))

labels <- c(
  "colour" = "Colour and fill",
  "linetype" = "Line type", 
  "position" = "Position (x, y, z)",
  "shape" = "Shape",
  "size" = "Size"
)
type_header <- function(type) {
  paste(
    "\\midrule\n",
    "\\multicolumn{2}{c}{", labels[type], "} \\\\\n",
    "\\midrule\n",
    sep = ""
  )
}

l(plyr)
scale_desc <- laply(names(scales), function(s) paste(type_header(s), type_table(s), sep =""))
cat(scale_desc, file ="scale-desc.tex")

# Labels ---------------------------------------------------------------------

p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_gradient("Tip rate")
ggsave(file = "scales-name-1.pdf", width=4, height=4)
p + scale_colour_gradient("The amount of the tip\ndivided by the total bill")
ggsave(file = "scales-name-2.pdf", width=4, height=4)
p + scale_colour_gradient(expression(frac(tip, total)))
ggsave(file = "scales-name-3.pdf", width=4, height=4)


# Transformers ---------------------------------------------------------------

qplot(log(carat), log(price), data=diamonds)
ggsave(file="trans-data.pdf", width=6, height=6)
qplot(carat, price, data=diamonds, log="xy")
ggsave(file="trans-scale.pdf", width=6, height=6)


# Special scales -------------------------------------------------------------

x <- colors()
luv <- as.data.frame(convertColor(t(col2rgb(x)), "sRGB", "Luv"))
qplot(u, v, data=luv, colour=x, size=I(3)) + scale_colour_identity() + coord_equal()
ggsave(file="scale-identity.pdf", width=6, height=6)
