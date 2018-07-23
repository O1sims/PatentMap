library(rgeos)
library(sp)


getGeoData <- function() {
        filePath <- "data/geodata"
        
        ifelse(
                test = !dir.exists(filePath),
                yes = dir.create(filePath),
                no = paste("Directory already exists"))
        
        # Download Eurostat NUTs data
        f <- tempfile()
        download.file(
                url = "http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2013_20M_SH.zip", 
                destfile = f)
        unzip(
                zipfile = f, 
                exdir = filePath %>% paste0("/."))
        NUTS_raw <- rgdal::readOGR(
                filePath %>% paste0("/NUTS_2013_20M_SH/data/."), 
                "NUTS_RG_20M_2013")
        
        names(NUTS_raw@data) <- tolower(names(NUTS_raw@data))
        
        # Change coordinate system to LAEA Europe (EPSG:3035)
        # See: https://espg.io
        epsg3035 <- "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
        NUTS <- spTransform(NUTS_raw, CRS(epsg3035)) 
        
        # Create borders between countries
        NUTS0 <- NUTS[NUTS$stat_levl_ == 0, ]
        Sborders <- identifyBorders(NUTS0)
        bord <- fortify(Sborders)
        
        # Subset NUTS-3 regions
        NUTS3 <- NUTS[NUTS$stat_levl_ == 3, ]
        
        # Remote areas to remove (NUTS-2)
        remote <- c(paste0('ES', c(63, 64, 70)), 
                    paste('FRA', 1:5, sep = ''), 'PT20', 'PT30')
        
        # Make the geodata ready for ggplot
        gd3 <- fortify(NUTS3, region = "nuts_id") %>% 
                filter(!str_sub(id, 1, 4) %in% remote,
                       !str_sub(id, 1, 2) == "AL")
        
        # Add neighbouring countries
        f <- tempfile()
        download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/CNTR_2010_20M_SH.zip", destfile = f)
        unzip(f, exdir = "data/geodata/.")
        WORLD <- readOGR("data/geodata/CNTR_2010_20M_SH/CNTR_2010_20M_SH/Data/.",
                         "CNTR_RG_20M_2010")
        
        # colnames to lower case
        names(WORLD@data) <- tolower(names(WORLD@data))
        
        # filter only Europe and the neighbouring countries
        neigh_subset <- c("AT", "BE", "BG", "CH", "CZ", "DE", "DK", 
                          "EE", "EL", "ES", "FI", "FR", "HU", "IE", "IS", "IT", "LT", "LV", 
                          "NL", "NO", "PL", "PT", "SE", "SI", "SK", "UK", "IM", "FO", "GI", 
                          "LU", "LI", "AD", "MC", "MT", "VA", "SM", "HR", "BA", "ME", "MK", 
                          "AL", "RS", "RO", "MD", "UA", "BY", "RU", "TR", "CY", "EG", "LY", 
                          "TN", "DZ", "MA", "GG", "JE", "KZ", "AM", "GE", "AZ", "SY", "IQ",
                          "IR", "IL", "JO", "PS", "SA", "LB", "MN", "LY", "EG")
        
        NEIGH <- WORLD[WORLD$cntr_id %in% neigh_subset, ]
        
        # reproject the shapefile to a pretty projection for mapping Europe
        Sneighbors <- spTransform(NEIGH, CRS(epsg3035))
        
        # cut off everything behind the borders
        rect <- rgeos::readWKT(
                "POLYGON((20e5 10e5,
                80e5 10e5,
                80e5 60e5,
                20e5 60e5,
                20e5 10e5))")
        
        Sneighbors <- rgeos::gIntersection(
                Sneighbors,
                rect,
                byid = TRUE)
        
        neigh <- fortify(Sneighbors)
        
        return(list(
                gd3 = gd3,
                neigh = neigh,
                bord = bord))
}