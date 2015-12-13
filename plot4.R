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

createPlot4 <- function(data) {
    png(filename="plot4.png", width = 480, height = 480, units = "px", bg = "transparent")
    Sys.setlocale("LC_TIME", "en_US.UTF-8")
    par(mfrow=c(2, 2))
    
    # Global Active Power lines plot
    plot(data$Time, data$Global_active_power, type="n", xlab="", ylab="Global Active Power (kilowatts)")
    lines(data$Time, data$Global_active_power, type="l")
    
    # Voltage lines plot
    plot(data$Time, data$Voltage, type="n", xlab="datetime", ylab="Voltage")
    lines(data$Time, data$Voltage, type="l")
    
    # Sub metering multiple lines plot
    Sys.setlocale("LC_TIME", "en_US.UTF-8")
    plot(data$Time, data$Sub_metering_1, type="n", xlab="", ylab="Energy sub metering")
    lines(data$Time, data$Sub_metering_1, type="l", col="black")
    lines(data$Time, data$Sub_metering_2, type="l", col="red")
    lines(data$Time, data$Sub_metering_3, type="l", col="blue")
    legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           lty=c(1, 1, 1), lwd=c(1.5, 1.5), col=c("black", "red", "blue"))
    
    # Global Reactive Power lines plot
    plot(data$Time, data$Global_reactive_power, type="n", xlab="datetime", ylab="Global_reactive_power")
    lines(data$Time, data$Global_reactive_power, type="l")
    dev.off()
}

getElectricData()
createPlot4(loadElectricData())