library(shiny)
library(leaflet)
library(tidyverse)
library(rsconnect)
library(ggmap)
library(readr)
library(USAboundaries)
library(rgdal)
library(htmltools)


# Get zip code boundaries
all_zip_bound <- readOGR(dsn = ".", layer = "cb_2016_us_zcta510_500k")

# Texas zip code data
tx_zip <- subset(all_zip_bound, ZCTA5CE10 %in% c(77001:77201, 77401))

# Get construciton data 
data_cleaned <- read_csv("lat_data_cleaned.csv")

data_income <- read_csv("income.csv")
data_income <- data_income %>% mutate(ZCTA5CE10 = zipcode)

## Get zip codes that we have income for
have_income_data <- data_income$zipcode
have_income <- tx_zip %>% subset((ZCTA5CE10 %in% have_income_data))
no_income_map <- tx_zip %>% subset(!(ZCTA5CE10 %in% have_income_data))

# Log transofmr data. Thanks Leebron's 12 milllion salary
#data_income <- data_income %>% mutate(income = log10(income))

have_income_map <- merge(have_income, data_income)

# Get a subsample of data_cleaned to reduce speed
# Instead we cluster it
idx = sample(1:2465, 2465,replace=FALSE)

data_sample = data_cleaned[idx,]

# Get subcategories of demolition
# Not using simple demolition
demo <- data_sample %>% filter(permitType == "Demolition")
demo_com <- data_sample %>% filter(permitType == "Commercial Demolition")
demo_res <- data_sample %>% filter(permitType == "Residential Demolition")

# Create icons
icon_blue <- awesomeIcons(icon = "whatever",
                          iconColor = "blue",
                          library = "ion",
                          markerColor = "blue")

icon_red <- awesomeIcons(icon = "whatever",
                         iconColor = "red",
                         library = "ion",
                         markerColor = "red")

icon_grey <- awesomeIcons(icon = "whatever",
                          iconColor = "grey",
                          library = "ion",
                          markerColor = "grey")

# Get subcategories of demolition
# Not using simple demolition
demo <- data_sample %>% filter(permitType == "Demolition")
demo_com <- data_sample %>% filter(permitType == "Commercial Demolition")
demo_res <- data_sample %>% filter(permitType == "Residential Demolition")


# Get income pallette
pal_income <- colorNumeric(
  palette = "viridis",
  domain = have_income_map$income,
  reverse = TRUE
  )


leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
  setView(lng = -95.406, lat = 29.710, zoom = 16) %>%
  addTiles( ) %>%  # Add default OpenStreetMap map tiles
  addAwesomeMarkers(data = demo_com, lng=~lon, lat=~lat, 
                    popup=~agencyID, icon = icon_blue,
                    group = "Commercial",
                    clusterOptions = markerClusterOptions()
  ) %>% # Commercial
  addAwesomeMarkers(data = demo_res, lng=~lon, lat=~lat, 
                    popup=~htmlEscape("test  test"), icon = icon_red, 
                    group = "Residential",
                    clusterOptions = markerClusterOptions()
  ) %>% # Residential
  addPolygons(data = have_income_map, color = ~pal_income(income),
              group = "Zip Boundaries") %>% # Borders w/ income
  addLayersControl( # Controls
    overlayGroups = c("Commercial", "Residential", "Zip Boundaries"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addLegend(data = have_income_map, "bottomright", pal = pal_income,
            values = ~income,# Legends
            title = "Average Income",
            labFormat = labelFormat(prefix = "$"),
            opacity = 1
  )




