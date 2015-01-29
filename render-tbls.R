# Generate some tables from the ggplot2 documentation site
library("rvest")
library("plyr")
library("dplyr")
library("magrittr")
library("xtable")
library("methods")

# This script places tex files here
if (!file_test("-d", "tbls")) dir.create("tbls")

# do we need to escape special LaTeX characters (I think knitr can do this for us)?
# options(xtable.sanitize.text.function = identity)
# function used in some chapters for displaying code in tables
clean_txt <- function(x) gsub("\\s+", " ", gsub("\\n", "", x))

# function to grab most recent geoms, stats, etc.
get_verb <- function(verb) {
  x <- html("http://docs.ggplot2.org/current/") %>% 
  html_nodes(paste0("a:contains('", verb, "')")) %>%
  html_text(trim = TRUE)
  # only keep elements that *begin* with the verb
  prefix <- paste0("^", verb)
  x[grepl(prefix, x)]
  #if (strip) sub(prefix, "", x) else x
}

geoms <- get_verb("geom_")
stats <- get_verb("stat_")
positions <- get_verb("position_")
coords <- get_verb("coord_")

# Get information on each geom
get_info <- function(x, trim = TRUE) {
  site <- html(paste0("http://docs.ggplot2.org/current/", x, ".html")) 
  # Description of the geom
  desc <- site %>% html_node(".Description p") %>% html_text(trim = TRUE)
  desc <- clean_txt(desc)
  # Default stat for the geom
  defs <- site %>% html_node("pre") %>% html_text(trim = TRUE) %>% 
    strsplit(", ") %>% unlist
  stat <- sub("^stat = ", "", defs[grepl("^stat = ", defs)])
  # aesthetics for the geom (preserves bolding)
  aez <- try_aes(site) 
  aez_bold <- try_aes(site, "strong") 
  bolded <- aez %in% aez_bold & aez != "none"
  aez[bolded] <- paste0("\\textbf{", aez[bolded], "}")
  aez <- paste(aez, collapse = ", ")
  if (trim) x <- sub("^.*_", "", x)
  c(Name = x, `Default Stat` = stat, Aesthetics = aez, Description = desc)
}

# not all geoms have (required) aesthetics
try_aes <- function(site, ...){
  plyr::try_default({
    site %>% html_nodes(paste(".Aesthetics li", ...)) %>% 
    html_text(trim = TRUE)
  }, "none", quiet = TRUE)
}

# Geom specific tables
geom_info <- t(sapply(geoms, get_info, USE.NAMES = FALSE))

# How to automatically detect and wrap functions in code markup??
print(xtable(geom_info[, c("Name", "Description")], 
             caption = "Geoms in \\texttt{ggplot}",
             label = "geoms"), file = "tbls/geoms.tex")
print(xtable(geom_info[, c("Name", "Default Stat", "Aesthetics")], 
             caption = "Default statistics and aesthetics. 
             Emboldened aesthetics are required.",
             label = "geom-aesthetics"), file = "tbls/geom-aesthetics.tex")
# Stat specific tables
stat_info <- t(sapply(stats, get_info, USE.NAMES = FALSE))
print(xtable(stat_info[, c("Name", "Description")],  
             caption = "Stats in \\texttt{ggplot}",
             label = "stats"), file = "tbls/stats.tex")
# Position specific tables
pos_info <- t(sapply(positions, get_info, USE.NAMES = FALSE))
print(xtable(pos_info[, c("Name", "Description")],  
             caption = "The five position adjustments.",
             label = "position"), file = "tbls/position.tex")
# Coordinate specific tables
coord_info <- t(sapply(coords, get_info, USE.NAMES = FALSE))
print(xtable(coord_info[, c("Name", "Description")],  
             caption = "Coordinate systems available in ggplot. 
\\texttt{coord_equal()}, \\texttt{coord_flip()} and \\texttt{coord_trans()} 
are all basically Cartesian in nature (i.e., the dimensions combine orthogonally), 
while \\texttt{coord_map()} and \\texttt{coord_polar()} are more complex.",
             label = "coord"), file = "tbls/coord.tex")

# Theme elements
elems <- html("http://docs.ggplot2.org/current/theme.html") %>% html_table()
elems <- setNames(elems[[1]], c("Theme element", "Description"))
elems[,2] <- clean_txt(elems[,2])
print(xtable(elems,
             caption = "Theme elements.",
             label = "elements"), file = "tbls/elements.tex")

# Get default aesthetic values for each geom (in polishing chapter)
# adapted from http://stackoverflow.com/questions/11657380/is-there-a-table-or-catalog-of-aesthetics-for-ggplot2
ind_aes <- function(geom = "point") { 
  plyr::try_default({
    Geom <- getFromNamespace(paste0("Geom", ggplot2:::firstUpper(geom)), "ggplot2")
    tmp <- Geom$default_aes()
    tmp[!is.na(tmp)]
  }, default = NULL, quiet = TRUE)
}
geomz <- Filter(function(x) length(x) > 1, sapply(geom_info[,"Name"], ind_aes))
gs <- lapply(geomz, function(x) data.frame(Aesthetic = names(x), 
                                           Default = as.character(x)))
frames <- mapply(function(x, y) cbind(x, Geoms = y), gs, names(gs), 
                 SIMPLIFY = FALSE)
df <- do.call("rbind", frames)
df[] <- lapply(df, tex_code)
df2 <- df %>% group_by(Aesthetic, Default) %>%
  summarise(Cap = paste(Geoms, collapse = ", ")) %>% as.data.frame
print(xtable(df2, caption = "Default aesthetic values for geoms. See \\hyperref[cha:specifications]{\\textbf{specifications}} for how the values are interpreted by R.",
            label = "tbl:geom-defaults"), file = "tbls/geom-defaults.tex")
