#!/usr/bin/Rscript
ZipFilename <-"exdata_data_household_power_consumption.zip"
Filename <- "household_power_consumption.txt"
FileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

getElectricData <- function() {
    if(!file.exists(Filename)) {
        if(!file.exists(ZipFilename)) {
            download.file(FileUrl, destfile = ZipFilename, method = "curl")
        }
        unzip(ZipFilename)
    }
}

loadElectricData <- function() {
    ColNames = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
                 "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
    data <- read.csv("household_power_consumption.txt", sep=";", skip=66636, nrows=2880,
                    col.names=ColNames, na.strings="?")
    data$Time = strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
    data$Date <- NULL
    data
}

createPlot1 <- function(data) {
    png(filename="plot1.png", width = 480, height = 480, units = "px", bg = "transparent")
    hist(data$Global_active_power, breaks=12, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
    dev.off()
}

getElectricData()
createPlot1(loadElectricData())