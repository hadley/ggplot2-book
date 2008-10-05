set.seed(1410)
dsmall <- diamonds[sample(nrow(diamonds), 1000),]

qplot(carat, price, data=dsmall)

qplot(log(carat), log(price), data=dsmall)

qplot(carat, x * y * z, data=dsmall)

# Mapping colour (using the argument "colour=cut", left), size
# ("size=cut", middle) and shape ("shape=cut", right) of points to
# quality of cut.
qplot(carat, price, data=dsmall, colour=cut)
qplot(carat, price, data=dsmall, size=cut)
qplot(carat, price, data=dsmall, shape=cut)

qplot(carat, price, data=dsmall, geom=c("smooth", "point"))

# The effect of the span parameter.  (Left) \code{span = 0.1}, and
# (right) \code{span = 1}
qplot(carat, price, data=dsmall, geom=c("point", "smooth"), span=0.1)
qplot(carat, price, data=dsmall, geom=c("point", "smooth"), span=1)

# The effect of the formula parameter, using a linear model as a
# smoother.  (Left) \code{formula = y ~ x}, the default; (Right)
# \code{formula = y ~ ns(x, 3)}
library(splines)
qplot(carat, price, data=dsmall, geom=c("point", "smooth"), method="lm")
qplot(carat, price, data=dsmall, geom=c("point", "smooth"), method="lm", formula=y ~ ns(x,3))

# The effect of the formula parameter, using a linear model as a
# smoother.  (Left) \code{formula = y ~ s(x)}, the default; (Right)
# \code{formula = y ~ s(x, bs="cr")}
library(mgcv)
qplot(carat, price, data=dsmall, geom=c("point", "smooth"), method="gam", formula= y ~ s(x))
qplot(carat, price, data=dsmall, geom=c("point", "smooth"), method="gam", formula= y ~ s(x, bs="cr"))

dlittle <- subset(dsmall, carat < 2)
qplot(carat, price, data=dlittle, geom=c("point", "quantile"))

# The \code{formula} argument is used to control the functional form of
# the relation.  ({\sc left}) A natural spline with five degrees of
# freedom, \code{formula = y ~ ns(x, 5)} and ({\sc right}) a linear
# model with break points at 0.5, 1, and 1.5 carats, \code{formula = y
# ~ x + I(x > 0.5) + I(x > 1) + I(x > 1.5))}
qplot(carat, price, data=dlittle, geom=c("point", "quantile"), formula=y~ns(x, 5))
qplot(carat, price, data=dlittle, geom=c("point", "quantile"), formula=y~ x + I(x > 0.5) + I(x > 1) + I(x > 1.5))

# Showing 5\%, 15\%, ..., 95\% quantiles with {\tt quantiles =
# seq(0.05, 0.95, 0.1)}
qplot(carat, price, data=dlittle, geom=c("point", "quantile"), quantiles=seq(0.05,0.95, 0.1))

# Scatterplot of price vs.\ carat supplemented with contours of a 2d
# density estimate ({\tt geom=c(``point'', ``density2d'')}).  Most
# diamonds are small and cheap.
qplot(carat, price, data=diamonds, geom=c("point","density2d"))

# Using jittering (left) and boxplots (right) to investigate the
# distribution of price per carat conditional on colour.  As the colour
# improves (from left to right) the spread of values decreases, but
# there is little change in the middle half of the distribution.
qplot(color, price/carat, data=diamonds, geom="jitter")
qplot(color, price/carat, data=diamonds, geom="boxplot")

# Varying the alpha level.  From left to right: $1/5$, $1/50$, $1/200$.
# As the opacity decreases we begin to see where the bulk of the data
# lies.  However, the boxplot still does much better.
qplot(color, price/carat, data=diamonds, geom="jitter", colour=I(alpha("black", 1/5)))
qplot(color, price/carat, data=diamonds, geom="jitter", colour=I(alpha("black", 1/50)))
qplot(color, price/carat, data=diamonds, geom="jitter", colour=I(alpha("black", 1/200)))

# Displaying the distribution of diamonds.  (Left) \code{geom =
# "histogram"} and (right) \code{geom = "density"}
qplot(carat, data=diamonds, geom="histogram")
qplot(carat, data=diamonds, geom="density")

# Varying the bin width on a histogram of carat reveals interesting
# patterns.  Binwidths from left to right: 1, 0.1, and 0.01 carats.
# Only diamonds with carats between 0 and 3 shown.
qplot(carat, data=diamonds, geom="histogram", binwidth=1, xlim=c(0,3))
qplot(carat, data=diamonds, geom="histogram", binwidth=0.1, xlim=c(0,3))
qplot(carat, data=diamonds, geom="histogram", binwidth=0.01, xlim=c(0,3))

# Mapping a categorical variable to an aesthetic will automatically
# split up the geom by that variable.  (Left) Density plots are
# overlaid and (right) histograms are stacked.
qplot(carat, data=diamonds, geom="density", colour=color, size = I(1.5))
qplot(carat, data=diamonds, geom="histogram", fill=color)

# Bar charts of diamond colour.  The left plot shows counts and the
# right plot is weighted by \code{weight = carat} to show the total
# weight of diamonds of each colour.
qplot(color, data=diamonds, geom="bar")
qplot(color, data=diamonds, geom="bar", weight = carat) + scale_y_continuous("carat")

# Two time series measuring amount of unemployment.  ({\sc left})
# Percent of population that is unemployed and ({\sc right}) median
# number of weeks unemployed.  Plots created with {\tt geom="line"}.
qplot(date, unemploy/pop, data=economics, geom="line")
qplot(date, uempmed, data=economics, geom="line")

year <- function(x) as.POSIXlt(x)$year + 1900
qplot(unemploy/pop, uempmed, data=economics, geom="path")
qplot(unemploy/pop, uempmed, data=economics, geom="path", size=year(date))

# Histograms showing the distribution of carat conditional on colour.
# {\sc (Left)} Bars show counts and ({\sc Right}) bars show densities
# (proportions of the whole).  The density plot makes it easier to
# compare distributions ignoring the relative abundance of diamonds
# within each colour.  Facets created with \code{facets = colour ~ .}
qplot(carat, data=diamonds, facets=color ~ ., geom="histogram", binwidth=0.1, xlim=c(0, 3))
qplot(carat, ..density.., data=diamonds, facets=color ~ ., geom="histogram", binwidth=0.1, xlim=c(0, 3))

qplot(
  carat, price, data=dsmall, 
  xlab="Price ($)", ylab="Weight (carats)",  
  main="Price-weight relationship"
)
qplot(
   carat, price/carat, data=dsmall, 
   ylab = expression(frac(price,carat)), 
   xlab = "Weight (carats)",  
   main="Small diamonds", 
   xlim = c(.2,1)
)
qplot(carat, price, data=dsmall, log="xy")
