#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
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
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$plot1 <- renderPlot({
        set.seed(2016-05-25)
        number_of_points <- input$numeric
        minX <- input$sliderX[1]
        maxX <- input$sliderX[2]
        minY <- input$sliderY[1]
        maxY <- input$sliderY[2]
        dataX <- rnorm(number_of_points, minX, maxX)
        dataY <- rnorm(number_of_points, minY, maxY)
        xlab <- ifelse(input$show_xlab, "X Axis", "")
        ylab <- ifelse(input$show_ylab, "Y Axis", "")
        main <- ifelse(input$show_title, "Graph of the random points :P", "")
        df<-data.frame(cbind(dataX,dataY))
        model <- reactive({
            
            brushed_data <- brushedPoints(df, input$brush1,
                                          xvar = "dataX", yvar = "dataY")
            if(nrow(brushed_data) < 2){
                return(NULL)
            }
            lm(dataY ~ dataX, data = brushed_data)
        })
        plot(df$dataX, df$dataY, xlab = xlab, ylab = ylab, main = main,
             xlim = c(-100, 100), ylim = c(-100, 100))
        if(!is.null(model())){
            abline(model(), col = "blue", lwd = 2)
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
