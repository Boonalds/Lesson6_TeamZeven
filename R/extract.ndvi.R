extract.ndvi <- function(ndvilayer, regions){
  # Function that calculates the mean ndvi per region per month and the average ndvi per year
  # 'ndvilayer' is a raster map with the ndvi values, 'regions' is a spatialpolygonsdataframe with the regions
  meanndviSpat <- extract(ndvilayer, regions, method='simple', fun=mean, na.rm=T, sp=T, df=T) #Extract the mean ndvi per region and add them to the dataframe
  meanndviData <- meanndviSpat@data # get the ndvidata
  meanndviSpat$YearAVG <- rowMeans(meanndviData[,15:26]) # caculate the average ndvi per region per year and add it to the spatialpolygonsdataframe
  return(meanndviSpat)
  }