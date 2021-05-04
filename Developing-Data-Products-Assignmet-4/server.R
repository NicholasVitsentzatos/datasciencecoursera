library(shiny)
shinyServer(function(input, output) {
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
})