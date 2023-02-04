# libraries
library(packcircles)
library(ggplot2)
library(viridis)
library(ggiraph)
library(extrafont)

bubbleplot <- function(df, minY,maxY, MinDisp){
  # # Create data
  data <- df %>% select(ModelYear, Make) %>% filter(ModelYear %in% (minY:maxY)) %>% select(Make) %>% table() %>% as.data.frame() %>% filter(Freq !=0 & Freq > MinDisp)

  # Add a column with the text you want to display for each bubble:
  data$text <- paste("Make: ",data$Make, "\n", "Number: ", data$Freq)

  # Generate the layout
  packing <- circleProgressiveLayout(data$Freq, sizetype='area')
  data <- cbind(data, packing)
  dat.gg <- circleLayoutVertices(packing, npoints=50)

  # Make the plot with a few differences compared to the static version:
p <- ggplot() +
    geom_polygon_interactive(data = dat.gg, aes(x, y, group = id, fill=id, tooltip = data$text[id], data_id = id), colour = "black", alpha = 0.6) +
    scale_fill_viridis() +
    geom_text(data = data, aes(x, y, label =paste(Make,'\n',Freq) ), size=5, color="black") +
    theme_void() +
    theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm") ) +
    coord_equal()

  # Turn it interactive
    return(p)
}
# bubbleplot(new_evp, 2000,2020, 100)

# # save the widget
# # library(htmlwidgets)
# # saveWidget(widg, file=paste0( getwd(), "/HtmlWidget/circular_packing_interactive.html"))
#