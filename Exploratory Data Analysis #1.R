library(tidyverse)
library(downloader)

#Download the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(url, dest="exdata_data_NEI_data-1.zip", mode="wb")
unzip("exdata_data_NEI_data-1.zip")

#Extract the data
NEI <- readRDS("summarySCC_PM25.rds") 

#Aggregate by year total emissions for the country
usa <- NEI %>%
        group_by(year) %>% 
        summarize(totals=sum(Emissions))

#Graph it
png("EDA graph #1.png", width = 400, height = 400)

barplot(usa$totals,  
        names.arg = c(usa$year),
        col = "darkblue",
        xlab = "Year",
        ylab = "Emissions",
        main = "PM25 Emissions for the US"
)

dev.off()