test_that("HTML for POPUPs works",{
  expect_equal(
    make_map_note(SHIPNAME = "KONYA", LAT = "40",LON = '40',PORT="PORT",
                  DATETIME="2021-01-01 16:30:00",distance = 1320.3),
    "Vessel Name: KONYA <br> Current Point: <br> <ul><li>Latitude:  40 </li> <li>Longitude :  40 </li></ul><br> Port : PORT <br> DateTime:  2021-01-01 16:30:00 <br> Longest Distance Travelled: 1320.3  meters"
    )
  expect_equal(
    make_map_note(SHIPNAME = "KONYA", LAT = 40,LON = 40,PORT="PORT",
                  DATETIME="2021-01-01 16:30:00",distance = '1320.3'),
    "Vessel Name: KONYA <br> Current Point: <br> <ul><li>Latitude:  40 </li> <li>Longitude :  40 </li></ul><br> Port : PORT <br> DateTime:  2021-01-01 16:30:00 <br> Longest Distance Travelled: 1320.3  meters"
  )
})

test_that("DB Call Works",{
  library(RSQLite)
  db_test <- query_db('select * from ships',str_replace(getwd(),'tests/testthat','data/ships.db'))
  expect_type(db_test , 'list')
  
})
