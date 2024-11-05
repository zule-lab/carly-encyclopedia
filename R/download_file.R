download_file <- function(url, dest){
  if (extension == 'csv') {
    download_csv(url, dest)
  } else if (extension == 'tif') {
    download_tif(url, dest)
  } else if (extension == 'shp') {
    download_shp(url, dest)
  } else if (extension == 'zip'){
    
  }
}


download_tif <- function(url, dest, file){
  download.file(url, dest)
  r <- rast(file.path("/vsizip", dest, file))
  return(r)
}


download_csv <- function(url){
  temp <- tempfile()
  download.file(url, temp, mode = "wb")
  master <- as.character(unzip(temp, list = TRUE)$Name)
  df <- read.csv(unz(temp, master[1]))
  return(df)
}


download_shp <- function(url, dest){
  download.file(url, dest, mode = "wb")
  shp <- st_read(file.path("/vsizip", dest))
  return(shp)
}
