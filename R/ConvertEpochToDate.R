ConvertUnixEpoch<-function(time)
{   
  val <-as.POSIXct(time,tz = "UTC", origin="1970-01-01")
  
  result <- as.Date(as.POSIXct(val, tz = "UTC",origin="1970-01-01"))
  
  return(result)
}



