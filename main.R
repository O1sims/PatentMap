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
RFunctionFiles <- getwd() %>% 
  paste0("/R/") %>% 
  list.files(
    pattern = "*.R")

for (file in RFunctionFiles) getwd() %>% 
  paste0("/R/", file) %>% 
  source()

# Collect the geographical data
geoData <- getGeoData()

# Generate the European patent map
patentMap <- generateMap(
  neigh = geoData$neigh, 
  bord = geoData$bord, 
  gd3 = geoData$gd3)
