library(lubridate)
get_season_north <- function(input.date){
  numeric.date <- 100*month(input.date)+day(input.date)
  cuts <- base::cut(numeric.date, breaks = c(0,319,0620,0921,1220,1231)) 
  levels(cuts) <- c("Winter","Spring","Summer","Fall","Winter")
  return(cuts)
}