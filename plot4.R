# Quick check of data size - assume each cell is 8 bytes
8*2075259*9 / 1000000   #149Mb

# Download data
if(!dir.exists("./datadownload")) {dir.create("./datadownload")}
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              destfile = "./datadownload/raw_data.zip")

# Unzip the data
unzip("./datadownload/raw_data.zip", exdir = "./datadownload")

# Read in the data
data <- read.table(file = "./datadownload/household_power_consumption.txt",
                   header = TRUE,
                   sep = ";",
                   na.strings = "?")

# Confirm object size
print(object.size(data), units = "auto")  #143Mb

# Convert dates and times to correct format
data$datetime <- strptime(paste(data$Date,data$Time), format = "%d/%m/%Y %H:%M:%S")
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Filter out dates we are not interested in
data <- data[data$Date >= '2007-02-01' & data$Date <= '2007-02-02',]


# Open graphics device
png(filename = "plot4.png", width = 480, height = 480)

# Set Parameters
par(mfrow = c(2,2))

# Plot 1
plot(data$datetime, data$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power")

# Plot 2
plot(data$datetime, data$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")

# Plot 3
plot(data$datetime, data$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering")
lines(data$datetime, data$Sub_metering_2, col = "red")
lines(data$datetime, data$Sub_metering_3, col = "blue")
legend("topright", 
       col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1,
       bty = "n")

# Plot 4
plot(data$datetime, data$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reative_power")

# Close graphics device
dev.off()

# Restor Parameters
par(mfrow = c(1,1))
