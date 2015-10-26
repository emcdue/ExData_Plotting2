library(dplyr)

## Read the PM2.5 Emissions Data and Source Classification Code Table
## (assuming each of those files is in your current working directory)
NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

## Select data for Baltimore City
baltimore <- subset(NEI, fips == '24510')

## Get the SCC index for vehicle sources
index <- grep('vehicle', SCC$EI.Sector, ignore.case =TRUE)

# Subset the data set
SCC.sub <- SCC[index,]
baltimore.sub <- subset(baltimore, SCC %in% SCC.sub$SCC)

## Calculate total emissions by year from vehicles
total.emissions.vehicle <- with(baltimore.sub, 
                                aggregate(Emissions, by = list(year), FUN = sum,
                                          na.rm = TRUE))
colnames(total.emissions.vehicle) <- c('Year', 'Emissions')

## Scale Y axis
yMin <- min(total.emissions.vehicle$Emissions) * 0.75
yMax <- max(total.emissions.vehicle$Emissions) * 1.25

## Make the plot
png('plot5.png', width=600, height=600)
plot(total.emissions.vehicle, type = 'b',
     main = 'PM2.5 Total Yearly Emissions from Motor Vehicles in Baltimore City',
     xlab = 'Year', ylab = 'Total Emissions PM2.5 (in tons)',
     col = 'blue', lwd = 3, 
     xlim = c(1998,2009), ylim = c(0, yMax))
dev.off()