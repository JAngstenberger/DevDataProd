
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

# Plotting 
library(ggplot2)
library(rCharts)
library(ggvis)

# Data processing libraries
library(data.table)
library(reshape2)
library(dplyr)

# Required by includeMarkdown
library(markdown)

# It has to loaded to plot ggplot maps on shinyapps.io
# library(mapproj)
# library(maps)

# Data Table
dt <- mtcars
dt <- add_rownames(mtcars, var = "cmod")
dt <- arrange(dt, cmod)
dt$gear <- factor(mtcars$gear,levels=c(3,4,5), labels=c("3gears","4gears","5gears")) 
dt$am <- factor(mtcars$am,levels=c(0,1), labels=c("Automatic","Manual")) 
dt$cyl <- factor(mtcars$cyl,levels=c(4,6,8), labels=c("4cyl","6cyl","8cyl"))
cars <- dt$cmod

shinyServer(function(input, output, session) {
        
        # Define and initialize reactive values
        values <- reactiveValues()
        values$cars <- cars
        
        # Create cars checkbox
        output$carsControls <- renderUI({
                checkboxGroupInput("cars", "Car Models: ", cars, selected=values$cars)
        })
        
        # Add observers on clear and select all buttons
        observe({
                if(input$clear_all == 0) return()
                values$cars <- c()
        })
        
        observe({
                if(input$select_all == 0) return()
                values$cars <- cars
        })
        
        # Prepare data table
        dt.cars <- reactive({
                 subset(dt, dt$cmod %in% input$cars)
                 })
        
        # Render data table and create download handler
        output$dt.cars <- renderDataTable(
                {dt.cars()}, options = list(bFilter = FALSE, iDisplayLength = 20))
        
        # Density Plot
        output$distribGasMilage <- renderPlot({
                dt.cars2 <- subset(dt, dt$cmod %in% input$cars)
                # Kernel density plots for mpg
                # grouped by number of gears (indicated by color)
                s <- qplot(mpg, data=dt.cars2, geom="density", fill=gear, alpha=I(.5), 
                      xlab="Miles Per Gallon", ylab="Density")
                print(s)
                        
        })
        
        # Box Plot
        output$BoxPlot <- renderPlot({
                dt.cars2 <- subset(dt, dt$cmod %in% input$cars)
                # Boxplots of mpg by number of gears 
                # observations (points) are overlayed and jittered
                s <- qplot(gear, mpg, data=dt.cars2, geom=c("boxplot", "jitter"), 
                      fill=gear, xlab="", ylab="Miles per Gallon")
                print(s)
                
        })
        
        # Regression
        output$Regression <- renderPlot({
                dt.cars2 <- subset(dt, dt$cmod %in% input$cars)
                # Separate regressions of mpg on weight for each number of cylinders
                s <- qplot(wt, mpg, data=dt.cars2, geom=c("point", "smooth"), 
                        method="lm", formula=y~x, color=cyl, 
                        xlab="Weight", ylab="Miles per Gallon")
                print(s)
                
        })
})
                

