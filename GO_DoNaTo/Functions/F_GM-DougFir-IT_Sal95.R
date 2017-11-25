### 1995 - Scotti et al. - Growth model for Italian Douglas fir plantations. 
### http://eprints.uniss.it/11258/1/Scotti_R_Growth_model_for_Italian.pdf
#Author/s: Scotti, Roberto; Corona, Piermaria; La Marca, Orazio; Marziliano, Pasquale; Tarchiani, Neri; Tomaiuolo, Matteo (1995) 
#Title: Growth model for Italian Douglas fir plantations. 
#Source: In: Skovsgaard, J.P. & H.E. Burkhart (eds.) 1995: 
#            Recent advances in forest mensuration and growth and yield research.
#            Proceedings from 3 sessions of Subject Group S4.01 'Mensuration, Growth and Yield'
#             at the 20th World Congress of IUFRO, held in Tampere, Finland, 6-12 August 1995.
#             p. 175-193. 
#            Danish forest and landscape research institute, 
#             Ministry of environment and energy, Hørsholm, Denemark.
#ISBN 87-89822-53-6

# VARIABLE    units      Definition                                                      
# SI          [m]            Mean height of the dominant trees at 30 years                   
# PD          [n./ha]        Number of trees per hectare at plantation time                  
# DBH         [cm]           Breast height diameter measured at from a fixed position        
# AGE         [years]        Measurement year - Plantation year                              
# N           [n./ha]        Trees/ha at beginning of remeasurement period after thinning    
# SBA or G    [m2/ha]        Stand basal area/ha after thinning                              
# DG          [cm]           DBH of average basal area tree                                  
# SBAI or G’  [m2/(ha*year)] Stand basal area increment per year                             
# TNP           %            Thinning: n. of trees removed as % of total before thinning     

# Var.    N    Mean  Std Dev  Minimum  Maximum      CV
# SI     55    26.5      3.1     19.7     32.8    11.6
# PD     55  2107.8   1037.8    833.3   4216.6    49.2
# Default values
SI_def <- 26.5
PD_def <- 2107.8

#Coefficient  EstimatedValue  StandardError
alpha0	<- 4.6482767	#   0.16778012
alpha1	<- 0.00000814	#   0.00000112
gamma1	<- 27.535735	#   0.668269
gamma2	<- -0.073966	#   0.012427
gamma3	<- -0.008192	#   0.001152
beta0	<- 0.214653	    #   0.013219
beta1	<- -0.000020355	#   0.000004758
beta2	<- -0.005236	  #   0.000443

#ADDED coefficients

#Stand level correction
# lm(Ggrowth_obs/Ggrowth_est~G_i, data=tbl3)
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)  
# (Intercept) 0.085122   0.249581   0.341   0.7502  
# G_i         0.023553   0.005132   4.590   0.0101 *
# Residual standard error: 0.104 on 4 degrees of freedom
# Multiple R-squared:  0.8404,  Adjusted R-squared:  0.8005 
# F-statistic: 21.06 on 1 and 4 DF,  p-value: 0.01011
SL <- c(a1=2.35531448955093938857e-02, a0=8.51223596738076709878e-02)

#Size class substitution
#b1 <- coefficients(lm(delta_d130~AdS+d130, data=IncrementiOsservati))["d130"]
SC_b1 <- 1.6828472456e-02

# Orginal stand level function
SBAI <- function(AGE, N, SBA, SI=SI_def, PD=PD_def, TNP=0){
  ## SI base age = 30 years!!
  lnAlpha <- alpha0 + alpha1 * SI * PD
  gamma <- gamma1 / SI + gamma2 * N /1e6 + gamma3 * sqrt(TNP)
  return(gamma * SBA/AGE *(lnAlpha - log(SBA)))
}

# Adapted stand level function
SBAI2 <- function(AGE, N, SBA, SI=SI_def, PD=PD_def, TNP=0){
  ## SI base age = 30 years!!
  lnAlpha <- alpha0 + alpha1 * SI * PD
  gamma <- gamma1 / SI + gamma2 * N /1e6 + gamma3 * sqrt(TNP)
  SBAI <- gamma * SBA/AGE *(lnAlpha - log(SBA))
  return(SBAI * (SBA* SL["a1"] + SL["a0"]))
}

# Original size class level function
dbhInc <- function(d, N, DG, SBAI, dbhIncMIN=0.05){
  g <- d^2*pi/40000
  avg_g <- DG^2*pi/40000
  avg_gg <- SBAI/N
  beta <- beta0 + beta1 * N + beta2 * DG
  gg <- avg_gg + (g - avg_g) * beta
  d_inc <- sqrt((g+gg)*40000/pi) - d
  return(ifelse(d_inc<=0, .001, d_inc))
}

# Adapted size class level function
dbhIncS <- function(d, N, DG, SBAI, dbhIncMIN=0.05, b1=SC_b1){
  g <- d^2*pi/40000
  avg_g <- DG^2*pi/40000
  avg_gg <- SBAI/N
  dg_inc <- sqrt((avg_g+avg_gg)*40000/pi) - DG
  b0 <- dg_inc - DG * b1
  d_inc <- b0 + b1 * d
  return(ifelse(d_inc<=0, .001, d_inc))
}