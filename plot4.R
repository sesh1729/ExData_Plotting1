library(sqldf)

#Define a file name
filename<-"household_power_consumption.zip"

#Check if the file already exists, and download if it doesn't exist already
if(!file.exists(filename)){
    download.file(destfile = filename,method='curl',url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip')
}

#Check if the directory exists, and unzip the file if the directory doesn't exist already
if(!file.exists("household_power_consumption.txt")){
    unzip(filename)
}

# Read the data for only two dates in February
power_data <- read.csv.sql("household_power_consumption.txt", sep = ";",
                      sql = "select * from file where Date = '2/2/2007' OR Date ='1/2/2007' ")

# setting the date and time in the proper format
power_data$Date<-as.Date(power_data$Date,"%d/%m/%Y")
power_data$DateTime<-strptime(paste(power_data$Date, power_data$Time),format="%F %T")
# delete Duplicate Columns
power_data$Date<-NULL
power_data$Time<-NULL

# plot the data to plot2.png, using the plot function with "l" type for a line graph
png(filename = "plot4.png")
par(mfrow = c(2, 2))
with(power_data, {

#Plot a
plot(DateTime,Global_active_power,"l",ylab = "Global Active Power (kilowatts)",xlab="")

#Plot b
plot(DateTime,Voltage,"l",ylab = "Voltage",xlab="datetime")

#Plot c
plot(DateTime,Sub_metering_1,"l",col="black",xlab="",ylab="Energy sub metering")
lines(DateTime,Sub_metering_2,col="red")
lines(DateTime,Sub_metering_3,col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black", "red", "blue"),lty=1)

#Plot d
plot(DateTime,Global_reactive_power,"l",ylab = "Global_reactive_power",xlab="datetime")

})
dev.off()
