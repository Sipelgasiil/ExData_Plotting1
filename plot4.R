#-1 Downloading and extracting the UC Irvine Machine Learning Repository dataset of "Individual
# household electric power consumption" from course web site into working directory

##-1 Please omit parts 1A-1D of this R-script if the dataset has already been downloaded and 
## extracted into the working directory

###-1A url of the dataset is stored under a variable name 'fileUrl'
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
###-1B dataset is downloaded into working directory using a file name 
### 'household_power_consumption.zip'
download.file(fileUrl, destfile = "household_power_consumption.zip")
###-1C name of the unzipped file is stored under a variable name 'unzipFileName'
unzipFileName <- "household_power_consumption.zip"
###-1D downloaded file is extracted into working directory
unzip(unzipFileName)


#-2 Loading the dataset into R

##-2A the name of the extracted file is stored under a variable name 'fileName'
fileName <- "household_power_consumption.txt"
##-2B first 100,000 rows of the extracted file are read into R in a table format
## using ';' as a separator and '?' as a character for interpreting missing values
dataset <- read.table(fileName, header = TRUE, sep = ";", nrows = 100000, na.strings = "?")


#-3 Formatting and extracting data required for the analysis

##-3A converting the objects in the first column (Date) and the second column (Time)
## of the dataset into a DateTime class 'POSIXlt' in a new single column called 'DateTime' 
## using a format 'day as decimal number (%d)'/'month as decimal number (%m)'/
## 'year with century (%Y)' 'hours as decimal number (%H)':'minutes as decimal number (%M)':
## 'seconds as integer (%S)'
dataset$DateTime <- strptime(paste(dataset$Date, dataset$Time), format = "%d/%m/%Y %H:%M:%S")
##-3B Subsetting a dataset under a variable name 'SubData'. This new dataset will only contain 
## measurements taken on 2007-02-01 and 2007-02-02. Original 'Date' and 'Time' columns will be 
## omitted. 
SubData <- dataset[(as.Date(dataset$DateTime, format = "%Y-%m-%d %H:%M:%S") == "2007-02-01" |
                        as.Date(dataset$DateTime, format = "%Y-%m-%d %H:%M:%S") == "2007-02-02"), 3:10]
## as.Date() function was used to temporarily convert 'DateTime' column into a class Date
## so that subsetting could be executed using a date format '%Y-%m-%d'


#-4 Reconstructing plot 4 using base plotting system

##-4A opening a PNG device and creating a file 'plot4.png' with a width of 480 pixels and
## height of 480 pixels
png(file = "plot4.png", height = 480, width = 480)
##-4B specifying the number of plots per row and column, and plots will be filled in a
## column-wise order
par(mfcol = c(2, 2))
##-4C Reconstructing the plot 4 which consists of 4 individual plots 
with(SubData, {
    plot(DateTime, Global_active_power, ylab = "Global Active Power", 
         type = "l", xlab = "") # creating a black line graph of household's global 
    # minute-averaged active power consumption over a two-day period from 2007-02-01 
    # to 2007-02-02 (plot 1, top left)
    plot(DateTime, Sub_metering_1, ylab = "Energy sub metering", 
         type = "l", xlab = "") # creating a black line graph of household's active energy 
    # consumption of sub-metering No. 1 over a two-day period from 2007-02-01 to 2007-02-02 
    # (plot 2, bottom left)
    lines(DateTime, Sub_metering_2, col = "red") # Adding a red line onto plot 2 corresponding 
    # to the household's active energy consumption of sub-metering No. 2 over the same period
    # of time
    lines(DateTime, Sub_metering_3, col = "blue") # Adding a blue line onto plot 2 corresponding 
    # to the household's active energy consumption of sub-metering No. 3 over the same period
    # of time
    legend("topright", pch = "-", col = c("black", "red", "blue"), bty = "n",
           legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
    # Adding a borderless legend to the top right corner of plot 2
    plot(DateTime, Voltage, ylab = "Voltage", type = "l", xlab = "datetime")
    # creating a black line graph of household's minute-averaged voltage consumption
    # over a two-day period from 2007-02-01 to 2007-02-02 (plot 3, top right)
    plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime")
    # creating a black line graph of household's global minute-averaged reactive power 
    # consumption over a two-day period from 2007-02-01 to 2007-02-02 (plot 4, bottom right)
})
##-4D closing the PNG file
dev.off()
