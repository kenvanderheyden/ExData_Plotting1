# plot3.R - generate plot3.png

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

# convert the Sub_metering_x columns to numeric type
elPowerCons$Sub_metering_1 <- as.numeric(elPowerCons$Sub_metering_1)
elPowerCons$Sub_metering_2 <- as.numeric(elPowerCons$Sub_metering_2)
elPowerCons$Sub_metering_3 <- as.numeric(elPowerCons$Sub_metering_3)

# draw the environment without lines first
plot(Sub_metering_1 ~ DT, data=elPowerCons, type="n", xlab = "", ylab = "Energy sub metering")

# then add the lines 
lines(Sub_metering_1 ~ DT, data=elPowerCons, type="l", lty=1, col="Black")
lines(Sub_metering_2 ~ DT, data=elPowerCons, type="l", lty=1, col="Red")
lines(Sub_metering_3 ~ DT, data=elPowerCons, type="l", lty=1, col="Blue")

# TODO add the legend to upper right corner
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("Black","Red","Blue"), lty=c(1,1,1))

# after drawing, copy and save to a png file
#dev.copy(png,'plot3.png')
#dev.off()

# Problem with the dev.copy above is that the png file looks different than the plot in Rstudio.
# trying other appoach to get the correct result (same as in Rstudio)
png('plot3.png')
plot(Sub_metering_1 ~ DT, data=elPowerCons, type="n", xlab = "", ylab = "Energy sub metering")
lines(Sub_metering_1 ~ DT, data=elPowerCons, type="l", lty=1, col="Black")
lines(Sub_metering_2 ~ DT, data=elPowerCons, type="l", lty=1, col="Red")
lines(Sub_metering_3 ~ DT, data=elPowerCons, type="l", lty=1, col="Blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("Black","Red","Blue"), lty=c(1,1,1))
dev.off()

# RESET LOCALE SETTING back to "Belgian" style
Sys.setlocale("LC_TIME", "nl_BE.UTF-8")