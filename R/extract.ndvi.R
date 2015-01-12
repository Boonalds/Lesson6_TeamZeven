extract.ndvi <- function(ndvilayer, boundarylayer){
  meanndviSpat <- extract(ndvilayer, boundarylayer, method='simple', fun=mean, na.rm=T, sp=T, df=T)
  meanndviData <- meanndviSpat@data
  meanndviSpat$YearAVG <- rowMeans(meanndviData[,15:26])  
  return(meanndviSpat)
  }

ndviMunicipality <- extract.ndvi(ndvibrick, nlCitySinu)
