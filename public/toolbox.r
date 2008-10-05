
# The basic geoms applied to the same data.  Many give rise to to named
# plots (from top-left to bottom-right): scatterplot, barchart, line
# chart, area chart, path plot, labelled scatterplot, image/level plot
# and polygon plot.  Observe the different axis ranges for the bar
# chart and image plot - these geoms take up space outside the range of
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
