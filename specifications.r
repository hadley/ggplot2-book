
xquiet <- scale_x_continuous("", breaks = NA)
yquiet <- scale_y_continuous("", breaks = NA)

# Shapes ---------------------------------------------------------

shapes <- data.frame(
  shape = c(0:19, 22, 21, 24, 23, 20),
  x = 0:24 %/% 5,
  y = -(0:24 %% 5)
)
qplot(x, y, data=shapes, shape=shape, size=I(5), fill=I("blue")) + scale_shape_identity() + scale_x_continuous("", breaks = NA, limits=c(0, 4.4)) + yquiet + geom_text(aes(x = x + 0.2, label=shape), hjust=0) + opts(background.fill = "grey90")

ggsave(file = "_include/spec-shape.pdf", width=4, height=4)

# Line types -----------------------------------------------------------------

lty <- c("blank", "solid", "dashed", "dotted", "dotdash", "longdash","twodash")

linetypes <- data.frame(
  y = seq_along(lty),
  lty = lty
) 

qplot(0, y, data=linetypes, xend = 5, yend=y, geom="segment", linetype=lty) + xquiet + yquiet + scale_linetype_identity() + geom_text(aes(x = 0, y = y + 0.2, label = lty), hjust = 0) + opts(background.fill = "grey90")

ggsave(file = "_include/spec-linetype.pdf", width=4, height=4)


# Justification --------------------------------------------------------------

draw.text <- function(just, i, j) {
 grid.text("ABCD", x=x[j], y=y[i], just=just, gp=gpar(fontsize=16, colour ="black"))
 grid.text(deparse(substitute(just)), x=x[j], y=y[i] + unit(2, "lines"),
           gp=gpar(col="grey30", fontsize=8, fontface="bold"))
}

pdf("_include/spec-justification.pdf", width=4, height=4)
grid.newpage()
grid.rect(gp= gpar(fill=ggopt()$grid.fill, col=NA))
pos <- c(0.2, 0.5, 0.8)
x <- unit(pos, "npc")
y <- unit(pos, "npc")
grid.grill(h=y, v=x, gp=gpar(col="white"))
draw.text(c(0,   0), 1, 1)
draw.text(c(0.5, 0), 2, 1)
draw.text(c(1,   0), 3, 1)

draw.text(c(0,   0.5), 1, 2)
draw.text(c(0.5, 0.5), 2, 2)
draw.text(c(1,   0.5), 3, 2)

draw.text(c(0,   1), 1, 3)
draw.text(c(0.5, 1), 2, 3)
draw.text(c(1,   1), 3, 3)
dev.off()