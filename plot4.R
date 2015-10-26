library(dplyr)

## Read the PM2.5 Emissions Data and Source Classification Code Table
## (assuming each of those files is in your current working directory)
NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS('Source_Classification_Code.rds')

## Get the SCC index for coal combustion-related sources
index <- grep('coal', SCC$EI.Sector, ignore.case =TRUE)

# Subset the data set
SCC.sub <- SCC[index,]
NEI.sub <- subset(NEI, SCC %in% SCC.sub$SCC)

## Calculate total emissions by year
total.emissions.coal <- with(NEI.sub, 
                        aggregate(Emissions, by = list(year), FUN = sum,
                                  na.rm = TRUE))
colnames(total.emissions.coal) <- c('Year', 'Emissions')

## Scale Y axis
yMin <- min(total.emissions.coal$Emissions) * 0.75
yMax <- max(total.emissions.coal$Emissions) * 1.25

## Make the plot
png('plot4.png', width=600, height=600)
plot(total.emissions.coal, type = 'b',
     main = 'PM2.5 Total Yearly Emissions from Coal Combustion Sources in the US',
     xlab = 'Year', ylab = 'Total Emissions PM2.5 (in tons)',
     col = 'blue', lwd = 3, 
     xlim = c(1998,2009), ylim = c(yMin, yMax))
dev.off()