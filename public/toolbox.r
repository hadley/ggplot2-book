library(effects)

# The basic geoms applied to the same data.  Many give rise to to named
# plots (from top left to bottom right): scatterplot, bar chart, line
# chart, area chart, path plot, labelled scatterplot, image/level plot
# and polygon plot.  Observe the different axis ranges for the bar,
# area and tile plots: these geoms take up space outside the range of
# the data, and so push the axes out.
df <- data.frame(
  x = c(3, 1, 5), 
  y = c(2, 4, 6), 
  label = c("a","b","c")
)
p <- ggplot(df, aes(x, y, label = label)) + 
  xlab(NULL) + ylab(NULL)
p + geom_point() + opts(title = "geom_point")
p + geom_bar(stat="identity") + 
  opts(title = "geom_bar(stat=\"identity\")")
p + geom_line() + opts(title = "geom_line")
p + geom_area() + opts(title = "geom_area")
p + geom_path() + opts(title = "geom_path")
p + geom_text() + opts(title = "geom_text")
p + geom_tile() + opts(title = "geom_tile")
p + geom_polygon() + opts(title = "geom_polygon")

# (Left) Never rely on the default parameters to get a revealing view
# of the distribution.  (Right) Zooming in on the x axis, {\tt xlim =
# c(55, 70)}, and selecting a smaller bin width, {\tt binwidth = 0.1},
# reveals far more detail. We can see that the distribution is slightly
# skew-right. Don't forget to include information about important
# parameters (like bin width) in the caption.
qplot(depth, data=diamonds, geom="histogram")
qplot(depth, data=diamonds, geom="histogram", xlim=c(55, 70), binwidth=0.1)

# Three views of the distribution of depth and cut.  From top to
# bottom: faceted histogram, a conditional density plot, and frequency
# polygons.  All show an interesting pattern: as quality increases, the
# distribution shifts to the left and becomes more symmetric.
depth_dist <- ggplot(diamonds, aes(depth)) + xlim(58, 68)
depth_dist + 
  geom_histogram(aes(y = ..density..), binwidth = 0.1) +
  facet_grid(cut ~ .)
depth_dist + geom_histogram(aes(fill = cut), binwidth = 0.1, 
  position = "fill")
depth_dist + geom_freqpoly(aes(y = ..density.., colour = cut), 
  binwidth = 0.1) 

# The boxplot geom can be use to see the distribution of a continuous
# variable conditional on a discrete varable like cut (left), or
# continuous variable like carat (right).  For continuous variables,
# the group aesthetic must be set to get multiple boxplots.  Here {\tt
# group = round\_any(carat, 0.1, floor)} is used to get a boxplot for
# each 0.1 carat bin.
qplot(cut, depth, data=diamonds, geom="boxplot")
qplot(carat, depth, data=diamonds, geom="boxplot", 
  group = round_any(carat, 0.1, floor), xlim = c(0, 3))

# The jitter geom can be used to give a crude visualisation of 2d
# distributions with a discrete component.  Generally this works better
# for smaller datasets.  Car class vs. continuous variable city mpg
# (top) and discrete variable drive train (bottom).
qplot(class, cty, data=mpg, geom="jitter")
qplot(class, drv, data=mpg, geom="jitter")

# The density plot is a smoothed version of the histogram.  It has
# desirable theoretical properties, but is more difficult to relate
# back to the data.  A density plot of depth (left), coloured by cut
# (right).
qplot(depth, data=diamonds, geom="density", xlim = c(54, 70))
qplot(depth, data=diamonds, geom="density", xlim = c(54, 70), 
  fill = cut, alpha = I(0.2))

# Modifying the glyph used can help with mild to moderate overplotting.
# From left to right: the default shape, {\tt shape = 1} (hollow
# points), and {\tt shape= "."} (pixel points).
df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y))
norm + geom_point()
norm + geom_point(shape = 1)
norm + geom_point(shape = ".") # Pixel sized

# Using alpha blending to alleviate overplotting in sample data from a
# bivariate normal.  Alpha values from left to right: 1/3, 1/5, 1/10.
norm + geom_point(colour = alpha("black", 1/3))
norm + geom_point(colour = alpha("black", 1/5))
norm + geom_point(colour = alpha("black", 1/10))

# A plot of table vs. depth from the diamonds data, showing the use of
# jitter and alpha blending to alleviate overplotting in discrete data.
# From left to right: geom point, geom jitter with default jitter, geom
# jitter with horizontal jitter of 0.5 (half the gap between bands),
# alpha of 1/10, alpha of 1/50, alpha of 1/200.
td <- ggplot(diamonds, aes(table, depth)) + 
  xlim(50, 70) + ylim(50, 70)
