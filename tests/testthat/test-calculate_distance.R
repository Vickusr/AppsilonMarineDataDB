

library(dplyr)
library(data.table)
library(readr)
library(geosphere)
library(tidyr)
library(stringr)
library(RSQLite)

# Data preparation for testing
#path_to_read <- str_replace(getwd(),'tests/testthat','data/ships.rds')
#data <- readRDS(path_to_read) %>% as_tibble()
dbcon <- dbConnect(drv=SQLite(),dbname= str_replace(getwd(),'tests/testthat','data/ships.db'))
data <- dbGetQuery(dbcon,'SELECT * from ships')
count_ship_obs <- dbGetQuery(dbcon,'SELECT SHIP_ID,SHIPNAME,count(1) as count_n from ships GROUP BY SHIP_ID,SHIPNAME')
dbDisconnect(dbcon)

 

# There are different tests we have to run
# 1. only one observation
test_that("All calculations work - for single observations", {
  
  
  #get the observations per ship id
    one_obs <- count_ship_obs %>% filter(count_n == 1)
  
  for (i in one_obs$SHIPNAME){
    to_test_df <- data %>% filter(SHIPNAME == i)
    to_test_df <- shift_points(to_test_df)
    to_test_df <- calculate_distance(to_test_df)
    expect_true(to_test_df$distance[1] == 0)
  }
  
  
})

# 2. Where there is more than one observation
test_that("All calculations work - for more than one observations", {

  #get the observations per ship id
  gt_one_obs <- count_ship_obs %>% filter(count_n > 1)
  # randomly test some examples
  testing_indexes <- unique(abs(as.integer(rnorm(50,1)*20)))
  testing_indexes[testing_indexes != 0]
  for (i in gt_one_obs$SHIPNAME[testing_indexes]){
    to_test_df <- data %>% filter(SHIPNAME == i)
    to_test_df <- shift_points(to_test_df)
    to_test_df <- calculate_distance(to_test_df)
    expect_true(is.numeric(to_test_df$distance))
  }
  
})