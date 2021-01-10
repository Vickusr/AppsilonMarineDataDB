library(data.table)
library(tibble)
library(microbenchmark)
library(feather)
library(dplyr)
# Converting the CSV into a rds will aid in better performance for the app
# the rds will take up less space too

# fread testing, and convert to tibble as I will use tidyverse pacakges
ships <- as_tibble(fread('ships_04112020/ships.csv'))

# rename some columns so it's more clear on what is meant
ships <-  rename(ships, CURRENT_PORT_BY_VESSEL = PORT)
ships <-  rename(ships, PORT_ASSIGNMENT_BY_LOCATION = port)

# RDS testing
saveRDS(ships,'ships.rds')

rm(ships)
# check that it read in okey

ships_test <- readRDS('ships.rds')

# feather file creation
write_feather(ships,'ships.feather')


# testing of file readers
mbk <- microbenchmark(fread = data.table::fread('ships_04112020/ships.csv', showProgress = F),
               readRDS = base::readRDS('ships.rds'),
               feather = feather::read_feather('ships.feather'),times = 5)

print(mbk)


# or maybe rather make a database solution
library(DBI)
library(RMySQL)
library(jsonlite)

db_details <- jsonlite::read_json('db_details.json')
user <- db_details$username
passw <- db_details$password
host <- db_details$host
dbname <- db_details$dbname


write_data_set <- function(df, table_name) {
  dbcon <- dbConnect(drv = RMySQL::MySQL(),
                     username = user, 
                     password = passw, 
                     host = host, 
                     port = 3306, 
                     dbname = dbname)
  
  
  dbWriteTable(conn = dbcon,
               name = table_name,
               value = df, 
               row.names = FALSE, 
               overwrite = TRUE 
  )
  
  dbDisconnect(dbcon)
}

# would the write the data base solution per 
unique(ships$ship_type)

library(RSQLite)

dbcon <- dbConnect(drv=SQLite(),dbname='data/ships.db')
ships_col_name <- dbListFields(dbcon,'ships')
dbDisconnect(dbcon)
colnames(t) <- ships_col_name

dbcon <- dbConnect(drv=SQLite(),dbname='data/ships.db')
dbWriteTable(dbcon,'ships',t,rownames=FALSE,overwrite=TRUE)
dbDisconnect(dbcon)

dbcon <- dbConnect(drv=SQLite(),dbname='data/ships.db')
dbSendQuery(dbcon,'CREATE INDEX idx_ship_type on ships(ship_type);')
dbSendQuery(dbcon,'CREATE INDEX idx_ship_name on ships(SHIPNAME);')
dbDisconnect(dbcon)







