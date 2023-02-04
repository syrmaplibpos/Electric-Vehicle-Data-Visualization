# Library
library(fmsb)
library(ggplot2)
library(tidyverse)
library(dplyr)
library(plotly)
library(gapminder)
library(fmsb)


webplot <- function(df, minY,maxY, Brand){
  data <- df %>% 
    select(ModelYear, Make, Model) %>% 
    filter(ModelYear %in% (minY:maxY)) %>% 
    filter(Make == Brand) %>% 
    table() %>% as.data.frame() %>% 
    select(Model, Freq) %>% 
    group_by(Model) %>% 
    summarise_at(vars(Freq), sum) %>% 
    spread(Model, Freq)
  data <- round((data/rowSums(data))*100,1) %>% as.data.frame()
  
  
  max_each_row <- apply(data, 1, max, na.rm=TRUE)
  
  data <- rbind(rep(100, ncol(data)), rep(0, ncol(data)), data)
  
  
  # Custom the radarChart !
  radarchart( data  , axistype=1 , 
              
              #custom polygon
              pcol=rgb(0.0,0.0,0.54,0.9) , pfcol=rgb(0.0,0.0,0.54,0.5) , plwd=2 ,
              
              #custom the grid
              cglcol="grey", cglty=1, axislabcol="grey", caxislabels=paste(seq(0,100,25), "%", sep = ""), cglwd=0.8,
              
              #custom labels
              vlcex=0.8
  )
}
# webplot(2016, 2020, 'KIA')
# webplot(minY,maxY, Make)




