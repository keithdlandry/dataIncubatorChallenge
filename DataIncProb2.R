library(plyr)
library(pryr)

listOfFiles <- c("~/Downloads/201502-citibike-tripdata.csv",
				 "~/Downloads/201503-citibike-tripdata.csv",
				 "~/Downloads/201504-citibike-tripdata.csv",
				 "~/Downloads/201505-citibike-tripdata.csv",
				 "~/Downloads/201506-citibike-tripdata.csv",
				 "~/Downloads/201507-citibike-tripdata.csv",
				 "~/Downloads/201508-citibike-tripdata.csv",
				 "~/Downloads/201509-citibike-tripdata.csv",
				 "~/Downloads/201510-citibike-tripdata.csv",
				 "~/Downloads/201511-citibike-tripdata.csv",
				 "~/Downloads/201512-citibike-tripdata.csv")
				 
df <- read.csv("~/Downloads/201501-citibike-tripdata.csv")
	 
for (file in listOfFiles){
	
	temp <- read.csv(file)
	df   <- rbind(df,temp)
	rm(temp)
}

#convert to time date format
df$starttime <- as.POSIXct(df$starttime, format = "%m/%d/%Y %H:%M") 
df$stoptime  <- as.POSIXct(df$stoptime, format = "%m/%d/%Y %H:%M")
tripDurration <- df$stoptime - df$starttime
#answer 1
print("median trip durration")
sprintf("%.10f", median(tripDurration*60))



#answer 2
print("fraction of rides that start and end at same station")
fracStartEndSame <- dim(df[df$start.station.id == df$end.station.id,])[1]/dim(df)[1]
print("fraction of rides start and end same station")
sprintf("%.10f", fracStartEndSame)


nVisit <- vector()
for (bID in unique(df$bikeid)){
	nVisit <- c(nVisit, length(unique(c(df$start.station.id[df$bikeid == bID], df$end.station.id[df$bikeid == bID]))))	
}
print("standard deviation of stations visited")
sprintf("%.10f", sd(nVisit))




#answer 6
days <- c(1:31)
months <- c(1:12)
hours <- c(0:23)
dateTimes <- as.POSIXlt("1/1/2015 0:00", format = "%m/%d/%Y %H:%M")


for (month in months){
	for (day in days){
		for (hour in hours){
			d <- sprintf("%i/%i/2015 %i:00", month, day, hour)
			dFormat <- as.POSIXlt(d, format = "%m/%d/%Y %H:%M")
			if (!is.na(dFormat)){
				dateTimes <- c(dateTimes, dFormat)
			}
		}
	}
}
dateTimes <- dateTimes[-1]

hiHUF <- 0
for (i in 1:length(dateTimes){
	
	i = 1
	
	stationFreq <- as.data.frame(table(df$start.station.id[df$starttime >= dateTimes[i] & df$starttime < dateTimes[i+1]]))
	
	maxFreq <- max(stationFreq$Freq)
	nRideStarts <- sum(stationFreq$Freq)
	HUF <- maxFreq/nRideStarts
	
	if (HUF > hiHUF){
		hiHUF <- HUF
	}

	maxstationId <- stationFreq$Var1[stationFreq$Freq == maxFreq]
}
print("highest usage fraction")
sprintf("%.10f", hiHUF)



#answer 7
cOver <- nrow(df[df$stoptime - df$starttime > 30 & df$usertype == "Customer",])

sOver <- nrow(df[df$stoptime - df$starttime > 45 & df$usertype == "Subsciber",])

overFrac <- (cOver+sOver)/nrow(df)
print("fraction of rides over time")
sprintf("%.10f", overFrac)





#answer 5?
df$shortdate <- strftime(df$starttime, format = "%m/%Y")
df$duration <- (df$stoptime - df$starttime)*60 

monthlyAvgDur <- ddply(df, .(shortdate), summarize, mean(as.double(duration)))
diff <- max(monthlyAvgDur[2]) - min(monthlyAvgDur[2])

print("diff between highest month avg duration and lowest month avg duration")
sprintf("%.10f", diff)




#answer great circle

deltaLat <- pi/180*df$end.station.latitude - pi/180*df$start.station.latitude
deltaLon <- pi/180*df$end.station.longitude - pi/180*df$start.station.longitude

r <- 6371 #km rad of earth

angle <- 2*asin(sqrt(sin(deltaLat/2)^2 + cos(pi/180*df$start.station.latitude)*cos(pi/180*df$end.station.latitude)*sin(deltaLon/2)^2))

length <- r*angle[angle < 100]

avgLen <- mean(length[length !=0]) #check max length on real thing though
print("average ride length")
sprintf("%.10f", avgLen)


#answer last question

nMoves <- vector()
for (bID in unique(df$bikeid)){
	starts <- df$start.station.id[df$bikeid == bID]
	ends   <- df$end.station.id[df$bikeid == bID]
	
	#shift ends down by one
	ends <- c(0,ends)
	starts <- c(starts,0)
	
	nMoves <- c(nMoves, count(ends != starts)[TRUE,2] - 2) #number of times not equal	
											  #subtract two because first and last rides.
}
print("avg times bike is moved")
avgMoves <- mean(nMoves)
sprintf("%.10f", avgMoves)


