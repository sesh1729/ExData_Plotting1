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

# plot the data to plot1.png
png(filename = "plot1.png")
hist(power_data$Global_active_power,xlab="Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power", col = "Red")
dev.off()
