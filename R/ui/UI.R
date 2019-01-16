source("R/ui/Dashboard.R")
source("R/ui/Keras.R")

SHINY_UI <- dashboardPage(
  dashboardHeader(title = "Review Dashboard"),
  dashboardSidebar(sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Keras Sentiment", tabName = "keras", icon = icon("th"))
  )),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard", shiny.dashboardBody),
      
      # Second tab content
      tabItem(tabName = "keras", shiny.kerasBody)
    )
  )
)

print("Completed UI.R loading")