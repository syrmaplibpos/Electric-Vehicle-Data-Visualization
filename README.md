# Electric-Vehicle-Data-Visualization

## Background

### What is the problem?
Electric charging speed is slow
Lack power when the weather is cold.
Long distance road trips
 
### Why is it worth further research?
EV is the general trend of the vehicle market
The government encourages to replace traditional vehicles with electric vehicles

How could you solve this problem?
Build more charging station, especially in suburbs
Provide EV market information to consumers

## Data Collection

Electric vehicles data are collected from [DATA.GOV](https://catalog.data.gov/dataset/electric-vehicle-population-data)

Electric vehicles that are currently registered through Washington State Department of Licensing (DOL) 

Charging station data are collected from [U.S. Department of Energy](https://afdc.energy.gov/fuels/electricity_locations.html#/find/nearest?fuel=ELEC)

## Data Structure

Charging station dataset:
65 columns
1583 rows

Electric vehicles population dataset 
17 columns
109,027 rows


## R Shiny Highlights 1 - Map

Bubble position indicates geographical location of electric vehicles

Bubble size and color show differences in vehicle volumes 

Pin position indicates geographical location of charging stations

## R Shiny Highlights 2 - Graphics

1. Bubble Plot

Circular packing allowing to visualize the ranking of a group of data.
Aggregating all vehicles of the same make during a given period assigned by the users.
Helping to clearly identify the Electric Vehicle market segments.

2. Web Plot

Radar chart displays the values in the form of multi-dimensional chart.
Each dimension represents the proportion of this model of this make.
Users can assign the make and adjust the time period in the side bar

## Results

The map page allows users to understand the EV and charging station distribution in the State of Washington 

The bubble plot provides information about which car brand sells the most EV in the market

The web plot provides information about which is the most popular model in each car brand.

## References

[https://rstudio.github.io/leaflet/shiny.html](https://rstudio.github.io/leaflet/shiny.html)

[https://shiny.rstudio.com/gallery/uber-rider.html](https://shiny.rstudio.com/gallery/uber-rider.html)

[https://github.com/eparker12/nCoV_tracker/blob/master/app.R ](https://github.com/eparker12/nCoV_tracker/blob/master/app.R)

[https://github.com/rstudio/shiny-examples/blob/main/063-superzip-example/ui.](https://github.com/rstudio/shiny-examples/blob/main/063-superzip-example/ui.)

[https://r-graph-gallery.com/spider-or-radar-chart.html](https://r-graph-gallery.com/spider-or-radar-chart.html)

[https://r-graph-gallery.com/circle-packing.html](https://r-graph-gallery.com/circle-packing.html)

[https://shiny.rstudio.com/gallery/shiny-theme-selector.html](https://shiny.rstudio.com/gallery/shiny-theme-selector.html)

[https://www.kaggle.com/code/erikbruin/house-prices-lasso-xgboost-and-a-detailed-eda](https://www.kaggle.com/code/erikbruin/house-prices-lasso-xgboost-and-a-detailed-eda)








