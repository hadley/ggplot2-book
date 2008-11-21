
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
# a smaller bin width reveals far more detail, {\tt xlim = c(55, 70),
# binwidth = 0.1}.  We can see that the distribution is slightly
# skew-right.  Don't forget to include information about important
# parameters (like bin width) in the caption.
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
# variable conditional on a discrete varable like cut, \leftc, or
# continuous variable like carat, \rightc.  For continuous variables,
# the group aesthetic must be set to get multiple boxplots.  Here {\tt
# group = round\_any(carat, 0.1, floor)} is used to get a boxplot for
# each 0.1 carat bin.
qplot(cut, depth, data=diamonds, geom="boxplot")
qplot(carat, depth, data=diamonds, geom="boxplot", 
  group = round_any(carat, 0.1, floor), xlim = c(0, 3))

# The jitter geom can give a crude visualisation of 2d distributions
# with a discrete component.  Generally this works better for smaller
# datasets.  Car class vs \leftc, city mpg (continuous) and \rightc
# drive train (discrete).
qplot(class, cty, data=mpg, geom="jitter")
qplot(class, drv, data=mpg, geom="jitter")

# The density plot is a smoothed version of the histogram.  It has
# desirable theoretical properties, but is more difficult to relate
# directly back to the data.  \Leftc a density plot of depth, and
# \rightc faceted by cut.
qplot(depth, data=diamonds, geom="density", xlim = c(54, 70))
qplot(depth, data=diamonds, geom="density", xlim = c(54, 70), 
  fill = cut) + scale_fill_hue(alpha = 0.2)

# Modifying the glyph used can help with mild to moderate overplotting.
# From left to right: the defaults, {\tt shape = 1} (hollow points),
# {\tt size = 0.5}, and {\tt shape= "."}.
df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y))
norm + geom_point()
norm + geom_point(shape = 1)
norm + geom_point(size = 0.5) # 1/2 mm 
norm + geom_point(shape = ".") # Pixel sized

# Using alpha blending to alleviate overplotting in sample data from a
# bivariate normal.  Alpha values from left to right: 1, 1/2, 1/5,
# 1/10.
norm + geom_point()
norm + geom_point(colour = alpha("black", 1/2))
norm + geom_point(colour = alpha("black", 1/5))
norm + geom_point(colour = alpha("black", 1/10))

# A plot of table vs depth from the diamonds data, showing the use of
# jitter and alpha blending to alleviate overplotting in discrete data.
# From left to right: geom point, geom jitter with default jitter, geom
# jitter with horizontal jitter of 0.5 (half the gap between bands)
# alpha of 1/10, alpha of 1/50, alpha of 1/200.
td <- ggplot(diamonds, aes(table, depth)) + xlim(50, 70) + ylim(50, 70)
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
# Top, image displays of the density; bottom, point and contour based
# displays.
d <- ggplot(diamonds, aes(carat, price)) + xlim(1,3) + 
  opts(legend.position = "none")
d + geom_point() + geom_density2d()
d + stat_density2d(geom="point", aes(size = ..density..), contour = FALSE)

d + stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE) 
last_plot() + scale_fill_gradient(limits=c(1e-5,8e-4))

# Examples of \code{stat_summary} in use.  Top, continuous x with, from
# left to right, median and line, \f{median_hilow} and smooth, mean and
# line, and \f{mean_cl_boot} and smooth.  Bottom, discrete x, with,
# from left to right, \f{mean} and point, \f{mean_cl_normal} and error
# bar, \f{median_hilow} and point range, and \f{median_hilow} and
# crossbar.  Note that by default \ggplot displays the full range of
# the data, not just the results of the summary statistics.
m <- ggplot(movies, aes(year, rating))
m + stat_summary(fun = "median", geom="line")
m + stat_summary(fun = "median_hilow", geom="smooth")
m + stat_summary(fun = "mean", geom="line")
m + stat_summary(fun = "mean_cl_boot", geom="smooth")
m2 <- ggplot(movies, aes(round(rating), log10(votes)))
m2 + stat_summary(fun = "mean", geom="point")
m2 + stat_summary(fun = "mean_cl_normal", geom="errorbar")
m2 + stat_summary(fun = "median_hilow", geom="pointrange")
m2 + stat_summary(fun = "median_hilow", geom="crossbar")

iqr <- function(data, ...) {
  data.frame(
    ymin = quantile(data$y, 1/4), 
    ymax = quantile(data$y, 3/4)
  )  
}
m + stat_summary(fun = "iqr", geom="ribbon")

