library(sp)
library(rgdal)
library(rgeos)
library(ggplot2)
library(stringi)
library(stringr)
library(ggthemes)
library(magrittr)
library(tidyverse)
library(hrbrthemes)


# Source all R functions required into the Global Environment
print("INFO: Sourcing requred functions into the current workspace...")

RFunctionFiles <- getwd() %>% 
  paste0("/R/") %>% 
  list.files(
    pattern = "*.R")

for (file in RFunctionFiles) getwd() %>% 
  paste0("/R/", file) %>% 
  source()

print("SUCCESS: Successfully sourced all functions from the `R` directory!")

# Collect the geographical data
print("INFO: Collecting geographical data...")

geoData <- getGeoData()

print("SUCCESS: Successfully collected all geographical data!")

# Generate the European patent map
print("INFO: Generating the European patent map...")

patentMap <- generateMap(
  neigh = geoData$neigh, 
  bord = geoData$bord, 
  gd3 = geoData$gd3)

print("SUCCESS: Successfully generated the European patent map and saved to the `images` directory!")
