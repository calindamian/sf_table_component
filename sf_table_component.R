# sf_table_compo
# 
#

library(shiny)
library(tidyverse)
library (lubridate)


#bullet indicator
sf_bullet_indicator = function(title , actual, target  , qualifiers , max_value, height = "inherit" ,   width = "inherit" ) {
    
    tick_font = list (family = "Trebuchet, sans-serif" 
                      , size = 10 
                      #, color = "#e1e4e8"
    )
    
     gauge_steps = qualifiers%>%
                         pmap( function (qualifier , range , color) {
                             list (range = range , color = color)
                         })
                         
     axis_range = list(range = list(NULL, max_value))

     
     plot_ly(height = height , width = width)  %>%
        add_trace(
            type =  "indicator",
            mode = "number+gauge+delta",
            value = actual,
            delta = list(reference = target ,position="top", font = list ( size = "50em" )) ,
            domain = list(x = c(0.25, 1), y = c(0.7, 0.9)),
            title = list(text = title , font = tick_font),
            gauge = list(
                shape = "bullet",
                axis = axis_range,
                threshold = list(
                    line = list(color = "black", width = 2),
                    thickness = 0.75,
                    value = target),
                steps = gauge_steps,
                bar = list(color = "black")))%>%
        layout( margin = list(l= 0, r= 0, t=0, b= 0) )  %>%
        config(displayModeBar = F)
    
   
}
#spike indicator 
sf_spike_indicator = function(tb, actual, target, height = "inherit" ,   width = "inherit" ) {
   
    tb %>% 
    plot_ly ( height = height , width = width) %>% 
        add_lines(x= ~x , y=~y , color = I ("black") ,  showlegend =F  ,hoverinfo='none') %>% 
        add_markers(x= ~last (x) , y= ~ last( y) 
                    , color =  ~I ( if_else(actual <  target , "#f03b20" , "#31a354") ) 
                    , size = 2
                    ,  showlegend =F
                    ,hoverinfo='none'
        )%>%
        layout(
            xaxis = list(title = "", showticklabels =F , showline =F   , showgrid =F ,  zeroline = FALSE),
            yaxis = list(title = "" ,showticklabels =F, showline =F ,  showgrid =F ,  zeroline = FALSE) 
            , margin = list(l= 0, r= 0, t=0, b=0) 
           
        ) %>%
        config(displayModeBar = F)
    
}

#show legend
sf_qualifier_legend = function (tb , height = "inherit" ,   width = "inherit" ) {
  
  tick_font = list (family = "\"Trebuchet MS\", sans-serif" 
                    , size = 10 
                    #, color = "#e1e4e8"
  )
  
  tb %>%
    plot_ly (height = height , width = width) %>%
    add_markers(x = ~ qualifier , y= "b" , color = ~ I (color) , size = 2 , marker = list (symbol="square" )   )%>%
    #add_text (x = ~ qualifier, y= "b" , text =  ~ qualifier , textposition = "bottom center") %>%
    add_annotations(x = ~ qualifier, y= "b"  , text =  ~ qualifier, font = tick_font , ax=0, ay= 15 , showarrow=T
                    ,  arrowcolor = I ("white") ,  arrowhead = 0 , allign = "bottom")  %>%
    layout(showgrid =F 
           ,  xaxis = list(title = "",
                           showline =F  
                           , showgrid =F 
                           , showticklabels =F 
                           , zeroline = FALSE 
                           , categoryorder = "array"
                           , categoryarray = ~qualifier)
           , yaxis = list(title = ""
                          ,  showline =F 
                          , showgrid =F 
                          , showticklabels =F 
                          , zeroline = FALSE )
           , margin = list(l= 0, r= 0, t=0, b= 0)
    )%>%
    config(displayModeBar = F) 
}

sf_table_component = function(tb ) {
    
        table_caption = "Key Metrics"
        head =  list (tags$tr ( tags$th ("Measure")
                          , tags$th ("Past 12 Months")
                          , tags$th ("Actual")
              ) )
    
        tb_qualifiers =  tb  %>% 
                          select (qualifiers) %>% 
                          head(1) %>%
                          unnest() 
          
        tb  %>% 
        pmap( function (measure , actual ,target , hist_data , qualifiers ) {
                max_value = max (hist_data$y)
                actual = ifelse ( is.na(actual) , last(hist_data$y) , actual)
                print (actual )
                tags$tr (
                          tags$td (sf_bullet_indicator (measure,  actual , target ,qualifiers, max_value,  height = 80  , width = 200 ) )
                         ,tags$td (sf_spike_indicator ( hist_data ,actual , target ,height = 50  , width = 200 ) ) 
                         ,tags$td (actual , style = "text-align: center; ")
                        )
            } )  %>% 
        append(head , .) %>% 
        tags$table( class = "topic" ,  tags$style( ".topic tr { }
                                                    .topic th {color: grey;font-size: 15px; text-align: left;
                                                            font-family: \"Trebuchet MS\", sans-serif;
                                                            border-bottom: 2px solid grey;
                                                            vertical-align:bottom}
                                                   .topic caption { font-family: \"Trebuchet MS\", sans-serif;
                                                                    font-size: 20px;
                                                                    font-weight:bold;}" ) 
                                      
                                    , tags$caption(  tags$table(
                                                                    tags$tr(width = "100%",
                                                                            tags$td(width = "80%", div(style = "font-size:20px;", table_caption)),
                                                                            tags$td(width = "20%",  div(style = "font-size:5px;font-weight:normal;", sf_qualifier_legend (tb_qualifiers , height = 30  , width = 120) ))
                                                                    ))
                                                    )
        )
    
}

