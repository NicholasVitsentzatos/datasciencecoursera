library(shiny)
shinyUI(fluidPage(
    titlePanel("Generating random numbers and fitting a regression line on the ones we select"),
    sidebarLayout(
        sidebarPanel(
            numericInput("numeric", "How Many Random Numbers Should be Plotted?", 
                         value = 100, min = 1, max = 200, step = 1),
            sliderInput("sliderX", "Pick Minimum and Maximum X Values",
                        -80, 80, value = c(-50, 50)),
            sliderInput("sliderY", "Pick Minimum and Maximum Y Values",
                        -80, 80, value = c(-50, 50)),
            checkboxInput("show_xlab", "Show/Hide X Axis Label", value = TRUE),
            checkboxInput("show_ylab", "Show/Hide Y Axis Label", value = TRUE),
            checkboxInput("show_title", "Show/Hide Title")
        ),
        mainPanel(
            h3("Please select some points on the graph"),
            plotOutput("plot1",brush = brushOpts(
                id = "brush1"
            ))
        )
    )
))