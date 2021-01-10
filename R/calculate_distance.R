calculate_distance <- function(df_to_process){
  # Calculation on distance
  
  if(nrow(df_to_process)>0){
    current_coords <- c(df_to_process$LON,df_to_process$LAT)
    previous_coords <- c(df_to_process$PREV_LON,df_to_process$PREV_LAT)
    
    distance <-  distHaversine(matrix(current_coords, ncol = 2),matrix(previous_coords, ncol = 2))
    
    df_to_process$distance <- round(distance,3)
    df_to_process
  }
  
  
}