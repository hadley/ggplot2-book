# ----------------------------
# List of all scales, arranged by the aesthetic that they apply tosource("scales-list.r")
cat(laply(names(scales), function(s) paste(type_header(s), type_table(s), sep ="")))
cat("\\bottomrule\n")

# ----------------------------
# Legends with names given by (from left to right): {\tt "Tip rate"},
# {\tt "The amount of the tip$\backslash$ndivided by the total bill"p <- qplot(tip, total_bill, data=tips, colour=tip/total_bill)
p + scale_colour_hue("Tip rate")
p + scale_colour_hue("The amount of the tip\ndivided by the total bill")
p + scale_colour_hue(expression(frac(tip, total_bill))

# ----------------------------
p <- qplot(sleep_total, sleep_cycle, data=msleep, colour=vore)
p 
p + scale_colour_discrete("What does\nit eat?", 
   breaks = rev(c("herbi", "carni", "omni", NA)), 
   labels = rev(c("plants", "meat", "both", "don't know")))
p + scale_colour_brewer(pal="Set1")

# ----------------------------
set_default_scale("colour", "discrete", "grey")
set_default_scale("colour", "continous", "gradient", 
 low = "white", high = "black"
)

# ----------------------------
# Colour legend, shape legend, colour + shape legend.p <- ggplot(diamonds[1:100, ], aes(x=price, y=carat)) + geom_point() + geom_point() + opts(keep = "legend_box")
p + aes(colour = cut)
ggsave(file="_include/lm-1.pdf", width=1.5, height=1.9)
p + aes(shape = cut)
ggsave(file="_include/lm-2.pdf", width=1.5, height=1.9)
p + aes(shape = cut, colour= cut)
ggsave(file="_include/lm-2.pdf", width=1.5, height=1.9)

