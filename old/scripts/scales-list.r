
aes_type <- function(scale) {
  common <- scale$common
  
  if (is.null(common)) {
    input <- scale$input()
    if (input == "") return(NULL)
    return(input)
  }
  if (all(c("colour", "size") %in% common)) return("all")
  if ("x" %in% common) return("position")
  if ("colour" %in% common) return("colour")
}

documented <- Filter(function(s) s$doc, Scales$find_all()) 

names <- invert(compact(lapply(documented, aes_type)))
scales <- lapply(names, function(x) lapply(x, get))



type_table <- function(type) tabulate(ldply(scales[[type]], function(s) c(s$objname, s$desc)))

labels <- c(
  "colour" = "Colour and fill",
  "linetype" = "Line type", 
  "position" = "Position (x, y, z)",
  "shape" = "Shape",
  "size" = "Size",
  "all" = "Multiple aesthetics"
)
type_header <- function(type) {
  paste(
    "\\midrule\n",
    "\\multicolumn{2}{c}{", labels[type], "} \\\\\n",
    "\\midrule\n",
    sep = ""
  )
}
