app_server <- function(){
  server <- function(input, output, session) {
    
    ship_types <- reactive({
      sql <- paste('select DISTINCT ship_type from ships ORDER BY ship_type',sep='')
      query_db(sql)
    })
    

    
    vessel_type_data <- dropDownServer_shiptype('vessel_type',
                                       data = ship_types
                                       )
    
    vessel_by_name_data <-  dropDownServer_shipname('vessel_name',
                                           data = vessel_type_data
                                           )

    vessel_by_name_longest_distance <- eventReactive(vessel_by_name_data(),{
      filter_for_longest_distance(vessel_by_name_data())
    })
    
    output$detail_info_table <- DT::renderDataTable(
      vessel_by_name_data(),
      options = list(scrollX = TRUE),
      rownames= FALSE)

    
    output$map <- renderLeaflet({
      
      leaflet() %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(lat = 0, lng = 0, zoom = 2) %>%
        addScaleBar()
    })
    
    
    # As the data changes we need to update the map.
    observeEvent(vessel_by_name_longest_distance(),{
      req(vessel_by_name_longest_distance())
      leafletProxy('map') %>%
        clearGroup('markers') %>%

        flyTo(lat = vessel_by_name_longest_distance()$LAT,
              lng = vessel_by_name_longest_distance()$LON,
              zoom = 12) %>%

        addPolylines(data = vessel_by_name_longest_distance(),
                     lng = ~c(LON,PREV_LON),
                     lat = ~c(LAT,PREV_LAT),
                     group = 'markers',
                     color = '#000000') %>%
        
        addCircleMarkers(data = vessel_by_name_longest_distance(),
                         lat = ~LAT,
                         lng = ~LON,
                         group = 'markers',
                         popup = ~make_map_note(SHIPNAME,LAT,LON,PORT_CURRENT,
                                                DATETIME,distance),
                         radius = 15,
                         weight = 1,
                         opacity = 1,
                         fillColor = "#008000",
                         color  = "#008000",
                         stroke = FALSE) %>%
        
        addPopups(data = vessel_by_name_longest_distance(),
                  lat = ~LAT,
                  lng = ~LON,
                  group = 'markers',
                  popup = ~make_map_note(SHIPNAME,LAT,LON,PORT_CURRENT,
                                         DATETIME,distance)) %>%
        addCircleMarkers(data = vessel_by_name_longest_distance(),
                         lat = ~PREV_LAT,
                         lng = ~PREV_LON,
                         group = 'markers',
                         radius = 12,
                         weight = 1,
                         popup = ~paste('Vessel Name:',SHIPNAME,
                                        '<br>',
                                        'Previous Point:',
                                        '<br>',
                                        '- Latitude: ',PREV_LAT,
                                        '<br>',
                                        '- Longitude :',PREV_LON),
                         opacity = 1,
                         fillColor = "#ff0000",
                         color = "#ff0000",
                         stroke = FALSE)

    })

    observe({
      if(input$path){
        leafletProxy('map') %>%
          clearGroup('path') %>%
          addPolylines(data = vessel_by_name_data(),
                       lng = ~c(LON),
                       lat = ~c(LAT),
                       group = 'path',
                       color = '#008080')
      }else{
        leafletProxy('map') %>%
          clearGroup('path')
      }

    })
    
    
    
  }
}