## Compute VolumeTable for the simulation
# Input: Vtab with the required (dbh, h_tot) combinations
# Output: added computed cols
require(TapeR)

Vtab$v_ass <- Vtab$h_ass <- Vtab$v_corm <- Vtab$h_corm <- Vtab$v_tot <- 0
dtesta_ass <- 25
dtesta_fusto <- 8
## TapeR non lavora in parallelo!! Processa un solo fusto alla volta
cat(paste("To process:",nrow(Vtab), "cases - Processing case #: "))
for(i in 1:nrow(Vtab)) {
  cat(i)
  Vtab$v_tot[i] <- unlist(with(
    Vtab[i,]
    , E_VOL_AB_HmDm_HT.f(
      Hm = 1.3, Dm = dbh, mHt = ht_r, sHt = 1, par.lme = tp.par
    )["E_VOL"]
  ))
  if (Vtab[i,"dbh"] > dtesta_fusto) {
    Vtab$h_corm[i] <- unlist(with(
      Vtab[i,]
      , E_HDx_HmDm_HT.f (
        Dx = dtesta_fusto, Hm = 1.3, Dm = dbh, mHt = ht_r, sHt = 1, par.lme = tp.par
      )
    ))
    Vtab$v_corm[i] <- unlist(with(
      Vtab[i,]
      , E_VOL_AB_HmDm_HT.f(
        Hm = 1.3, Dm = dbh, mHt = ht_r, sHt = 1
        , A = NULL, B = h_corm , iDH =
          "H" , par.lme = tp.par
      )["E_VOL"]
    ))
  }
  if (Vtab[i,"dbh"] > dtesta_ass) {
    Vtab$h_ass[i] <- unlist(with(
      Vtab[i,]
      , E_HDx_HmDm_HT.f (
        Dx = dtesta_ass, Hm = 1.3, Dm = dbh, mHt = ht_r, sHt = 1, par.lme = tp.par
      )
    ))
    Vtab$v_ass[i] <- unlist(with(
      Vtab[i,]
      , E_VOL_AB_HmDm_HT.f(
        Hm = 1.3, Dm = dbh, mHt = ht_r, sHt = 1
        , A = NULL, B = h_ass , iDH =
          "H" , par.lme = tp.par
      )["E_VOL"]
    ))
  }
}
# save(Vtab,file="Data/VolTab.Rdata")

