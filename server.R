source('product.R')
shinyServer(function(input, output) {
    
    
    time_series <- reactive({
        
        series <- by.industry(input$industry)
        
        if(input$severity=="All"){
            return(series[[3]])
        } else if(input$severity == 'Fatal'){
            return(series[[1]])} else { return(series[[2]])}        
    })
    
    output$ts <- renderPlot({
        # Time series plot to display goes here
       plot(time_series(),yaxt='n',typ='l',lwd=2,xlab="Year",ylab="Accidents")
       pts <- pretty(time_series())
       axis(2, at=pts)
    })
    
    text <- reactive({
        key_set <- keys(input$industry)
        
        if(input$severity=="All"){
            return(key_set[[3]] %>% arrange(-perc))
        } else if(input$severity == 'Fatal'){
            return(key_set[[1]] %>% arrange(-perc))} else { return(key_set[[2]] %>% arrange(-perc))}   
    })

    output$v1 <- renderText(as.character(text()[1,1]))
    output$v2 <- renderText(as.character(text()[2,1]))
    output$v3 <- renderText(as.character(text()[3,1]))
    output$v4 <- renderText(as.character(text()[4,1]))
    output$v5 <- renderText(as.character(text()[5,1]))
    output$v6 <- renderText(as.character(text()[6,1]))
    output$v7 <- renderText(as.character(text()[7,1]))
    output$v8 <- renderText(as.character(text()[8,1]))
    output$v9 <- renderText(as.character(text()[9,1]))
    output$v10 <- renderText(as.character(text()[10,1]))
    
    })