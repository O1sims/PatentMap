getStatData <- function(remote) {
  both15 <- eurostat::euroget_eurostat("demo_r_pjanaggr3") %>% 
    filter(
      sex == "T",
      nchar(paste(geo)) == 5,
      !str_sub(geo, 1, 4) %in% remote,
      !str_sub(geo, 1, 2) %in% c("AL", "MK"),
      year(time) == 2015) %>% 
    droplevels() %>% 
    transmute(id = geo, age, value = values) %>% 
    spread(age, value) %>% 
    mutate(sy = Y_LT15 / TOTAL, 
           sw = `Y15-64` / TOTAL, 
           so = 1 - (sy + sw))
  
  return(both15)
}