identifyBorders <- function(SPolyDF) {
  borders <- rgeos::gDifference(
    as(SPolyDF, "SpatialLines"),
    as(gUnaryUnion(SPolyDF), "SpatialLines"),
    byid = TRUE)
  df <- data.frame(
    len = sapply(1:length(borders),
                 function(i) gLength(borders[i, ])))
  rownames(df) <- sapply(1:length(borders),
                         function(i) borders@lines[[i]]@ID)
  SLDF <- sp::SpatialLinesDataFrame(borders, data = df)
  return(SLDF)
}