td + geom_point()
td + geom_jitter()
jit <- position_jitter(width = 0.5)
td + geom_jitter(position = jit)
td + geom_jitter(position = jit, colour = alpha("black", 1/10))
td + geom_jitter(position = jit, colour = alpha("black", 1/50))
td + geom_jitter(position = jit, colour = alpha("black", 1/200))  

# Binning with, top row, square bins, and bottom row, hexagonal bins.
# Left column uses default parameters, middle column {\tt bins = 10},
# and right column {\tt binwidth = c(0.02, 200)}.  Legends have been
# omitted to save space.
d <- ggplot(diamonds, aes(carat, price)) + xlim(1,3) +
  opts(legend.position = "none")
d + stat_bin2d()
d + stat_bin2d(bins = 10)
d + stat_bin2d(binwidth=c(0.02, 200))
d + stat_binhex()
d + stat_binhex(bins = 10)
d + stat_binhex(binwidth=c(0.02, 200))

# Using density estimation to model and visualise point densities.
# (Top) Image displays of the density; (bottom) point and contour based
# displays.
d <- ggplot(diamonds, aes(carat, price)) + xlim(1,3) + 
  opts(legend.position = "none")
d + geom_point() + geom_density2d()
d + stat_density2d(geom = "point", aes(size = ..density..), 
 contour = F) + scale_area(to = c(0.2, 1.5))
d + stat_density2d(geom = "tile", aes(fill = ..density..), 
  contour = F) 
last_plot() + scale_fill_gradient(limits = c(1e-5,8e-4))

# Example using the borders function.  (Left) All cities with
# population (as of January 2006) of greater than half a million,
# (right) cities in Texas.
library(maps)
data(us.cities)
big_cities <- subset(us.cities, pop > 500000)
qplot(long, lat, data = big_cities) + borders("state", size = 0.5)

tx_cities <- subset(us.cities, country.etc == "TX")
ggplot(tx_cities, aes(long, lat)) +
  borders("county", "texas", colour = "grey70") +
  geom_point(colour = alpha("black", 0.5))

# Two choropleth maps showing number of assaults (left) and the ratio
# of assaults to murders (right).
library(maps)
states <- map_data("state")
arrests <- USArrests
names(arrests) <- tolower(names(arrests))
arrests$region <- tolower(rownames(USArrests))

choro <- merge(states, arrests, by = "region")
# Reorder the rows because order matters when drawing polygons
# and merge destroys the original ordering
choro <- choro[order(choro$order), ]
qplot(long, lat, data = choro, group = group, 
  fill = assault, geom = "polygon")
qplot(long, lat, data = choro, group = group, 
  fill = assault / murder, geom = "polygon")

ia <- map_data("county", "iowa")
mid_range <- function(x) mean(range(x, na.rm = TRUE))
centres <- ddply(ia, .(subregion), 
  colwise(mid_range, .(lat, long)))
ggplot(ia, aes(long, lat)) + 
  geom_polygon(aes(group = group), 
    fill = NA, colour = "grey60") +
  geom_text(aes(label = subregion), data = centres, 
    size = 2, angle = 45)

d <- subset(diamonds, carat < 2.5 & 
  rbinom(nrow(diamonds), 1, 0.2) == 1)
d$lcarat <- log10(d$carat)
d$lprice <- log10(d$price)

# Remove overall linear trend
detrend <- lm(lprice ~ lcarat, data = d)
d$lprice2 <- resid(detrend)

mod <- lm(lprice2 ~ lcarat * color, data = d)

library(effects)
effectdf <- function(...) {
  suppressWarnings(as.data.frame(effect(...)))
}
color <- effectdf("color", mod)
both1 <- effectdf("lcarat:color", mod)

carat <- effectdf("lcarat", mod, default.levels = 50)
both2 <- effectdf("lcarat:color", mod, default.levels = 3)

# Data transformed to remove most obvious effects.  (Left) Both x and y
# axes are log10 transformed to remove non-linearity.  (Right) The
# major linear trend is removed.
qplot(lcarat, lprice, data=d, colour = color)
qplot(lcarat, lprice2, data=d, colour = color)

# Displaying uncertainty in model estimates for colour.  (Left)
# Marginal effect of colour.  (Right) conditional effects of colour for
# different levels of carat.  Error bars show 95\% pointwise confidence
# intervals.
fplot <- ggplot(mapping = aes(y = fit, ymin = lower, ymax = upper)) +
  ylim(range(both2$lower, both2$upper))
fplot %+% color + aes(x = color) + geom_point() + geom_errorbar()
fplot %+% both2 + 
  aes(x = color, colour = lcarat, group = interaction(color, lcarat)) +
  geom_errorbar() + geom_line(aes(group=lcarat)) +
  scale_colour_gradient()

