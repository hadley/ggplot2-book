source("~/Documents/ggplot/ggplot/load.r")
setwd("_include/")

# Defaults and overriding ----------------------------------------------------

qplot(mpg, wt, data=mtcars, colour=cyl)
qplot(mpg, wt, data=mtcars, colour=factor(cyl))
qplot(mpg, wt, data=mtcars, colour=factor(cyl)) + scale_colour_brewer(pal="Set1")


# Labels ---------------------------------------------------------------------

p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_gradient("Tip rate")
ggsave(file = "scales-name-1.pdf", width=4, height=4)
p + scale_colour_gradient("The amount of the tip\ndivided by the total bill")
ggsave(file = "scales-name-2.pdf", width=4, height=4)
p + scale_colour_gradient(expression(frac(tip, total)))
ggsave(file = "scales-name-3.pdf", width=4, height=4)

# Breaks vs limits -----------------------------------------------------------

p <- qplot(cyl, wt, data = mtcars)
p
ggsave(file = "_include/scales-unlimited.pdf", width=4, height=4)
p + scale_x_continuous(limits = c(5.5, 6.5))
ggsave(file = "_include/scales-limits.pdf", width=4, height=4)
p + scale_x_continuous(breaks = c(5.5, 6.5))
ggsave(file = "_include/scales-breaks.pdf", width=4, height=4)


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
