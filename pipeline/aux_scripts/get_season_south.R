library(lubridate)
get_season_south <- function(input.date){
  numeric.date <- 100*month(input.date)+day(input.date)
  cuts <- base::cut(numeric.date, breaks = c(0,320,0621,0922,1221,1231)) 
  levels(cuts) <- c("Summer","Fall","Winter","Spring","Summer")
  return(cuts)
}


