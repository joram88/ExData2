library(tidyverse)
library(downloader)

#Download the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(url, dest="exdata_data_NEI_data-1.zip", mode="wb")
unzip("exdata_data_NEI_data-1.zip")

#Extract the data
NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

#Look for sectors containing "COAL"
coalcodes <- filter(SCC, grepl("Coal", EI.Sector))

coal <- subset(NEI, SCC %in% coalcodes$SCC)

#Get the totals
coaltot <- coal %>%
        group_by(year) %>% 
        summarize(totals=sum(Emissions))

#Graph it
png("EDA graph #4.png", width = 400, height = 400)
barplot(coaltot$totals,  
        names.arg = c(coaltot$year),
        col = "darkgrey",
        xlab = "Year",
        ylab = "Emissions",
        main = "PM25 Coal Emissions in the US")
dev.off()