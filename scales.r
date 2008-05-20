source("~/Documents/ggplot/ggplot/load.r")

p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_gradient("Tip rate")
ggsave(file = "_include/scales-name-1.pdf", width=4, height=4)
p + scale_colour_gradient("The amount of the tip\ndivided by the total bill")
ggsave(file = "_include/scales-name-2.pdf", width=4, height=4)
p + scale_colour_gradient(expression(frac(tip, total)))
ggsave(file = "_include/scales-name-3.pdf", width=4, height=4)


# Transformers ---------------------------------------------------------------

qplot(log(carat), log(price), data=diamonds)
ggsave(file="_include/trans-data.pdf", width=6, height=6)
qplot(carat, price, data=diamonds, log="xy")
ggsave(file="_include/trans-scale.pdf", width=6, height=6)


# Special scales -------------------------------------------------------------

x <- colors()
luv <- as.data.frame(convertColor(t(col2rgb(x)), "sRGB", "Luv"))
qplot(u, v, data=luv, colour=x, size=I(3)) + scale_colour_identity() + coord_equal()
ggsave(file="_include/scale-identity.pdf", width=6, height=6)
