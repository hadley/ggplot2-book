
# The basic geoms applied to the same data.  Many give rise to to named
# plots (from top-left to bottom-right): scatterplot, barchart, line
# chart, area chart, path plot, labelled scatterplot, image/level plot
# and polygon plot.  Observe the different axis ranges for the bar,
# area and image plots: these geoms take up space outside the range of
# the data, so push the axes out.
df <- data.frame(x = c(3, 1, 5), y = c(2, 4, 6), label = c("a","b","c"))
p <- ggplot(df, aes(x, y, label = label)) + scale_x_continuous("") + scale_y_continuous("")
p + geom_point() + opts(title = "geom_point")
p + geom_bar(stat="identity") + opts(title = "geom_bar(stat=\"identity\")")
p + geom_line() + opts(title = "geom_line")
p + geom_area() + opts(title = "geom_area")
p + geom_path() + opts(title = "geom_path")
p + geom_text() + opts(title = "geom_text")
p + geom_tile() + opts(title = "geom_tile")
p + geom_polygon() + opts(title = "geom_polygon")

# \Leftc, never rely on the default parameters to get a revealing view
# of the distribution.  \Rightc, zooming in on the x axis and selecting
# a smaller bin width reveal far more detail, {\tt xlim = c(55, 70),
# binwidth = 0.1}.
qplot(depth, data=diamonds, geom="histogram")
qplot(depth, data=diamonds, geom="histogram", xlim=c(55, 70), binwidth=0.1)

qplot(depth, ..density.., data = diamonds, geom = "histogram", 
  xlim = c(58, 68), binwidth = 0.1, facets = cut ~ ., fill = cut)
qplot(depth, data = diamonds, geom = "histogram", 
  xlim = c(58, 68), binwidth = 0.1, fill = cut, position = "fill", 
  colour = I(NA))
qplot(depth, ..density.., data = diamonds, geom = "freqpoly", 
  xlim = c(58, 68), binwidth = 0.1, colour = cut)

# The boxplot geom can be use to see the distribution of a continuous
# variable conditional on a, \leftc discrete varable, or right
# continuous variable.  If the number of boxplots is small, faceted
# histograms will reveal finer details of the distribution.
qplot(cut, depth, data=diamonds, geom="boxplot")
qplot(carat, depth, data=diamonds, geom="boxplot", group=round_any(carat, 0.1), xlim=c(0, 3))

# The jitter geom can give a crude visualisation of 2d distributions
# with a discrete component.  Generally this works better for smaller
# datasets.  Car class vs \leftc, city mpg (continuous) and \rightc
# drive train (discrete).
qplot(class, cty, data=mpg, geom="jitter")
qplot(class, drv, data=mpg, geom="jitter")

# The boxplot geom can be use to see the distribution of a continuous
# variable conditional on a, \leftc discrete varable, or right
# continuous variable.  If the number of boxplots is small, faceted
# histograms will reveal finer details of the distribution.
qplot(carat, depth, data=diamonds, geom="quantile", 
  xlim=c(0, 3), quantiles = c(0.05, 0.25, 0.5, 0.75, 0.95))
qplot(carat, depth, data=diamonds, geom="quantile", xlim=c(0, 3), formula = y ~ factor(round_any(x, 0.5)))

# The density plot is a smoothed version of the histogram.  It has
# desirable theoretical properties, but is more difficult to relate
# directly back to the data.  \Leftc a density plot of depth, and
# \rightc facetted by cut.
qplot(depth, data=diamonds, geom="density", xlim = c(54, 70))
qplot(depth, data=diamonds, geom="density", xlim = c(54, 70), 
  fill = cut) + scale_fill_hue(alpha = 0.2)

df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y))
norm + geom_point()
norm + geom_point(size = 0.5) # 1/2 mm 
norm + geom_point(shape = ".") # Pixel sized
norm + geom_point(shape = 1)

norm + geom_point()
norm + geom_point(colour = alpha("black", 1/2))
norm + geom_point(colour = alpha("black", 1/5))
norm + geom_point(colour = alpha("black", 1/10))

# If you don't like the rings around the transparent points:
norm + geom_point(shape = 21, fill = alpha("black", 1/2), colour=NA)

td <- ggplot(diamonds, aes(table, depth)) + xlim(50, 70) + ylim(50, 70)
td + geom_point()
td + geom_jitter()
td + geom_jitter(position=position_jitter(width = 0.05))
td + geom_jitter(position=position_jitter(width = 0.05), 
  colour = alpha("black", 1/50))
td + geom_jitter(position=position_jitter(width = 0.05), 
  colour = alpha("black", 1/200))  

d <- ggplot(diamonds, aes(carat, price)) + xlim(1,3)
d + stat_bin2d()
d + stat_binhex()
d + stat_bin2d(bins = 50)
d + stat_binhex(bins = 50)
d + stat_bin2d(binwidth=c(0.02, 200))
d + stat_binhex(binwidth=c(0.02, 200))

d <- ggplot(diamonds, aes(carat, price)) + xlim(1,3)
d + geom_point() + geom_density2d()
d + stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE)
last_plot() + scale_fill_gradient(limits=c(1e-5,8e-4))
d + stat_density2d(geom="point", aes(size = ..density..), contour = FALSE)

d <- subset(diamonds, carat < 2.5 & rbinom(nrow(diamonds), 1, 0.2) == 1)
mod <- lm(log(price) ~ log(carat) * color, data = d)

library(effects)
color <- as.data.frame(effect("color", mod))
carat <- as.data.frame(effect("log(carat)", mod, default.levels = 50))
both1 <-  as.data.frame(effect("log(carat):color", mod))
both2 <-  as.data.frame(effect("log(carat):color", mod, default.levels=5))

fplot <- ggplot(mapping = aes(y = fit, ymin = lower, ymax = upper))
fplot %+% color + aes(x = color) + geom_errorbar()
fplot %+% carat + aes(x = carat) + geom_smooth()

fplot %+% both1 + aes(x = carat, colour = color) + geom_smooth()
fplot %+% both2 + 
  aes(x = color, colour = carat, group = interaction(color, carat)) +
  geom_errorbar() + geom_line(aes(group=carat)) +
  scale_colour_gradient(low=muted("red"), high=muted("blue"))

midwest <- read.csv("~/Documents/weight-and-see/midwest.csv")
qplot(percwhite, percbelowpoverty, data=midwest)
qplot(percwhite, percbelowpoverty, data=midwest, size=poptotal) + scale_area()
qplot(percwhite, percbelowpoverty, data=midwest, size=area) + scale_area()

# \leftc A line of best fit unweighted by population size, and \rightc
# weighted by population size.
lm_smooth <- geom_smooth(method = lm, size = 1)
qplot(percwhite, percbelowpoverty, data = midwest) + lm_smooth 
qplot(percwhite, percbelowpoverty, data = midwest, 
  weight = popdensity, size = popdensity) + lm_smooth

# The different between an \leftc unweighted and \rightc weighted
# histogram.  The unweighted histogram shows number of counties, while
# the weighted histogram shows population
qplot(percbelowpoverty, data=midwest, geom="histogram", binwidth=1)
qplot(percbelowpoverty, data=midwest, geom="histogram", weight=poptotal, binwidth=1) + scale_y_continuous("population")
