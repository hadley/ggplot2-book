draw <- function(., data, scales, coordinates, ...) {    
  with(data, pointsGrob(
      x, y, size = unit(size, "mm"), pch = shape, 
      gp = gpar(col = colour, fill = fill, fontsize = size * .pt))
  )
}

draw <- function(., data, scales, coordinates, ...) {    
  with(coordinates$transform(data, scales), 
    ggname(.$my_name(), pointsGrob(x, y, size=unit(size, "mm"), pch=shape, 
    gp=gpar(col=colour, fill = fill, fontsize = size * .pt)))
  )
}
