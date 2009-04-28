options(digits = 2)

# When ``zooming'' in on the plot, it's useful to use \f{last_plot}
# iteratively to quickly find the best view.  The final plot adds a
# line with slope 1 and intercept 0, confirming it is the square
# diamonds that are missing.
qplot(x, y, data = diamonds, na.rm = TRUE)
last_plot() + xlim(3, 11) + ylim(3, 11)
last_plot() + xlim(4, 10) + ylim(4, 10)
last_plot() + xlim(4, 5) + ylim(4, 5)
last_plot() + xlim(4, 4.5) + ylim(4, 4.5)
last_plot() + geom_abline(colour = "red")

qplot(x, y, data = diamonds, na.rm = T) + 
  geom_abline(colour = "red") +
  xlim(4, 4.5) + ylim(4, 4.5)

# Saving a scale to a variable makes it easy to apply exactly the same
# scale to multiple plots.  You can do the same thing with layers and
# facets too.
gradient_rb <- scale_colour_gradient(low = "red", high = "blue")
qplot(cty, hwy, data = mpg, colour = displ) + gradient_rb
qplot(bodywt, brainwt, data = msleep, colour = awake, log="xy") +
  gradient_rb

# Using ``quiet'' x and y scales removes the labels and hides ticks and
# gridlines.
xquiet <- scale_x_continuous("", breaks = NA)
yquiet <- scale_y_continuous("", breaks = NA)
quiet <- c(xquiet, yquiet)

qplot(mpg, wt, data = mtcars) + quiet
qplot(displ, cty, data = mpg) + quiet

# Creating a custom geom function saves typing when creating plots with
# similar (but not the same) components.
geom_lm <- function(formula = y ~ x) {
  geom_smooth(formula = formula, se = FALSE, method = "lm")
}
qplot(mpg, wt, data = mtcars) + geom_lm()
library(splines)
qplot(mpg, wt, data = mtcars) + geom_lm(y ~ ns(x, 3))

pcp_data <- function(df) {
  numeric <- laply(df, is.numeric)
  # Rescale numeric columns
  df[numeric] <- colwise(range01)(df[numeric])
  # Add row identified
  df$.row <- rownames(df)
  # Melt, using non-numeric variables as id vars
  dfm <- melt(df, id = c(".row", names(df)[!numeric]))
  # Add pcp to class of the data frame
  class(dfm) <- c("pcp", class(dfm))
  dfm
}
pcp <- function(df, ...) {
  df <- pcp_data(df)
  ggplot(df, aes(variable, value)) + geom_line(aes(group = .row))
}
pcp(mpg)
pcp(mpg) + aes(colour = drv)
