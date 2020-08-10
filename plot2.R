################################################################################
##
## Script Name: plot2.R
##
## Data Set:
##     Individual household electric power consumption Data Set
##     <https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption>
##
## Dataset Summary:
##     This archive contains 2,075,259 measurements gathered in a house located
##     in Sceaux (7km of Paris, France) between December 2006 and November 2010
##     (47 months).
##
##     Notes:
##        1.(global_active_power*1000/60 - sub_metering_1 - sub_metering_2 -
##          sub_metering_3) represents the active energy consumed every minute
##          (in watt hour) in the household by electrical equipment not measured
##          in sub-meterings 1, 2 and 3.
##        2.The dataset contains some missing values in the measurements (nearly
##          1,25% of the rows). All calendar timestamps are present in the
##          dataset but for some timestamps, the measurement values are missing:
##          a missing value is represented by the character '?' between two
##          consecutive semi-colon attribute separators. For instance, the
##          dataset shows missing values on April 28, 2007.
##
## Dataset License:
##     This dataset is made available under the “Creative Commons Attribution
##     4.0 International (CC BY 4.0)” license
## 
## Description:
##     This script reads the data from the dates 2007-02-01 and 2007-02-02 from
##     the complete database and creates a line plot of the household global
##     minute-averaged active power (in kilowatt) represented by the column
##     'Global_active_power' vs timestamp represented by the new column
##     'datetime'.
##
##     The overall goal is to examine how household energy usage varies over a
##     2-day period in February, 2007.
##
################################################################################

################################################################################
#
# Load the required libraries
#
################################################################################
library(dplyr)
library(sqldf)

################################################################################
##
## DOWNLOAD the data set from the "Individual household electric power
## consumption Data Set".
##
## This step would download a zip file of size ~ 20 MB and then unzip the
## contents to a folder called "data".
##
## The script is capable of detecting the system type you are running on and
## apply appropriate parameters to download the files.
##
## This step might take some time based on your Internet Speed, so please be
## patient!!
##
################################################################################
if(!file.exists("data")) {
    dir.create("data")
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    if(Sys.info()["sysname"] == "Windows") {
        download.file(fileUrl,
                      destfile = "data/household_power_consumption.zip",
                      mode = "wb")
    } else {
        download.file(fileUrl,
                      destfile = "data/household_power_consumption.zip",
                      method = "curl")
    }
    unzip("data/household_power_consumption.zip", exdir = "data")
}

################################################################################
##
## The complete dataset has 2,075,259 rows and 9 columns. This would require
## ~ 143 Mb in memory, which is a huge memory footprint. For this project, we
## will only be using data from the dates 2007-02-01 and 2007-02-02. So we read
## the data from just those dates rather than reading in the entire dataset and
## subsetting to those dates.
##
################################################################################
power_consumption <-
    read.csv.sql("data/household_power_consumption.txt", sep = ";",
                 sql = "select * from file where Date = '1/2/2007' OR Date = '2/2/2007'",
                 header = TRUE)

################################################################################
##
## It's given that the missing values are coded as "?". Replace them with NAs
##
################################################################################
is.na(power_consumption) <- (power_consumption == "?")

################################################################################
##
## Create a new column 'datetime' to keep a record of the timestamp, combining
## 'Date' and 'Time' strings and converting it to appropriate date/time format.
##
################################################################################
power_consumption <- mutate(power_consumption,
                            datetime = strptime(paste(Date, Time),
                                                format = "%d/%m/%Y %H:%M:%S"))

################################################################################
##
## Open a png graphics device, create "plot2.png" with a width and height of
## 480 pixels each
##
################################################################################
png("plot2.png", width = 480, height = 480, units = "px")

################################################################################
##
## Create a line plot of the household global minute-averaged active power (in
## kilowatt) represented by the column 'Global_active_power' vs timestamp
## represented by the new column 'datetime'.
##
################################################################################
with(power_consumption, plot(datetime, Global_active_power, type = "l",
                             xlab = "",
                             ylab = "Global Active Power (kilowatts)"))

################################################################################
##
## Close the png graphics device
##
################################################################################
dev.off()