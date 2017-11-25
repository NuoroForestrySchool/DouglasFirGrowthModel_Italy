# CLASSIFY
# Input: acld="output classes width"
#  dbh,frq = "stand table" 
#  lcl, ucl = "lower and upper bounds of input classes"
# Output: reclassified stand table ad dataframe

clsf <- function(acld, dbh, frq, lcl, ucl) {
  d <- seq(floor(min(lcl)/acld+.5)*acld-acld/2, 
           floor(max(ucl)/acld+.5)*acld+acld/2, 
           acld)
  f <- approx(dbh,cumsum(frq),d,rule=2)
  i <- length(d)
  o <- data.frame(dbh=rowMeans(cbind(d[1:(i-1)],d[-1])))
  o$frq <- f$y[-1] - f$y[1:(i-1)]
  o$lcl <- o$dbh - acld/2
  o$ucl <- o$dbh + acld/2
  return(o)
}
