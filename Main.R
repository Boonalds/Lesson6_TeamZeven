# Authors: Rob Maas & Wilmar van Ommeren
# Date: 12-1-2015

# Load libraries
library(sp)
library(raster)
library(rgdal)
library(RColorBrewer)

# Load source scripts
source('./R/extract.ndvi.R')

# Download and prepare modis data
download.file(url = 'https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip', 
              destfile = 'Data/MODISdata.zip', method = 'auto')
unzip('Data/MODISdata.zip', overwrite = T, exdir = './Data')

modisPath <- list.files('./Data',pattern = glob2rx('*.grd'), full.names = TRUE)
ndvibrick <- brick(modisPath)

# Download municipality boundaries
nlCity <- getData('GADM',country='NLD', level=3, path = './Data')

# Make both datasets the same CRS
brickproj<-projection(ndvibrick)
nlCitySinu <- spTransform(nlCity, CRS(brickproj))

# Calculate mean ndvi values
ndviRescale <- calc(ndvibrick, fun=function(x)x/10000)
ndviMunicipality <- extract.ndvi(ndviRescale, nlCitySinu)

## The greenest city
# January
maxndviJan <- which.max(ndviMunicipality$January)
maxcityJan <- ndviMunicipality$NAME_2[maxndviJan]
paste('The greenest city in January is', maxcityJan)

# August
maxndviAug <- which.max(ndviMunicipality$August)
maxcityAug <- ndviMunicipality$NAME_2[maxndviAug]
paste('The greenest city in August is', maxcityAug)

# On average over the year
maxndviYear <- which.max(ndviMunicipality$YearAVG)
maxcityYear <- ndviMunicipality$NAME_2[maxndviYear]
paste('The greenest city in on average over the year is', maxcityYear)

# Plot map
colorPal <- rev(colorRampPalette(brewer.pal(9, "Spectral"))(20)) # Create color palette
spplot(ndviMunicipality['YearAVG'], main = 'Annual mean NDVI per municipality in the Netherlands', 
       sub = 'ModisData of February 2000', xlab = 'Longitude', ylab ='Latitude',
       sp.layout=list(list("SpatialPolygonsRescale", layout.north.arrow(),
                           offset = c(250000,5890000), 
                           scale = 50000, fill=c("transparent","black"))),
       col.regions = colorPal, scales=list(draw=T), colorkey=T)