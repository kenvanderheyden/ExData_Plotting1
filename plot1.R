# plot1.R - generate plot1.png
# shows Global_active_power frequencies, in a histogram, with red bars

setClass('myDate') # remove warning during read
setClass('myTime') # remove warning during read

elPowerCons <- read.csv2(
    "household_power_consumption.txt", 
    colClasses = c(setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y")), setAs("character","myTime", function(from) as.Date(from, format="%h/%M/%s")), "factor", "factor", "factor", "factor", "factor", "factor", "factor"), 
    as.is = TRUE,
    skip=grep("31/1/2007;23:59:00", readLines("household_power_consumption.txt")), # skip lines up to (and including) "31/1/2007;23:59:00"
    nrows=2879, # 1 line per minute, range = 2 days (1440 minutes per day)
    header = FALSE # first line read is not the header
    )

# assign column names to the data.frame (as they are not read from the file due to the skip feature)
colnames(elPowerCons) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

# draw the histogram
hist(elPowerCons$Global_active_power, col ="red")