# SITE EVALUATION
# MAETZKE F., NOCENTINI S. (1994). 
# L'accrescimento in altezza dominante e la stima della fertilità in popolamenti di douglasia. 
# L'ITALIA FORESTALE E MONTANA. vol. XLIX, pp. 582-594 ISSN: 0021-2776. Fasc. n.6
MN94 <- new.env()
#a <- 4.0031289
MN94$c <- 0.1307926
MN94$k <- 10^4.0031289

dougSI_MN94 <- function(Eta, Hdom, Eb=50) {
  return( MN94$k * (Hdom/MN94$k)^(1/((Eb/Eta)^MN94$c))  ) 
}

dougHdom_MN94 <- function(Eta, SI, Eb=50) {
  return( MN94$k * (SI/MN94$k)^((Eb/Eta)^MN94$c) )
}