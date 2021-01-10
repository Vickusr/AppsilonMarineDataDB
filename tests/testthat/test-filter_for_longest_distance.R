
library(dplyr)
library(data.table)
library(readr)
library(geosphere)
library(tidyr)


test_that("Find Longest Distance", {
  mock_data <- tibble(SHIPNAME = c("A","A","A"),
                      LAT = c(rnorm(3,10,1)),
                      LON = c(rnorm(3,10,1)),
                      PORT_CURRENT = c("P1","P1","P1"),
                      DATETIME = as.POSIXct(c('2020-01-21 14:00:12','2020-01-22 11:00:12','2020-01-19 14:00:12')),
                      allocated_port_by_location = c("P2","P2","P2"),
                      PREV_LAT = c(rnorm(3,10,1)),
                      PREV_LON = c(rnorm(3,10,1)),
                      distance = c(90,12,100))
  
  data_to_test <- filter_for_longest_distance(mock_data)
  expect_equal(data_to_test$distance[1],100)
})
test_that("Find Longest Distance - verify date", {
  mock_data <- tibble(SHIPNAME = c("A","A","A"),
                      LAT = c(rnorm(3,10,1)),
                      LON = c(rnorm(3,10,1)),
                      PORT_CURRENT = c("P1","P1","P1"),
                      DATETIME = as.POSIXct(c('2020-01-21 14:00:12','2020-01-22 11:00:12','2020-01-19 14:00:12')),
                      allocated_port_by_location = c("P2","P2","P2"),
                      PREV_LAT = c(rnorm(3,10,1)),
                      PREV_LON = c(rnorm(3,10,1)),
                      distance = c(90,12,100))
  
  data_to_test <- filter_for_longest_distance(mock_data)
  expect_equal(as.character(data_to_test$DATETIME[1]),'2020-01-19 14:00:12')
})

test_that("Find Longest Distance - verify that same distance gives back latest date", {
  mock_data <- tibble(SHIPNAME = c("A","A","A"),
                      LAT = c(rnorm(3,10,1)),
                      LON = c(rnorm(3,10,1)),
                      PORT_CURRENT = c("P1","P1","P1"),
                      DATETIME = as.POSIXct(c('2020-01-21 14:00:12','2020-01-22 11:00:12','2020-01-19 14:00:12')),
                      allocated_port_by_location = c("P2","P2","P2"),
                      PREV_LAT = c(rnorm(3,10,1)),
                      PREV_LON = c(rnorm(3,10,1)),
                      distance = c(100,12,100))
  
  data_to_test <- filter_for_longest_distance(mock_data)
  expect_equal(as.character(data_to_test$DATETIME[1]),'2020-01-21 14:00:12')
})