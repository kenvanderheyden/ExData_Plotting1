# plot2.R - generate plot2.png

# Fix for x axis labels: without this localse setting the labels would appear in Dutch language style. 
Sys.setlocale("LC_TIME", "en_US.UTF-8")

# set the working directory
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

# combine Date and Time column in one new column DT to over come error "Error in plot.window(...) : need finite 'xlim' values"
elPowerCons$DT <- with(elPowerCons, as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M"))

# draw the histogram with the new DT field
plot(Global_active_power ~ DT, data=elPowerCons, type="l", xlab = "", ylab = "Global Active Power (kilowatts)")

# after drawing, copy and save to a png file
dev.copy(png,'plot2.png')
dev.off()

# RESET LOCALE SETTING back to "belgian" style
Sys.setlocale("LC_TIME", "nl_BE.UTF-8")