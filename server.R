library(shiny)
library(plotly)
library(leaflet)
library(varhandle)

shinyServer(function(input, output) {
  
  output$result_picture <- renderUI({
        transed_lng <- as.numeric(input$Longitude)
        transed_lat <- as.numeric(input$Latitude)
        ans <- crossSummary(transed_lng, transed_lat)
        if((ans[1] >= 2) | ans[2] >= 1) {
          img=tags$img(src='dangerous.png',width=500,heigth=500)
          print("Dangerous")
          h6("Dangerous")
        } else if(ans[1] == 1 & ans[2] == 0) {
          img=tags$img(src='medium.png',width=500,heigth=500)
          print("Medium")
          h6("Medium")
        } else {
          img=tags$img(src='safe.png',width=500,heigth=500)
          print("Safe")
          h6("safe")
        }
        h6(br(),img)
        #img=tags$img(src=datasetInput(),width=500,heigth=500)
        #h6("Image:",br(),img)
      })
  
   output$result_text <- renderUI({
        transed_lng <- as.numeric(input$Longitude)
        transed_lat <- as.numeric(input$Latitude)
        ans <- crossSummary(transed_lng, transed_lat)
        if((ans[1] >= 2) | ans[2] >= 1) {
          p("Dangerous", style = "color:red;font-size:50px")
          # print("Dangerous")
        } else if(ans[1] == 1 & ans[2] == 0) {
          p("Medium", style = "color:orange;font-size:50px")
          # print("Medium")
        } else {
          p("Safe", style = "color:green;font-size:50px")
          # print("Safe")
        }
   })
   output$out <- renderUI ({
    vec <- check.numeric(c(input$Longitude,input$Latitude))
    if( (vec[1] == FALSE) | (vec[2] == FALSE)) {
      p("Please input longitude & latitude", style = "color:red;font-size:25px")
    }
   })
  
  # input$Longitude,input$Latitude
  output$mymap <- renderLeaflet({
    # check & transform to float number
    #need to exclude string/character (fool-proof)
     #if(is.na(as.numeric(input$Longitude)) == TRUE | is.na(as.numeric(input$Latitude)) == TRUE) { # ! not ?
    vec <- check.numeric(c(input$Longitude,input$Latitude))
#    if( (vec[1] == FALSE) | (vec[2] == FALSE)) {
    #    y <- reactive(if(vec[1] == FALSE | vec[2] == FALSE) "Please input longitude & latitude" else " " )#??
    #    output$out <- renderText({y()})
#     } else {
    if(vec[1] == TRUE & vec[2] == TRUE) {
       transed_lng <- as.numeric(input$Longitude)
       transed_lat <- as.numeric(input$Latitude)
       # input to set view 
       leaflet(data = p) %>%
       setView(lng = transed_lng, lat = transed_lat, zoom = 15) %>%
       addMarkers(lng = transed_lng,lat = transed_lat, icon = UserIcon) %>%
       addCircles(lng = transed_lng,lat = transed_lat,weight = 1, radius = 500, color = "orange") %>%
       addTiles() %>%
       addMarkers(~longitude, ~latitude, icon = virusIcon, popup = paste(sep = "<br/>",
                                                                         p$id,
                                                                         p$date,
                                                                         p$species)) %>%
       addCircles(lng = ~longitude,lat = ~latitude,weight = 1, radius = 500,
                  color = ifelse(p$species == "delta","red","blue"))
     }
  })
})
