library(dplyr)

## Read the PM2.5 Emissions Data and Source Classification Code Table
## (assuming each of those files is in your current working directory)
NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

## Select data for Baltimore City
baltimore <- subset(NEI, fips == '24510')

## Calculate total emissions by year
total.emissions <- with(baltimore, 
                        aggregate(Emissions, by = list(year), FUN = sum,
                        na.rm = TRUE))
colnames(total.emissions) <- c('Year', 'Emissions')

## Scale Y axis
yMin <- min(total.emissions$Emissions) * 0.75
yMax <- max(total.emissions$Emissions) * 1.25

## Make the plot
png('plot2.png', width=600, height=600)
plot(total.emissions, type = 'b',
     main = 'PM2.5 Total Yearly Emissions in Baltimore City',
     xlab = 'Year', ylab = 'Total Emissions PM2.5 (in tons)',
     col = 'blue', lwd = 3, 
     xlim = c(1998,2009), ylim = c(yMin, yMax))
dev.off()