# Simple function to keep the leaflet popups simple
library(dplyr)
library(data.table)
library(readr)
library(tidyr)
library(stringr)
library(RSQLite)

make_map_note <- function(SHIPNAME, LAT,LON,PORT,DATETIME,distance){
  note <- paste('Vessel Name:',SHIPNAME,
        '<br>',
        'Current Point:',
        '<br>',
        '<ul><li>Latitude: ',LAT,
        '</li>',
        '<li>Longitude : ',LON,
        '</li></ul><br>',
        'Port :', PORT,
        '<br>',
        'DateTime: ',as.character(DATETIME),
        '<br>',
        'Longest Distance Travelled:',distance, ' meters')
}

query_db <- function(sql, dbname='data/ships.db'){
  dbcon <- dbConnect(drv=SQLite(),dbname=dbname)
  queried_data <- dbGetQuery(dbcon,sql)
  dbDisconnect(dbcon)
  queried_data
}
