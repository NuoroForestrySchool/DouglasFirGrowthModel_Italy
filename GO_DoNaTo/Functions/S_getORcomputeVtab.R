# Calcola la tavola assortimentale, output Vtab("dbh"    "ht_r"   "v_tot"  "h_corm" "v_corm" "h_ass"  "v_ass")
# Input: Vtab("dbh"    "ht_r")

# ASSORTIMENTI:
dtesta_ass <- 25
dtesta_fusto <- 8

{
  print("ATTENZIONE, procedura che richiede tempo! ")
  print("      per evitare si può recuperare l'ultimo risultato salvato")
  print("      se le colonne di input coincidono, si prosegue, altrimenti STOP")
  an <- readline("  Per ripetere il procedimento lungo 'Y': ")
}

if(an == 'Y') {
#Vtab <- head(Vtab)
load("Functions/Taper_par_Doug.Rdata")
print(ini <-Sys.time())
source("Functions/S_VtabComputation.R")
# 536 rows: as.POSIXct("2017-12-02 02:03:28 CET") - as.POSIXct("2017-12-02 01:15:02 CET")
# Time difference of 48.43333 mins
print(end <- Sys.time()) 
print(as.POSIXct(end) - as.POSIXct(ini))
# save(Vtab, file="Functions/AssortmentsVolumeTable.Rdata")
} else {
  Vtab0 <- Vtab
  load("Functions/AssortmentsVolumeTable.Rdata")
  try(
    if(!identical(Vtab0, Vtab[,1:2])){
      stop("Colonne di input non coincidono, 
          occorre calcolare una nuova tavola")
      })
}