midm <- function(x) mean(x, trim = 0.5)
m2 + 
  stat_summary(aes(colour = "trimmed"), fun = midm, geom="point") +
  stat_summary(aes(colour = "raw"), fun = mean, geom="point") + 
  scale_colour_hue("Mean")

d <- subset(diamonds, carat < 2.5 & rbinom(nrow(diamonds), 1, 0.2) == 1)
d$lcarat <- log10(d$carat)
d$lprice <- log10(d$price)

# Remove over all linear trend
detrend <- lm(lprice ~ lcarat, data = d)
d$lprice2 <- resid(detrend)

mod <- lm(lprice2 ~ lcarat * color, data = d)

library(effects)
color <- as.data.frame(effect("color", mod))
both1 <- as.data.frame(effect("lcarat:color", mod))

carat <- as.data.frame(effect("lcarat", mod, default.levels = 50))
both2 <- as.data.frame(effect("lcarat:color", mod, default.levels = 3))

# Data transformed to remove most obvious effects.  Left, both x and y
# axes are log10 transformed to remove non-linearity.  Right, the major
# linear trend is removed.
qplot(lcarat, lprice, data=d, colour = color)
qplot(lcarat, lprice2, data=d, colour = color)

# Displaying uncertaintly in model estimates for colour.  Left,
# marginal effect of colour, and right, conditional effects of colour
# for different levels of carat.  Error bars show 95\% pointwise
# confidence intervals.
fplot <- ggplot(mapping = aes(y = fit, ymin = lower, ymax = upper))
fplot %+% color + aes(x = color) + geom_point() + geom_errorbar()
fplot %+% both2 + 
  aes(x = color, colour = lcarat, group = interaction(color, lcarat)) +
  geom_errorbar() + geom_line(aes(group=lcarat)) +
  scale_colour_gradient(low=muted("red"), high=muted("blue"))

# Displaying uncertaintly in model estimates for carat.  Left, marginal
# effect of carat, and right, conditional effects of carat for
# different levels of colour.  Bands show 95\% point-wise confidence
# intervals
fplot %+% carat + aes(x = lcarat) + geom_smooth(stat="identity")

ends <- subset(both1, lcarat == max(lcarat))
fplot %+% both1 + aes(x = lcarat, colour = color) +
 geom_smooth(stat="identity") + 
 scale_colour_hue() + opts(legend.position = "none") +
 geom_text(aes(label = color, x = lcarat + 0.02), ends)

(unemp <- qplot(date, unemploy, data=economics, geom="line"))

load("~/documents/data/08-presidents/presidents.rdata")
presidents <- presidents[-(1:3), ]

yrng <- range(economics$unemploy)
xrng <- range(economics$date)
unemp + geom_vline(aes(intercept = as.numeric(start)), data = presidents)
unemp + geom_rect(aes(xmin = start, xmax = end, y = NULL, x = NULL, 
  fill = party), ymin = yrng[1], ymax = yrng[2], data=presidents) +
  scale_fill_manual(values = alpha(c("blue", "red"), 0.2))
last_plot() + geom_text(aes(x = start, y = yrng[1], label = name), 
  data = presidents, size = 3, hjust = 0, vjust = 0)
caption <- paste(strwrap("Unemployment rates in the US have varied a 
  lot over the years", 40), collapse="\n")
unemp + geom_text(aes(x = xrng[2], y = yrng[2], label = caption), 
  data=data.frame(), hjust = 1, vjust = 1, size = 4)

highest <- subset(economics, unemploy == max(unemploy))
unemp + geom_point(colour = alpha("red", 0.5), data = highest, size = 3)

midwest <- read.csv("~/Documents/weight-and-see/midwest.csv")
qplot(percwhite, percbelowpoverty, data=midwest)
qplot(percwhite, percbelowpoverty, data=midwest, size=poptotal) + scale_area()
qplot(percwhite, percbelowpoverty, data=midwest, size=area) + scale_area()

# \Leftc, A line of best fit unweighted by population size, and
# \rightc, weighted by population size.
lm_smooth <- geom_smooth(method = lm, size = 1)
qplot(percwhite, percbelowpoverty, data = midwest) + lm_smooth 
qplot(percwhite, percbelowpoverty, data = midwest, 
  weight = popdensity, size = popdensity) + lm_smooth

# The different between a, \leftc, unweighted and \rightc, weighted
# histogram.  The unweighted histogram shows number of counties, while
# the weighted histogram shows population
qplot(percbelowpoverty, data=midwest, geom="histogram", binwidth=1)
qplot(percbelowpoverty, data=midwest, geom="histogram", weight=poptotal, binwidth=1) + scale_y_continuous("population")
