options(digits = 2, width = 60)

# Select the smallest diamond in each colour
ddply(diamonds, .(color), subset, carat == min(carat))

# Select the two smallest diamonds
ddply(diamonds, .(color), subset, order(carat) < 2)

# Select the 1% largest diamonds in each group
ddply(diamonds, .(color), subset, carat > quantile(carat, 0.99))

# Select all diamonds bigger that the group average
ddply(diamonds, .(color), subset, price > mean(price))

# Within each colour, scale price to have mean 0 and variance 1
ddply(diamonds, .(color), transform, price = scale(price))

# Subtract off group mean
ddply(diamonds, .(color), transform, price = price - mean(price))

nmissing <- function(x) sum(is.na(x))
nmissing(msleep$name)
nmissing(msleep$brainwt)

nmissing_df <- colwise(nmissing)
nmissing_df(msleep)
# This is shorthand for the previous two steps
colwise(nmissing)(msleep)

numcolwise(median)(msleep, na.rm = T)
numcolwise(quantile)(msleep, na.rm = T)
numcolwise(quantile)(msleep, probs = c(0.25, 0.75), na.rm = T)

ddply(msleep, .(vore), numcolwise(median), na.rm = T)
ddply(msleep, .(vore), numcolwise(mean), na.rm = T)

my_summary <- function(df) {
  with(df, data.frame(
    pc_cor = cor(price, carat, method = "spearman"),
    lpc_cor = cor(log(price), log(carat))
  ))
}
ddply(diamonds, .(cut), my_summary)
ddply(diamonds, .(color), my_summary)

# A plot showing the smoothed trends for price vs
# carat for each colour of diamonds.  With the full
# range of carats (left), the standard errors balloon
# after around two carats because there are
# relatively few diamonds of that size.  Restricting
# attention to diamonds of less than two carats
# (right) focuses on the region where we have plenty
# of data.
qplot(carat, price, data = diamonds, geom = "smooth", colour = color)
dense <- subset(diamonds, carat < 2)
qplot(carat, price, data = dense, geom = "smooth", colour = color, 
  fullrange = TRUE)

# Figure~\ref{fig:smooth} with all statistical
# calculations performed by hand.  The predicted
# values (left), and with standard errors (right).
library(mgcv)
smooth <- function(df) {
  mod <- gam(price ~ s(carat, bs = "cs"), data = df)
  grid <- data.frame(carat = seq(0.2, 2, length = 50))
  pred <- predict(mod, grid, se = T)
  
  grid$price <- pred$fit
  grid$se <- pred$se.fit
  grid
}
smoothes <- ddply(dense, .(color), smooth)
qplot(carat, price, data = smoothes, colour = color, geom = "line")
qplot(carat, price, data = smoothes, colour = color, geom = "smooth",
  ymax = price + 2 * se, ymin = price - 2 * se)

mod <- gam(price ~ s(carat, bs = "cs") + color, data = dense)
grid <- with(diamonds, expand.grid(
  carat = seq(0.2, 2, length = 50),
  color = levels(color)
))
grid$pred <- predict(mod, grid)
qplot(carat, pred, data = grid, colour = color, geom = "line")

# When the economics data set is stored in wide
# format, it is easy to create separate time series
# plots for each variable (left and centre), and easy
# to create scatterplots comparing them (right).
qplot(date, uempmed, data = economics, geom = "line")
qplot(date, unemploy, data = economics, geom = "line")
qplot(unemploy, uempmed, data = economics) + geom_smooth()

# The two methods of displaying both series on a
# single plot produce identical plots, but using long
# data is much easier when you have many variables.
# The series have radically different scales, so we
# only see the pattern in the \code{unemploy}
# variable. You might not even notice \code{unempmed}
# unless you're paying close attention: it's the line
# at the bottom of the plot.
ggplot(economics, aes(date)) + 
  geom_line(aes(y = unemploy, colour = "unemploy")) + 
  geom_line(aes(y = uempmed, colour = "umempmed")) + 
  scale_colour_hue("variable")

