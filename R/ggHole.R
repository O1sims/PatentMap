# A function to overcome the problem of mapping nested polygons
# See: https://stackoverflow.com/questions/21748852

ggHole <- function(fort) {
  poly <- fort[fort$id %in% fort[fort$hole,]$id, ]
  hole <- fort[!fort$id %in% fort[fort$hole,]$id, ]
  out <- list(poly, hole)
  names(out) <- c('poly', 'hole')
  return(out)
}

