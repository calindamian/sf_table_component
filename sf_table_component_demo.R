#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library (lubridate)


#source the component
source("sf_table_component.R")

# populate demo data with table structure needed for sf_table_component.R

tb_data = tibble(measure = c ("Revenue" , "Profit" , "Order Size") 
                 , qualifiers = list (
                                     tibble (qualifier = c ("poor" , "satisfactory" , "good") 
                                             ,range = list (range (0,1000) , range (1000 , 5000) , range (5000 , 10000))  
                                             , color = c ("#525252" , "#969696"  , "#cccccc")
                                             ) 
                                    , tibble (qualifier = c ("poor" , "satisfactory" , "good") 
                                                ,range = list (range (0,100) , range (100 , 600) , range (500 , 1000))  
                                                , color = c ("#525252" , "#969696"  , "#cccccc")
                                                )  
                                    , tibble (qualifier = c ("poor" , "satisfactory" , "good") 
                                              ,range = list (range (0,10) , range (10 , 60) , range (60 , 100))  
                                              , color = c ("#525252" , "#969696"  , "#cccccc")
                                    )  
                 )
                 , actual =  c(NA , 800 , NA) #NA #c (100 , 258 , 500) #if NA last values
                 , target = c (8000 , 400 , 60)
                 , hist_data = list (tibble(x=1:12 , y= sample (1000:10000 , 12)) 
                                     , tibble(x=1:12 , y= sample (100:1000 , 12)) 
                                     , tibble(x=1:12 , y= sample (10:100 , 12)) ))



ui <- fluidPage(
    h2("Demo Key Metrics ") 

  , fluidRow( column (width = 3 , selectInput("select" ,label = "Select a Measure to be displayed" 
                                              , choices = tb_data$measure
                                              , multiple = T
                                              , selected = tb_data$measure )  )
              , #UI part of the component 
                column (width = 7 , uiOutput("sf_table_component") )
              )
    , verbatimTextOutput("debug")
)

server <- function(input, output, session) {
    
    
    
    tb_select = reactive(
        tb_data %>% 
            filter (measure %in% input$select )
    )
    
    #server side part of the component 
    output$sf_table_component = renderUI( { sf_table_component(tb_select ())})

    # output$debug = renderPrint(
    #     {
    #         input$select %>% 
    #             str
    #     }
    # )
}

# Run the application 
shinyApp(ui = ui, server = server)

