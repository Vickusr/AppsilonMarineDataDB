dropDownUI_shiptype <- function(id, text, choices){
  dropdown_input(NS(id,'dropdown'),default_text = text, choices = choices)
}


dropDownServer_shiptype <- function(id,data){
  
  moduleServer(id, function(input,output,session){
    
    observeEvent(data(), {
      
      update_dropdown_input(session, "dropdown", choices = unique(data()$ship_type))
      
    })

    ship_type_data <- eventReactive(input$dropdown,{
      #tibble(id = c(1,2))
      if(!is.null(input$dropdown)){
        query_db(paste("SELECT * from ships where ship_type = '",input$dropdown,"'",sep=''))
      }else{
        NULL
      }
      
      })
    
  })
}

dropDownUI_shipname <- function(id, text, choices){
  dropdown_input(NS(id,'dropdown'),default_text = text, choices = choices)
}

dropDownServer_shipname <- function(id, data){
  
  moduleServer(id, function(input,output,session){
   
    observeEvent(data(), {
      update_dropdown_input(session, "dropdown", choices = unique(data()$SHIPNAME))
    })
    
    ship_names <- eventReactive(input$dropdown,{
      if(!is.null(input$dropdown)){
         data_to_calculate <- data() %>% filter(SHIPNAME == input$dropdown)
         data_to_calculate <- shift_points(data_to_calculate) %>% 
           calculate_distance()

      }else{
        NULL
      }
      
    })
      
    })
  
}
