library(shiny)
library(leaflet)
library(tidyverse)
library(rsconnect)
library(ggmap)
library(readr)


data <- read_csv("finaldata.csv")

idx = sample(1:14000, 2500,replace=FALSE)

data_sample = data[idx,]


latlong_data_data_sample <- geocode(data_sample$fullAddress, output = "latlona")

sample_data <- cbind(data_sample, latlong_data_data_sample)

write_csv(sample_data, "lat_data.csv")

test <- head(data)

