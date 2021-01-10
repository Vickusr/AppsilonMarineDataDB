# Conversion of data to a sqlite db
# db was originall setup with DB Browser (SQLite)
# https://sqlitebrowser.org/

ships <- read_csv('ships.csv')
dbcon <- dbConnect(drv=SQLite(),dbname='data/ships.db')
dbWriteTable(dbcon,'ships',ships,rownames=FALSE,overwrite=TRUE)
dbDisconnect(dbcon)

# Create indexes for better filtering performance
dbcon <- dbConnect(drv=SQLite(),dbname='data/ships.db')
dbSendQuery(dbcon,'CREATE INDEX idx_ship_type on ships(ship_type);')
dbSendQuery(dbcon,'CREATE INDEX idx_ship_name on ships(SHIPNAME);')
dbDisconnect(dbcon)