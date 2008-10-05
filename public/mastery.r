
# A scatterplot of engine displacement in litres (displ) vs average
# highway miles per gallon (hwy).  Points are coloured according to
# number of cylinders.  This plot summarises the most important factor
# governing fuel economy: engine size
qplot(displ, hwy, data=mpg, colour=factor(cyl))


# Instead of using points to represent the data, we could use other
# geoms like, \leftc lines or, \rightc bars.  Neither of these geoms
# make much sense for this data, but they are still valid graphics.
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
