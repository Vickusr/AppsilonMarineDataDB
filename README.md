# AppsilonMarineData
My code submission for the Appsilon Marine Data - SQL solution

Hosted here:
Github: [Github](https://github.com/Vickusr/AppsilonMarineDataDB)

*Please remember to unzip the `ships.7z` so that the DB shows as  `ships.db` in the `data/ships.db` directory*

shinyapps.io: [shinyapps.io](https://vickus-botha.shinyapps.io/AppsilonMarineDataDB/)

## There is also a non-SQL solution:
Hosted here:
[shinyapps.io](https://vickus-botha.shinyapps.io/AppsilonMarineData/)

The non-SQL Github Repo:
[Github](https://github.com/Vickusr/AppsilonMarineData/)


For more context on this see the **Performance Testing** heading

# Thanks!
Thanks Appsilon for this very cool shiny app idea! 
It was a very cool shiny app to do!
There were good requirements that created some wonderful challenges!
Thank you for showing me the Semantic package, it's wonderful!

# First Steps
My first step was to explore the data, what does it look like?
How much data is there? etc

I wasn't sure if shinyapps.io would host such large file `ships.csv` ~ 400mb, after experimenting shinyapps.io does support file size. 
As a back up I prepped to write the data to SQL. I decided on using the RDS file instead as that comes out to be 14.7mb and read rate is quick.

I also tested which data reading function (`fread`,`readRDS`) would perform the best, referencing this guide: 

https://appsilon.com/fast-data-loading-from-files-to-r/

I decided on `readRDS` since the performance was good.
I first made sure that the data types of all the columns was correct to be sure that the data will take up as little space as possible.

This work can be seen in file `convert_ship_data.R`

# Structure
- `app.R` app file
- `R/app_ui.R` where the UI portion lives of the app
- `R/app_server.R` where the server logic lives of the app
- `R/dropdown_module.R` module for drop down that does the data filtering for further calculations or filtering
- `R/shift_points.R` Shifting points for ease of use on the map and the calculation
- `R/calculate_distance.R` where the distance calculation happens, passed back as a data frame / tibble
- `R/filter_for_longest_distance.R` function that figures out the longest distance
- `R/helpers_functions.R` some helper functions with regards to map formatting and db queries

# Next Steps
I started to design the drop down module that was a requirement specified on the requirement doc.
Here I wanted a module that can take in a variable to filter the data and return that filtered data. 
This would give me some flexibility in using drop down's to filter data as required.

# Distance Calculation
I used the Haversine method, as I have used it in the past and is very reliable method. 
It isn't as accurate as the Vincenty formula as Vincenty caters for the surface of an ellipsoid, 
where Haversine just calculates on the surface of an sphere.
The assumption here is that a few meters won't make such a big difference, as the accuracy of the cooridante data is at 10m (https://www.marinetraffic.com/blog/information-transmitted-via-ais-signal/).
One can always change the method if needed.

# Serving the Data
I opted for loading the data in the global environment so that the data won't be needed to load in by each user, and in that way running out of memory.
If the data changed ever so often a database solution should rather be considered since the data can change daily, not then needing to restart the server to refresh the data source.
Instead for this app rather serve the data up in one global instance and have the app be a bit more efficient.  

# Getting the data
I have 2 modules that are filtering the data. On this data I can then do the necessary operations for doing the calculations and finding the largest distance traveled point (which was the aim of the app).
I did some data manipulation on the data set, so that the calculation and leaflet plotting would work out by only using one observation.

Sorting by date, taking the newest first, then making new columns to place the previous latitude and longitude so that the Haversine calculation can work seamlessly.

# Map
After the data is correct, is a matter of checking when the data changes and then updating the map (leafletproxy).

The UI idea was to keep it clean. The assumption I went with, is that the user will want to filter by type and vessel and then see the longest distance and 
from there view the detailed information. I also added in the path of the vessel so that it's easy to see what movements happened.

The note can be cross referenced with the detail data table to see the max distance along with the other information.

# Performance Testing
After I looked at the performance where the data is read in into memory globally. 
I noticed there were rare instance where shinyapps.io would run into memory constraints.

So I did a bit more with with `profvis` allowing me to optimise the app for memory.

However this prompted me to look into the database solution, even if it was a `SQLite` solution.
This solution is also given [here](https://vickus-botha.shinyapps.io/AppsilonMarineDataDB/). The implementation I would say is much better.

There are thus two solution that work the same way.
