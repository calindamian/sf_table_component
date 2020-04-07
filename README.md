# Shinny table dashboard component.

Shinny widget trying to simulate Stephen Few table dashboard component

## Inspiration
The widget is inspired by the archetype Sales Dashboard design from Few’s book Information Dashboard Design.

![image](https://user-images.githubusercontent.com/61669129/78679958-2b75a780-78eb-11ea-8796-005e2725e062.png)

## Demo

Demo available at https://calindamian.shinyapps.io/

## Usage
Files 
  -  ***sf_table_component_demo.R*** : contains the demo showing how to use the module.
  -  ***sf_table_component.R*** : contains code for the module

The component expects a tibble with following structure in order to work:

```
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


```
