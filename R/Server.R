SHINY_RATING_PAL <- colorNumeric(c("red", "orange", "yellow", "green"), 1:10)

# Prepares raw MongoDB data to be displayed by shiny
shiny.prepareHotelDataModel <- function(hotelData) {
  print("Preparing hotel data for view")
  hotelData$Review_Date <- as.Date(hotelData$Review_Date, "%m/%d/%Y")
  hotelData$Reviewer_Score <- as.numeric(hotelData$Reviewer_Score)
  return(hotelData)
}

SHINY_SERVER <- function(input, output) {
  output$reviewsMap <- renderLeaflet({
    leaflet(data = HOTEL_ADDRESSES) %>% addTiles() %>%
      # FitBounds to initialize map to europe
      fitBounds(-14.424528, 35.834510,  26.347118, 55.213515) %>%
      addCircleMarkers(~Lng, ~Lat, layerId= ~as.character(Hotel_Address), popup = ~as.character(Hotel_Name), label = ~as.character(Hotel_Name),
                       clusterOptions = markerClusterOptions(),color = ~SHINY_RATING_PAL(Average_Score),
                       stroke = TRUE, fillOpacity = 0.9)
  })
  
  # Reactive Values
  values <- reactiveValues(hotelReviews = NULL, rawHotelReviews = NULL)
  
  # Column names shown in data table visualization
  tableColumns <- c('Hotel_Address', 'Review_Date', 'Reviewer_Score', 'Review', 'Sentiment')
  
  # Load first 100 reviews before the user selected a hotel,
  res <- db.find(100)
  values$hotelReviews <- res[,..tableColumns]
  values$rawHotelReviews <- shiny.prepareHotelDataModel(res)
  output$hotelTable <- DT::renderDataTable({
    DT::datatable(values$hotelReviews)
  })
  
  #Handle user clicking on a marker, load hotel data
  observeEvent(input$reviewsMap_marker_click, { 
    p <- input$reviewsMap_marker_click
    if(is.null(p)) {
      return()
    }
    sentimentVal <- shiny.filterSentimentValue(input)
    hotelLookup <- db.findHotel(p$id, sentimentVal, input$minScoreFilter)
    values$hotelReviews <- hotelLookup[,..tableColumns]
    values$rawHotelReviews <- shiny.prepareHotelDataModel(hotelLookup)
  
    print(p$id)
  })
  
  observeEvent(input$minScoreFilter, {
    p <- input$reviewsMap_marker_click
    if(is.null(p)) {
      return()
    }
    sentimentVal <- shiny.filterSentimentValue(input)
    hotelLookup <- db.findHotel(p$id, sentimentVal, input$minScoreFilter)
    values$hotelReviews <- hotelLookup[,..tableColumns]
    values$rawHotelReviews <- shiny.prepareHotelDataModel(hotelLookup)
  })
  
  observeEvent(input$sentimentFilter, {
    p <- input$reviewsMap_marker_click
    if(is.null(p)) {
      return()
    }
    sentimentVal <- shiny.filterSentimentValue(input)
    hotelLookup <- db.findHotel(p$id, sentimentVal, input$minScoreFilter)
    values$hotelReviews <- hotelLookup[,..tableColumns]
    values$rawHotelReviews <- shiny.prepareHotelDataModel(hotelLookup)
  })
  
  # Render plot
  #output$freqScorePlot <- renderPlot({
  #  hist(values$rawHotelReviews$Reviewer_Score, col="lightblue", xlab = "Review Score", ylab="Frequency", main = NA, breaks=0.0:10.0)
  #})
  
  output$freqScorePlot <- renderPlotly({
    plot_ly(x=values$rawHotelReviews$Reviewer_Score, type="histogram")
  })
  
  observeEvent(input$doAnalysis, {
    print(input$textIn)
    prediction <- dl.predict(input$textIn)
    result <- "negative"
    if(prediction > 0.5) {
      result <- "positive"
    }
    
    output$kerasResult <- renderUI({
      print(paste0("Keras thought your review was ", result, "(keras prediction: ",prediction,")", sep=""))
    
    })
  })
  wordcloud_rep <- repeatable(wordcloud)
  output$wordcloud <- renderPlot({
    v <- getTermMatrix(values$rawHotelReviews$Review)
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$minFreqWordcloudFilter, max.words=input$maxWordsWordcloudFilter,
                  colors=brewer.pal(8, "Dark2"))
  })
}

shiny.filterSentimentValue <- function(input) {
  selected <- input$sentimentFilter
  print(selected)
  if(selected == "Show all") {
    return(-1)
  }
  if(selected =="positive") {
    return(1)
  }
  if(selected =="negative") {
    return(0)
  }
}


print("Loaded Server.R")