#initializes data.table library
library(data.table)

#Reads in the data as a Data Table
DT<- fread("household_power_consumption.txt")

#Converts all columns to numeric, and coerces first column to Date class
#This is unfortunately necessary due to bug in fread
#See my discussion here: https://stackoverflow.com/questions/22331552/read-in-certain-numbers-as-na-in-r-with-data-tablefread
DT <- DT[, Date:=as.Date(Date, format="%d/%m/%Y")]

##Subsets the Data Table to the appropriate Date Range
DT <- subset(DT, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))

#Converts all non-Date and non-Time characters to numeric
DT<-cbind(DT[, 1, with=FALSE], DT[, 2, with=FALSE], DT[, lapply(.SD[, 3:9, with=FALSE], as.numeric)])

#Creates the DateTime column
DT <- DT[, datetime := as.POSIXct(paste(as.Date(DT$Date), DT$Time))]

#Transform columns into vectors for easy access
global_active <- DT$Global_active_power
voltage <- DT$Voltage
sub1 <- DT$Sub_metering_1
sub2 <- DT$Sub_metering_2
sub3 <- DT$Sub_metering_3
global_reactive <- as.numeric(dt$Global_reactive_power)
datetime <- DT$datetime

##Make the plot
#par is documented here http://www.inside-r.org/r-doc/graphics/par
par(mfrow=c(2,2))
  
  #Subplot 1
  plot(global_active ~ datetime, type="l", xlab="", ylab="Global Active Power")

  #Subplot 2
  plot(voltage ~ datetime, type="l", ylab="Voltage")

  #Subplot 3
  plot(sub1 ~ datetime, type="l", col="black", xlab="", ylab="Energy sub metering")
  lines(sub2 ~ datetime, col="red")
  lines(sub3 ~ datetime, col="blue")
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
        c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n") 

  #subplot 4
  plot(global_reactive ~ datetime, type="l", ylab="Global_reactive_power")

#Save pgn to local directory
dev.copy(png, file="plot4.png", height=480, width=480, bg = "transparent")
dev.off()


