# Function that estimates height for given: dhh , age,
#          SiteIndex SI30 (M&N94, base age=30) and dominat dbh
# rs, 16 nov 2017
source("Functions/F_SiteIndex_MN94.R")

treeHeight <- function( dbh, age, SI, SI_base_age = 50, dom_d, min_h=2) {

slope <- 16.4194196543 
dom_h <- dougHdom_MN94(age, SI, SI_base_age)
interc <- dom_h - slope * log(dom_d)
return(pmax(min_h, interc + slope * log(dbh)))
}
