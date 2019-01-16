shiny.kerasBody <- div(
  h2("What does Keras think?"),
  p("Let keras score your review!"),
  textAreaInput("textIn", "Review to Rate"),
  actionButton("doAnalysis", "Find out!"),
  hr(),
  h3("Result:"),
  uiOutput("kerasResult")
)