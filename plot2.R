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

#Plots a line chart of Global Active Power and datetime
plot(DT[,Global_active_power]~DT[,datetime], type="l", xlab= "",
     ylab="Global Active Power (kilowatts)")

#Save pgn to local directory
dev.copy(png, file="plot2.png", height=480, width=480, bg = "transparent")
dev.off()



