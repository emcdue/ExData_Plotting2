library(dplyr)

## Read the PM2.5 Emissions Data and Source Classification Code Table
## (assuming each of those files is in your current working directory)
NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

## Select data for Baltimore City and Los Angeles
baltimore <- subset(NEI, fips == '24510')
losangeles <- subset(NEI, fips == '06037')

## Get the SCC index for vehicle sources
index <- grep('vehicle', SCC$EI.Sector, ignore.case =TRUE)

# Subset the data set
SCC.sub <- SCC[index,]
baltimore.sub <- subset(baltimore, SCC %in% SCC.sub$SCC)
losangeles.sub <- subset(losangeles, SCC %in% SCC.sub$SCC)

## Calculate total emissions by year from vehicles
total.emissions.vehicle.baltimore <- with(baltimore.sub, 
                                          aggregate(Emissions, by = list(year), FUN = sum,
                                          na.rm = TRUE))
colnames(total.emissions.vehicle.baltimore) <- c('Year', 'Emissions')

total.emissions.vehicle.losangeles <- with(losangeles.sub, 
                                           aggregate(Emissions, by = list(year), FUN = sum,
                                           na.rm = TRUE))
colnames(total.emissions.vehicle.losangeles) <- c('Year', 'Emissions')


## Scale Y axis
yMin <- (min(total.emissions.vehicle.baltimore$Emissions,
             total.emissions.vehicle.losangeles$Emissions)) * 0.75
yMax <- (max(total.emissions.vehicle.baltimore$Emissions,
             total.emissions.vehicle.losangeles$Emissions)) * 1.25

## Make the plot
png('plot6.png', width=600, height=600)
plot(total.emissions.vehicle.baltimore, type = 'b',
     main = 'PM2.5 Total Yearly Emissions from Motor Vehicles \n Baltimore City vs Los Angeles',
     xlab = 'Year', ylab = 'Total Emissions PM2.5 (in tons)',
     col = 'blue', lwd = 3, 
     xlim = c(1998,2009), ylim = c(0, yMax))
lines(total.emissions.vehicle.losangeles, type = 'b',
      col = 'red', lwd = 3)
legend("topleft", legend = c('Baltimore City','Los Angeles'), 
       lwd = 3, col = c('blue', 'red'), bty = 'n', y.intersp = 0.5)
dev.off()