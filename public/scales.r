
p <- qplot(sleep_total, sleep_cycle, data=msleep, colour=vore)
p 
p + scale_colour_hue("What does\nit eat?", 
   breaks = rev(c("herbi", "carni", "omni", NA)), 
   labels = rev(c("plants", "meat", "both", "don't know")))
p + scale_colour_brewer(pal="Set1")

p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_gradient("Tip rate")
p + scale_colour_gradient("The amount of the tip\ndivided by the total bill")
p + scale_colour_gradient(expression(frac(tip, total_bill)))

# Legends with names given by (from left to right): {\tt "Tip rate"},
# {\tt "The amount of the tip$\backslash$ndivided by the total bill"}
# and {\tt expression(frac(tip, total\_bill)}
p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_gradient("Tip rate")
p + scale_colour_gradient("The amount of the tip\ndivided by the total bill")
p + scale_colour_gradient(expression(frac(tip, total_bill)))

# The difference between breaks and limits, demonstrated using the x
# axis of {\tt qplot(cyl, wt, data = mtcars)}.  (Left) default plot
# with {\tt limits = c(4, 8), breaks = 4:8}.  (Middle) {\tt breaks =
# c(5.5,6.5)} and (right) {\tt limits = c(5.5,6.5)}.
p <- qplot(cyl, wt, data = mtcars)
p
p + scale_x_continuous(limits = c(5.5, 6.5))
p + scale_x_continuous(breaks = c(5.5, 6.5))

qplot(log10(carat), log10(price), data=diamonds)
qplot(carat, price, data=diamonds) + scale_x_log10() + scale_y_log10()

# A scatterplot of diamond price vs. carat illustrating the difference
# between log transforming the scale (left) and log transforming the
# data (right).  The plots are identical, but the axis labels are
# different.
qplot(log10(carat), log10(price), data=diamonds)
qplot(carat, price, data=diamonds, log="xy")

# Density of eruptions with three colour schemes.  (Left) default
# gradient colour scheme, (mid) customised gradient from white to black
# and (right) 3 point gradient with midpoint set to the median density.
p + scale_fill_gradient(limits = c(0, 0.04))
p + scale_fill_gradient(limits = c(0, 0.04), low="white", high="black") 
p + scale_fill_gradient2(limits = c(-0.04, 0.04), 
  midpoint= median(df$density)) 

# Gradient colour scales using perceptually well-formed palettes
# produced by the \code{vcd} package.  From left to right: sequential,
# diverging and heat hcl palettes.  Each scale is produced with
# \code{scale_fill_gradientn} with \code{values} set to
# \code{sequential_hcl(7)}, \code{diverge_hcl(7)} and
# \code{heat_hcl(7)}.
library(vcd)
p + scale_fill_gradientn(colours = sequential_hcl(7), limits=c(0, 0.04))
p + scale_fill_gradientn(colours = diverge_hcl(7), limits=c(0, 0.04))
p + scale_fill_gradientn(colours = heat_hcl(7), limits=c(0, 0.04))

# A plot of R colours in Luv space.  A legend is unnecessary, because
# the colour of the points represents itself: the data and aesthetic
# spaces are the same.
x <- colors()
luv <- as.data.frame(convertColor(t(col2rgb(x)), "sRGB", "Luv"))
qplot(u, v, data=luv, colour = x, size = I(3)) + scale_colour_identity() +
   coord_equal()

# Colour legend, shape legend, colour + shape legend.
p <- ggplot(diamonds[1:100, ], aes(x=price, y=carat)) + geom_point() + geom_point() + opts(keep = "legend_box")
p + aes(colour = cut)
p + aes(shape = cut)
p + aes(shape = cut, colour= cut)
