print("Installing and loading install candidate libraries")
InstallCandidates <- c(
  "rowr",
  "shiny",
  "DT",
  "shinythemes",
  "viridis",
  "ggvis",
  "mongolite",
  "jsonlite",
  "tidyverse",
  "data.table",
  "keras",
  "shinydashboard",
  "leaflet",
  "tensorflow",
  "reticulate",
  "purrr",
  "data.table",
  "tm",
  "wordcloud",
  "memoise",
  "plotly"
  
)

toInstall <- InstallCandidates[!InstallCandidates %in% library()$results[, 1]]

if (length(toInstall) != 0) {
  install.packages(toInstall, repos = "http://cran.r-project.org")
}

lapply(InstallCandidates, library, character.only = TRUE)
rm("InstallCandidates", "toInstall")
print("Done installing and loading libraries")
print("R - Loaded Libraries.R")

