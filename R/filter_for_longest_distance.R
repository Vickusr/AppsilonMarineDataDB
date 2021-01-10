filter_for_longest_distance <- function(df){
  # Filter for where the distance is the furthest traveled
  # here we have the filtered per name vessel data frame coming in
  # to be filtered
  max_distance = max(df$distance,na.rm=TRUE)
  
  # Filter for where the distance is the furthest traveled
  
  df <- df %>% 
    filter(distance == max_distance)
  
  # if there is more than one observation it means 
  # there are more than 2 max distances so we take the most
  # recent ones
  
  if (nrow(df) > 1){
    df <- df[1,]
  }
  
  df <- df %>% 
    select(SHIPNAME,LAT,LON,PORT_CURRENT,DATETIME,
           allocated_port_by_location,PREV_LAT,PREV_LON,distance) %>%
    mutate(DATETIME = as.character(DATETIME))
}