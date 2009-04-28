
# A scatterplot of engine displacement in litres (displ) vs.  average
# highway miles per gallon (hwy).  Points are coloured according to
# number of cylinders.  This plot summarises the most important factor
# governing fuel economy: engine size.
qplot(displ, hwy, data = mpg, colour = factor(cyl))


# Instead of using points to represent the data, we could use other
# geoms like lines (left) or bars (right).  Neither of these geoms
# makes sense for this data, but they are still grammatically valid.
qplot(displ, hwy, data=mpg, colour=factor(cyl), geom="line") + 
  opts(drop = "legend_box")
qplot(displ, hwy, data=mpg, colour=factor(cyl), geom="bar", 
  stat="identity", position = "identity") + 
  opts(drop = "legend_box")

# More complicated plots don't have their own names.  This plot takes
# Figure~\ref{fig:mpg} and adds a regression line to each group.  What
# would you call this plot?
qplot(displ, hwy, data=mpg, colour=factor(cyl)) + 
geom_smooth(data= subset(mpg, cyl != 5), method="lm")

# A more complex plot with facets and multiple layers.
qplot(displ, hwy, data=mpg, facets = . ~ year) + geom_smooth()

# Examples of legends from four different scales.  From left to right:
# continuous variable mapped to size, and to colour, discrete variable
# mapped to shape, and to colour.  The ordering of scales seems
# upside-down, but this matches the labelling of the $y$-axis: small
# values occur at the bottom.
x <- 1:10
y <- factor(letters[1:5])
qplot(x, x, size = x) + opts(keep = "legend_box")
qplot(x, x, 1:10, colour = x) + opts(keep = "legend_box")
qplot(y, y, 1:10, shape = y) + opts(keep = "legend_box")
qplot(y, y, 1:10, colour = y) + opts(keep = "legend_box")

# Examples of axes and grid lines for three coordinate systems:
# Cartesian, semi-log and polar. The polar coordinate system
# illustrates the difficulties associated with non-Cartesian
# coordinates: it is hard to draw the axes well.
x1 <- c(1,10)
y1 <- c(1, 5)
p <- qplot(x1, y1, geom="blank", xlab=NULL, ylab=NULL) + theme_bw()
p 
p + coord_trans(y="log10")
p + coord_polar()

p <- qplot(displ, hwy, data = mpg, colour = factor(cyl))
summary(p)
# Save plot object to disk
save(p, file = "plot.rdata")
# Load from disk
load("plot.rdata")
# Save png to disk
ggsave("plot.png", width = 5, height = 5)
