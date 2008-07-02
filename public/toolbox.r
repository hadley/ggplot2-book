
# ----------------------------
midwest <- read.csv("~/Documents/weight-and-see/midwest.csv")
qplot(percwhite, percbelowpoverty, data=midwest)
qplot(percwhite, percbelowpoverty, data=midwest, size=poptotal) + scale_area()
qplot(percwhite, percbelowpoverty, data=midwest, size=area) + scale_area()

# ----------------------------
# \leftc A line of best fit unweighted by population size, and \rightc
# weighted by population size.lm_smooth <- geom_smooth(method = lm, size = 1)
qplot(percwhite, percbelowpoverty, data = midwest) + lm_smooth 
qplot(percwhite, percbelowpoverty, data = midwest, 
  weight = popdensity, size = popdensity) + lm_smooth

# ----------------------------
# The different between an \leftc unweighted and \rightc weighted
# histogram.  The unweighted histogram shows number of counties, while
# the weighted histogram shows populationqplot(percbelowpoverty, data=midwest, geom="histogram", binwidth=1)
qplot(percbelowpoverty, data=midwest, geom="histogram", weight=poptotal, binwidth=1) + scale_y_continuous("population")
