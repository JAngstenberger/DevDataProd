
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(rCharts)

shinyUI(
        navbarPage("Motor Trend Car Road Tests",
                   tabPanel("Analysis",
                            sidebarPanel(
                                uiOutput("carsControls"),
                                actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                                actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))),
                            mainPanel(
                                    tabsetPanel(
                                            
                                            # Density Plot
                                            tabPanel(p(icon("area-chart"), "Density Plot"),
                                                        h4("Distribution of Gas Milage", align = "center"),
                                                        plotOutput("distribGasMilage")
                                            ),
                                            
                                            # BoxPlot
                                            tabPanel(p(icon("bar-chart"), "Box Plot"),
                                                     h4("Mileage by Gear Number", align = "center"),
                                                     plotOutput("BoxPlot")
                                            ),
                                            
                                            # Regression
                                            tabPanel(p(icon("bar-chart"), "Regression"),
                                                     h4("Regression of MPG on Weight", align = "center"),
                                                     plotOutput("Regression")
                                            ),
                                            
                                            # Data 
                                            tabPanel(p(icon("table"), "Data"),
                                                     dataTableOutput(outputId="dt.cars")
                                            )))),
                   
                   tabPanel("About",
                            mainPanel(
                                    includeMarkdown("About.Rmd")))
                   
        ))
