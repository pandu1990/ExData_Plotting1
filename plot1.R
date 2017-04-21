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

# Histogram with appropriate title and label
hist(data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

# Save copy as PNG
dev.copy(png, file = "plot1.png")
dev.off()