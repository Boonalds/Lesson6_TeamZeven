# Authors: Rob Maas & Wilmar van Ommeren
# Date: 12-1-2015

# Load libraries
library(sp)
library(raster)
library(rgdal)

# Load source scripts

# Download and prepare data
download.file(url = 'https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip', 
              destfile = 'Data/MODISdata.zip', method = 'auto')
unzip('Data/MODISdata.zip', overwrite = T, exdir = './Data')

modisPath <- list.files('./Data',pattern = glob2rx('*.grd'), full.names = TRUE)
ndvibrick <- brick(modisPath)

# Download municipality boundaries
nlCity <- getData('GADM',country='NLD', level=3)

# Make both datasets the same coordinate projection
brickproj<-projection(ndvibrick)
nlCitySinu <- spTransform(nlCity, CRS(brickproj))

