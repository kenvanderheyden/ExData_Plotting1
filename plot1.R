# plot1.R - generate plot1.png
# shows Global_active_power frequencies, in a histogram, with red bars

setwd("~/Documents/Machine Learning/exploratory data analysis/ExData_Plotting1")

# current setup reads the file twice: onse to find the skip row with grep, and another read to get the actual data into R
elPowerCons <- read.csv2(
    "household_power_consumption.txt", 
    colClasses = c(rep("character", 9)), # read the columns as strings, because they are quoted (TODO: find an alternative to remove or ignore the quotes for numeric columns?)
    as.is = TRUE,
    skip=grep("31/1/2007;23:59:00", readLines("household_power_consumption.txt")), # skip lines up to (and including) "31/1/2007;23:59:00"
    nrows=2879, # 1 line per minute, range = 2 days (1440 minutes per day)
    header = FALSE,  # first line read is not the header
    na.strings = "?"
    )

# assign column names to the data.frame (as they are not read from the file due to the skip feature (TODO: check if a better solution exists ?)
colnames(elPowerCons) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

# convert the Global_active_power column to numeric type
elPowerCons$Global_active_power <- as.numeric(elPowerCons$Global_active_power)

# draw the histogram
hist(elPowerCons$Global_active_power, col ="red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

dev.copy(png,'plot1.png')
dev.off()