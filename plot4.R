# plot4.R - generate plot4.png

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

# convert needed columns to numeric type
elPowerCons$Global_active_power <- as.numeric(elPowerCons$Global_active_power)
elPowerCons$Global_reactive_power <- as.numeric(elPowerCons$Global_reactive_power)
elPowerCons$Voltage <- as.numeric(elPowerCons$Voltage)
elPowerCons$Sub_metering_1 <- as.numeric(elPowerCons$Sub_metering_1)
elPowerCons$Sub_metering_2 <- as.numeric(elPowerCons$Sub_metering_2)
elPowerCons$Sub_metering_3 <- as.numeric(elPowerCons$Sub_metering_3)

# SET plot canvast to 2 by 2 items ! 
par(mfrow = c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

# sub plot 1 (upper left)
plot(Global_active_power ~ DT, data=elPowerCons, type="l", xlab = "", ylab = "Global Active Power")

# sub plot 2 (upper right)
plot(Voltage ~ DT, data=elPowerCons, type="l", xlab = "datetime", ylab = "Voltage")

# sub plot 3 (lower left)
plot(Sub_metering_1 ~ DT, data=elPowerCons, type="n", xlab = "", ylab = "Energy sub metering") 
lines(Sub_metering_1 ~ DT, data=elPowerCons, type="l", lty=1, col="Black")
lines(Sub_metering_2 ~ DT, data=elPowerCons, type="l", lty=1, col="Red")
lines(Sub_metering_3 ~ DT, data=elPowerCons, type="l", lty=1, col="Blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("Black","Red","Blue"), lty=c(1,1,1), cex=0.5, box.lwd = 0) # small legend font size (cex) and no legend box (box.lwd)

# sub plot 4 (lower right)
plot(Global_reactive_power ~ DT, data=elPowerCons, type="l", xlab = "datetime", yaxt="n") # don't draw y axis text yet (yaxt) 
axis(2,cex.axis=0.8) # draw a smaller y axis text to match the image example (0.8) 

# after drawing, copy and save to a png file
dev.copy(png,'plot4.png')
dev.off()

# RESET LOCALE SETTING back to "Belgian" style
Sys.setlocale("LC_TIME", "nl_BE.UTF-8")

# RESET plot canvast back to 1 by 1 items !
par(mfrow = c(1,1))