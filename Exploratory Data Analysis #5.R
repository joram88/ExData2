library(tidyverse)
library(downloader)

#Download the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(url, dest="exdata_data_NEI_data-1.zip", mode="wb")
unzip("exdata_data_NEI_data-1.zip")

#Extract th e d ata
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

#Look for codes that contain vehicles
vehcodes <- filter(SCC, grepl("Vehicle", SCC.Level.Two))

#Specifically get Baltimore data
vehicles <- NEI %>% 
        filter(fips == "24510") %>% 
        subset(SCC %in% vehcodes$SCC)

#Get the totals by year
vehtot <- vehicles %>%
        group_by(year) %>% 
        summarize(totals=sum(Emissions))

png("EDA graph #5.png", width = 400, height = 400)

barplot(vehtot$totals,  
        names.arg = c(vehtot$year),
        col = "brown",
        xlab = "Year",
        ylab = "Emissions",
        main = "PM25 Vehicle Emissions in Baltimore")

dev.off()
#We can see from the graph that vehicle emissions in Baltimore
#Have been decreasing consistently