emp <- melt(economics, id = "date", measure = c("unemploy", "uempmed"))
qplot(date, value, data = emp, geom = "line", colour = variable)

# When the series have very different scales we have
# two alternatives: left, rescale the variables to a
# common scale, or right, display the variables on
# separate facets and using free scales.
range01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / diff(rng)
}
emp2 <- ddply(emp, .(variable), transform, value = range01(value))
qplot(date, value, data = emp2, geom = "line", 
  colour = variable, linetype = variable)
qplot(date, value, data = emp, geom = "line") + 
  facet_grid(variable ~ ., scales = "free_y")

popular <- subset(movies, votes > 1e4)
ratings <- popular[, 7:16]
ratings$.row <- rownames(ratings)
molten <- melt(ratings, id = ".row")

# Variants on the parallel coordinates plot to better
# display the patterns in this highly discrete data.
# To improve the default pcp (top-left) we experiment
# with alpha-blending (top-right), jittering
# (bottom-left) and then both together
# (bottom-right).
pcp <- ggplot(molten, aes(variable, value, group = .row))
pcp + geom_line()
pcp + geom_line(colour = alpha("black", 1 / 20))
jit <- position_jitter(width = 0.25, height = 2.5)
pcp + geom_line(position = jit)
pcp + geom_line(colour = alpha("black", 1 / 20), position = jit)

cl <- kmeans(ratings[1:10], 6)
ratings$cluster <- reorder(factor(cl$cluster), popular$rating)
levels(ratings$cluster) <- seq_along(levels(ratings$cluster))
molten <- melt(ratings, id = c(".row", "cluster"))

# Displaying cluster membership on a parallel
# coordinates plot.  (Left) individual movies
# coloured by group membership and (right) group
# means.
pcp_cl <- ggplot(molten, 
 aes(variable, value, group = .row, colour = cluster)) 
pcp_cl + geom_line(position = jit) + scale_colour_hue(alpha = 1/5)
pcp_cl + stat_summary(aes(group = cluster), fun.y = mean, geom = "line")

# Faceting allows us to display each group in its own
# panel, highlighting the fact that there seems to be
# considerable variation within each group, and
# suggesting that we need more groups in our
# clustering.
pcp_cl + geom_line(position = jit, colour = alpha("black", 1/5)) +
  facet_wrap(~ cluster)

# A simple linear model that doesn't fit the data
# very well.
qplot(displ, cty, data = mpg) + geom_smooth(method = "lm")
mpgmod <- lm(cty ~ displ, data = mpg)

# Basic fitted values-residual plot, left.  With
# standardised residuals, centre.  With size
# proportional to Cook's distance, right.  It is easy
# to modify the basic plots when we have access to
# all of the data.
mod <- lm(cty ~ displ, data = mpg)
basic <- ggplot(mod, aes(.fitted, .resid)) +
  geom_hline(yintercept = 0, colour = "grey50", size = 0.5) + 
  geom_point() + 
  geom_smooth(size = 0.5, se = F)
basic
basic + aes(y = .stdresid)
basic + aes(size = .cooksd) + scale_area("Cook's distance")

# Adding variables from the original data can be
# enlightening.  Here when we add the number of
# cylinders we see that instead of a curvi-linear
# relationship between displacement and city mpg, it
# is essentially linear, conditional on the number of
# cylinders.
full <- basic %+% fortify(mod, mpg)
full + aes(colour = factor(cyl))
full + aes(displ, colour = factor(cyl))

fortify.Image <- function(model, data, ...) {
  colours <- channel(model, "x11")[,,]
  colours <- colours[, rev(seq_len(ncol(colours)))]
  melt(colours, c("x", "y"))
}

library(EBImage)
img <- readImage("http://had.co.nz/me.jpeg", TrueColor)
qplot(x, y, data = img, fill = value, geom="tile") + 
  scale_fill_identity() + coord_equal()
