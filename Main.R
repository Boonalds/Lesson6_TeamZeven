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
ndviMunicipality <- extract.ndvi(ndvibrick, nlCitySinu)

# Plot map
colorPal <- colorRampPalette(brewer.pal(9, "YlGn"))(18)
spplot(ndviMunicipality['YearAVG'], main = 'NDVI per municipality in the Netherlands', 
       sub = 'ModisData February 2000', xlab = 'Latitude', ylab ='Longitude',
       sp.layout=list(list("SpatialPolygonsRescale", layout.north.arrow(), offset = c(250000,5890000), 
                           scale = 50000, fill=c("transparent","black"))),
       col.regions = colorPal, scales=list(draw=T), colorkey=T)
?spplot
?plot
?ggplot
