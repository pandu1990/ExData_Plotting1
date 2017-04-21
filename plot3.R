url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename <- "household_power_consumption.txt"
zipFile <- "household_power_consumption.zip"

# Check if file exists, else download
if(!file.exists(filename)) {
  download.file(url, destfile = zipFile)
  unzip(zipFile)
  file.remove(zipFile)
}

library(data.table)

# Load data
data <- fread(filename, header = TRUE, sep = ";", colClasses = "character")

# Convert "?" to NA
data[data == "?"] <- NA

# Filter dates
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data <- data[data$Date >= as.Date("2007-02-01") & data$Date <= as.Date("2007-02-02")]

# Convert to numeric
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# Convert DateTime
data$Posix <- as.POSIXct(strptime(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S"))

# Histogram with appropriate title and label
with(data, {
  plot(Posix, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
  lines(Posix, Sub_metering_1)
  lines(Posix, Sub_metering_2, col = "red")
  lines(Posix, Sub_metering_3, col = "blue")
  legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)
})
     
# Save copy as PNG
dev.copy(png, file = "plot3.png")
dev.off()