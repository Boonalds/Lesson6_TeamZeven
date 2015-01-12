extract.ndvi <- function(ndvilayer, municipalities){
  meanndvi <- extract(ndvilayer,municipalities, method='simple', fun=mean, na.rm=T, sp=T, df=T)
  p <- meanndvi@data
  q <- p[,15:26]
  meanndvi$avg <- rowMeans(p[,15:26])  
  return(meanndvi)
   }

e <- extract.ndvi(ndvibrick, nlCitySinu)