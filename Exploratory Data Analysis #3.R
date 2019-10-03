library(tidyverse)
library(downloader)

#Download the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(url, dest="exdata_data_NEI_data-1.zip", mode="wb")
unzip("exdata_data_NEI_data-1.zip")

#Extract the data
NEI <- readRDS("summarySCC_PM25.rds") 

#Find Baltimore Data and aggregate all totals by type
type <- NEI %>%
        filter(fips == "24510") %>% 
        group_by(type, year) %>% 
        summarize(totals=sum(Emissions))

#Graph it
png("EDA graph #3.png", width = 1000, height = 400)

qplot(year, totals, data = type, 
      facets = .~type, 
      geom=c("point", "line"), 
      xlab = "Year", 
      ylab = "Emissions", 
      main = "Total Emissions by Type in Baltimore")

dev.off()