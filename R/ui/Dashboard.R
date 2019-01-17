shiny.dashboardBody <- fluidRow(
 column(12,
       box(leafletOutput("reviewsMap", height = 430), height=450),
       box(
         title="Reviewer Score Frequencies",
         plotlyOutput("freqScorePlot"),
         height=430),
       height = 700
  ),
 column(12,
        box(
          title = "Wordcloud",
          plotOutput("wordcloud")
        ),
        box(
          title = "Filters",
          selectInput("sentimentFilter", 
                      "Only show reviews that are", 
                      c("Show all", "positive", "negative"),
                      selected="Show all"),
          sliderInput("minScoreFilter", "Minimum Review Score", step=0.1, min=0, max=10, value=0),
          sliderInput("minFreqWordcloudFilter", "Minimum Word Freq in WordCloud", step=1, min=1, max=20, value=5),
          sliderInput("maxWordsWordcloudFilter", "Maximum Words in WordCloud", min=0, max=200, value=100)
        ),
        height = 700
 ),
 column(12, box(
   title = "Review Table",
   DT::dataTableOutput("hotelTable",  width = "100%", height = "auto"),
   width = "100%"
 ))
)
