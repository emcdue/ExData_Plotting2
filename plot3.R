library(dplyr)
library(ggplot2)

## Read the PM2.5 Emissions Data and Source Classification Code Table
## (assuming each of those files is in your current working directory)
NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

## Select data for Baltimore City
baltimore <- subset(NEI, fips == '24510')

## Calculate total emissions by year and by type
total.emissions.pertype <- with(baltimore, 
                               aggregate(Emissions, by = list(type, year), FUN = sum,
                               na.rm = TRUE))
colnames(total.emissions.pertype) <- c('Type', 'Year', 'Emissions')


## Make the plot
png('plot3.png', width=600, height=600)
plot <- qplot(data = total.emissions.pertype, x=Year, y=Emissions,
        geom = 'line',
        facets = . ~ Type,
        main = 'PM2.5 Total Yearly Emissions per type in Baltimore City',
        xlab = 'Year', ylab = 'Total Emissions PM2.5 (in tons)')
print(plot)
dev.off()