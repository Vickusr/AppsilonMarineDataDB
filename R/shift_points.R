# Here we use the Haversine method to determine the distance between points.
# The geosphere library has this calculation already implemented 

shift_points <- function(df){
  
  # here we have the filtered per name vessel data frame coming in
  # to be filtered
  
  # First we off set the previous lat and long's 
  # so we can facilitate the Haversine calculation through a matrix
  # this also helps in plotting as all the lat longs
  # are on one observation
  df <- df %>%  
    mutate(PREV_LAT = lead(LAT), PREV_LON = lead(LON)) 
  
  # instances found where there were only one observations was seen
  # In this case we force the data points to be the same
  # this will still show a marker on the map
  if(nrow(df)==1){ 
    df <- df %>% mutate(PREV_LAT = LAT, PREV_LON = LON)
  }else{
    df
  }
  
}

