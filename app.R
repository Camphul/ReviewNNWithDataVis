#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("R/ScriptLoader.R")

db.connect()

importDataAndInsertToMongo <- function() {
  print("Importing data and inserting into mongodb")
  csvdata.import()
  db.insertTable(HOTEL_REVIEWS)
  print("Done importing data and inserting into mongodb")
}

# Import CSV, cleanup, insert into MongoDB
#importDataAndInsertToMongo()

# Setup deeplearning model(Keras NN)
#dl.setup()

# Define server logic required to draw a histogram
# Run the application 
shinyApp(ui = SHINY_UI, server = SHINY_SERVER)

