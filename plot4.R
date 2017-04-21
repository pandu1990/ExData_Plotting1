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
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# Convert DateTime
data$Posix <- as.POSIXct(strptime(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S"))

#Plot graph
par(mfrow = c(2, 2))

# Plot 1
with(data, {
  plot(Posix, Global_active_power, type = "n", xlab = "", ylab = "Global Active Power (kilowatts)")
  lines(Posix, Global_active_power)
})

# Plot 2
with(data, {
  plot(Posix, Voltage, type = "n", xlab = "datetime", ylab = "Voltage")
  lines(Posix, Voltage)
})

# Plot 3
with(data, {
  plot(Posix, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
  lines(Posix, Sub_metering_1)
  lines(Posix, Sub_metering_2, col = "red")
  lines(Posix, Sub_metering_3, col = "blue")
  legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, cex = 0.7, bty = "n")
})

# Plot 4
with(data, {
  plot(Posix, Global_reactive_power, type = "n", xlab = "datetime")
  lines(Posix, Global_reactive_power)
})
     
# Save copy as PNG
dev.copy(png, file = "plot4.png")
dev.off()