# Displaying uncertainty in model estimates for carat.  (Left) marginal
# effect of carat.  (Right) conditional effects of carat for different
# levels of colour.  Bands show 95\% point-wise confidence intervals.
fplot %+% carat + aes(x = lcarat) + geom_smooth(stat="identity")

ends <- subset(both1, lcarat == max(lcarat))
fplot %+% both1 + aes(x = lcarat, colour = color) +
 geom_smooth(stat="identity") + 
 scale_colour_hue() + opts(legend.position = "none") +
 geom_text(aes(label = color, x = lcarat + 0.02), ends)

# Examples of \code{stat_summary} in use.  (Top) Continuous x with,
# from left to right, median and line, \f{median_hilow} and smooth,
# mean and line, and \f{mean_cl_boot} and smooth.  (Bottom) Discrete x
# with, from left to right, \f{mean} and point, \f{mean_cl_normal} and
# error bar, \f{median_hilow} and point range, and \f{median_hilow} and
# crossbar.  Note that \ggplot displays the full range of the data, not
# just the range of the summary statistics.
m <- ggplot(movies, aes(year, rating))
m + stat_summary(fun.y = "median", geom = "line")
m + stat_summary(fun.data = "median_hilow", geom = "smooth")
m + stat_summary(fun.y = "mean", geom = "line")
m + stat_summary(fun.data = "mean_cl_boot", geom = "smooth")
m2 <- ggplot(movies, aes(round(rating), log10(votes)))
m2 + stat_summary(fun.y = "mean", geom = "point")
m2 + stat_summary(fun.data = "mean_cl_normal", geom = "errorbar")
m2 + stat_summary(fun.data = "median_hilow", geom = "pointrange")
m2 + stat_summary(fun.data = "median_hilow", geom = "crossbar")

midm <- function(x) mean(x, trim = 0.5)
m2 + 
  stat_summary(aes(colour = "trimmed"), fun.y = midm, 
    geom = "point") +
  stat_summary(aes(colour = "raw"), fun.y = mean, 
    geom = "point") + 
  scale_colour_hue("Mean")

iqr <- function(x, ...) {
  qs <- quantile(as.numeric(x), c(0.25, 0.75), na.rm = T)
  names(qs) <- c("ymin", "ymax")
  qs
}
m + stat_summary(fun.data = "iqr", geom="ribbon")

(unemp <- qplot(date, unemploy, data=economics, geom="line", 
  xlab = "", ylab = "No. unemployed (1000s)"))

presidential <- presidential[-(1:3), ]

yrng <- range(economics$unemploy)
xrng <- range(economics$date)
unemp + geom_vline(aes(xintercept = start), data = presidential)
unemp + geom_rect(aes(NULL, NULL, xmin = start, xmax = end, 
  fill = party), ymin = yrng[1], ymax = yrng[2], 
  data = presidential) + scale_fill_manual(values = 
  alpha(c("blue", "red"), 0.2))
last_plot() + geom_text(aes(x = start, y = yrng[1], label = name), 
  data = presidential, size = 3, hjust = 0, vjust = 0)
caption <- paste(strwrap("Unemployment rates in the US have 
  varied a lot over the years", 40), collapse="\n")
unemp + geom_text(aes(x, y, label = caption), 
  data = data.frame(x = xrng[2], y = yrng[2]), 
  hjust = 1, vjust = 1, size = 4)

highest <- subset(economics, unemploy == max(unemploy))
unemp + geom_point(data = highest, 
  size = 3, colour = alpha("red", 0.5))

# Using size to display weights.  No weighting (left), weighting by
# population (centre) and by area (right).
qplot(percwhite, percbelowpoverty, data = midwest)
qplot(percwhite, percbelowpoverty, data = midwest, 
  size = poptotal / 1e6) + scale_area("Population\n(millions)", 
  breaks = c(0.5, 1, 2, 4))
qplot(percwhite, percbelowpoverty, data = midwest, size = area) + 
  scale_area()

# An unweighted line of best fit (left) and weighted by population size
# (right).
lm_smooth <- geom_smooth(method = lm, size = 1)
qplot(percwhite, percbelowpoverty, data = midwest) + lm_smooth 
qplot(percwhite, percbelowpoverty, data = midwest, 
  weight = popdensity, size = popdensity) + lm_smooth

# The difference between an unweighted (left) and weighted (right)
# histogram.  The unweighted histogram shows number of counties, while
# the weighted histogram shows population.  The weighting considerably
# changes the interpretation!
qplot(percbelowpoverty, data = midwest, binwidth = 1)
qplot(percbelowpoverty, data = midwest, weight = poptotal, 
  binwidth = 1) + ylab("population")
