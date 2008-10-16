
p <- ggplot(mtcars, aes(x = wt, y = mpg, colour = cyl))

p <- p + layer(geom = ``point'')  

layer(geom, geom_params, stat, stat_params, data, mapping, position)

p <- ggplot(mtcars, aes(x = mpg))
p <- p + layer(
  geom = ``histogram'', 
  geom_params = list(fill = "steelblue"),
  stat = ``bin'',
  stat_params = list(binwidth = 2)
)
p

geom_histogram(binwidth = 2, fill = "steelblue")

geom_XXX(mapping, data, ..., geom, position)
stat_XXX(mapping, data, ..., stat, position)

qplot(mtcars, aes(mpg, wt)) + geom_point()
qplot(mtcars, aes(mpg, wt, colour = factor(cyl))) + geom_smooth()

p <- ggplot(data=mtcars, aes(mpg, wt))
summary(p)

p <- p + geom_point()
summary(p)

p <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
p
mtcars <- transform(mtcars, mpg = mpg ^ 2)
p %+% mtcars

aes(x = weight, y = height, colour = age)

aes(weight, height, colour = sqrt(age))

p <- ggplot(mtcars)
summary(p)

p <- p + aes(wt, hp)
summary(p)

p <- ggplot(mtcars, aes(x = mpg, y = wt))
p + geom_point()

p + geom_point(aes(colour = factor(cyl)))
p + geom_point(aes(y = disp))

p <- ggplot(mtcars, aes(x=mpg, y=wt))
p + geom_point(colour="darkblue")  

p + geom_point(aes(colour="darkblue"))

# The difference between \leftc setting colour to \code{"darkblue"} and
# \rightc mapping colour to \code{"darkblue"}.  When \code{"darkblue"}
# is mapped to colour, it is treated as a regular value and scaled with
# the default colour scale.  This results in pinkish points and a
# legend.
qplot(mpg, wt, data=mtcars, colour = I("darkblue"))
qplot(mpg, wt, data=mtcars, colour = "darkblue")

p <- ggplot(Oxboys, aes(age, height, group = Subject)) + 
  geom_line()
p

# \Leftc correctly specifying {\tt group = Subject} produces one line
# per subject.  \Rightc a single line connects all observations.  This
# pattern is characteristic of an incorrect grouping aesthetic, and is
# what we see if the group aesthetic is omitted.
data(Oxboys, package="nlme")
qplot(age, height, data=Oxboys, group = Subject, geom="line")
qplot(age, height, data=Oxboys, geom="line")

p + geom_smooth(aes(group = Subject), method="lm")

p + geom_smooth(aes(group = 1), method="lm", size = 2)

# Adding smooths to the Oxboys data.  \Leftc using the same grouping as
# the lines results in a line of best fit for each boy.  \Rightc using
# {\tt aes(group = 1)} in the smooth layer fits a single line of best
# fit across all boys.
qplot(age, height, data=Oxboys, group = Subject, geom="line") +
  geom_smooth(method="lm")
qplot(age, height, data=Oxboys, group = Subject, geom="line") +
  geom_smooth(aes(group = 1), method="lm", size = 2)

ggplot(Oxboys, aes(x=Occasion, y=height)) + geom_boxplot()

p <- ggplot(Oxboys, aes(x=Occasion, y=height)) +
 geom_boxplot()
p + geom_line(aes(group=Subject), colour="#3366FF")

# \Leftc if boxplots are used to look at the distribution of heights at
# each occasion (a discrete variable), the default grouping works
# correctly.  \Rightc if trajectories of individual boys are overlaid
# with {\tt geom\_line()} then {\tt aes(group = Subject)} must be set
# for the new layer.
qplot(Occasion, height, data=Oxboys, geom="boxplot")
qplot(Occasion, height, data=Oxboys, geom="boxplot") +
 geom_line(aes(group = Subject), colour="#3366FF")

# For lines and paths, the aesthetics of the line segment are
# determined by the aesthetic of the beginning observation.  \Leftc, if
# colour is categorical, there is no meaningful way to interpolate
# between adjacent colours, \rightc, for continuous variables there is
# but this is not done by default.
df <- data.frame(x = 1:3, y = 1:3, colour = c(1,3,5))
qplot(x, y, data=df, colour=factor(colour), size = I(5)) + 
  geom_line(aes(group = 1), size = 2)
qplot(x, y, data=df, colour=colour, size = I(5)) + geom_line(size = 2)

xgrid <- with(df, seq(min(x), max(x), length = 50))
interp <- data.frame(
  x = xgrid,
  y = approx(df$x, df$y, xout = xgrid)$y,
  colour = approx(df$x, df$colour, xout = xgrid)$y  
)
qplot(x, y, data = df, colour = colour, size = I(5)) + 
  geom_line(data = interp, size = 2)

ggplot(diamonds, aes(x=carat)) + geom_histogram(aes(y=..density..), binwidth=.1)

qplot(carat, ..density.., data = diamonds, geom="histogram", binwidth = .1)

# Three position adjustments applied to a bar chart.  From left to
# right, stacking, filling and dodging.
dplot <- ggplot(diamonds, aes(clarity, fill = cut))
dplot + geom_bar(position = "stack")
dplot + geom_bar(position = "fill")
dplot + geom_bar(position = "dodge")

# The identity positon adjustment is not useful for bars, left, but is
# the default for lines.
dplot + geom_bar(position = "identity")
qplot(clarity, data = diamonds, geom="line", colour = cut, 
  stat="bin", group=cut)

d <- ggplot(diamonds, aes(x=carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), binwidth = 0.1, geom = "area")
d + stat_bin(
  aes(size = ..density..), binwidth = 0.1, 
  geom = "point", position="identity"
)
d + stat_bin(
  aes(y = 1, fill = ..count..), binwidth = 0.1, 
  geom = "tile", position="identity"
)

# Three variations on the histogram. \Leftc a frequency polygon;
# \middlec a scatterplot with both size and height mapped to frequency;
# \rightc an heatmap representing frequency with colour.
d <- ggplot(diamonds, aes(carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), binwidth = 0.1, geom = "area")
d + stat_bin(aes(size = ..density..), binwidth = 0.1, geom = "point", position="identity")
d + stat_bin(aes(y=1, fill = ..count..), binwidth = 0.1, geom = "tile", position="identity") + scale_y_continuous("")

require(nlme, quiet = TRUE, warn.conflicts = FALSE)
model <- lme(height ~ age, data = Oxboys, random = ~ 1 + age | Subject)
oplot <- ggplot(data=Oxboys, aes(x=age, y=height, group=Subject)) + 
  geom_line()

age_grid <- seq(-1, 1, length = 10)
subjects <- unique(Oxboys$Subject)

preds <- expand.grid(age = age_grid, Subject = subjects)
preds$height <- predict(model, preds)

oplot + geom_line(data = preds, colour = "#3366FF", size= 0.4)

Oxboys$fitted <- predict(model)
Oxboys$resid <- with(Oxboys, fitted - height)

oplot %+% Oxboys + aes(y = resid) + geom_smooth(aes(group=1))

model2 <- update(model, height ~ age + I(age ^ 2))
Oxboys$fitted2 <- predict(model2)
Oxboys$resid2 <- with(Oxboys, fitted2 - height)

oplot %+% Oxboys + aes(y = resid2) + geom_smooth(aes(group=1))
