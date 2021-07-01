# data frame :: id, date, longitude, latitude, species
# x <- read.csv("patient1.csv",encoding="UTF-8",sep=",")
#install.packages("geosphere")
library(geosphere)
Taoyuan_df <- read.csv("Taoyuan_set.csv",encoding="UTF-8-BOM",sep=",")
Pingtung_df <- read.csv("Pingtung_set.csv",encoding="UTF-8-BOM",sep=",")
p1 <- Taoyuan_df %>% select(id,date,longitude,latitude,species)
p2 <- Pingtung_df %>% select(id,date,longitude,latitude,species)
p <- rbind(p1,p2)
p$id <- as.numeric(p$id)
p$longitude <- as.numeric(p$longitude)
p$latitude <- as.numeric(p$latitude)

# select species & set icon
virusIcon <- icons(
  iconUrl = ifelse(p$species == "delta",
                   "delta.png",
                   "normal.png"),
  iconWidth = 30, iconHeight = 30
)
UserIcon <- icons(
  iconUrl = "pigeon1.png",
  iconWidth = 50, iconHeight = 50
)
# set content
# make map
# m = leaflet(data = p ) %>% 
#    addTiles() %>%
#    addMarkers(~longitude, ~latitude, icon = virusIcon, popup = paste(sep = "<br/>",
#                                                                      p$id,
#                                                                      p$date,
#                                                                      p$species))
# measure every node distance
isCross <- function(lng1, lat1, lng2, lat2) { #500 meters
  ifelse(distm(c(lng1, lat1), c(lng2, lat2), fun = distHaversine) <= 500
         , return(TRUE), return(FALSE))
}
# 
Taoyuan_Anchor <- c(121.2988176,24.9931569)#city government
Pingtung_Anchor <- c(120.485725,22.6829699)#city government
crossSummary <- function(Lng,Lat) {
   #select small dataset, it can adjust for every city
   TaoyuanDis <- distm(c(Lng,Lat), c(121.2988176,24.9931569), fun = distHaversine)# shit don't add "()"
   PingtungDis <- distm(c(Lng,Lat), c(120.485725,22.6829699), fun = distHaversine)
   normalCount <- 0
   deltaCount <- 0
  #pick nearest city if have considerable cities use min, index, priority_queue
  if(TaoyuanDis < PingtungDis) {
    #it can split to become function if lots of cities
     for (i in c(1:length(p1[,1]))) {
       if(isCross(Lng,Lat,p1[i,3],p1[i,4])) {# !!! dangerous because of select
         if(p1[i,5] == "delta"){
           deltaCount = deltaCount + 1
         } else {
           normalCount = normalCount + 1
         }
         #ifelse(p1[i,5] == "delta", deltaCount = deltaCount + 1, normalCount = normalCount + 1)
       }
     }
   } else {
     for (i in c(1:length(p2[,1]))) {
       if(isCross(Lng,Lat,p2[i,3],p2[i,4])) {
         if(p1[i,5] == "delta"){
           deltaCount = deltaCount + 1
         } else {
           normalCount = normalCount + 1
         }
         #ifelse(p2[i,5] == "delta", deltaCount = deltaCount + 1, normalCount = normalCount + 1)
       }
     }
   }
  return(c(normalCount,deltaCount))
}

