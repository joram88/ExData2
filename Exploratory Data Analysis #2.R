library(tidyverse)
library(downloader)

#Download the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(url, dest="exdata_data_NEI_data-1.zip", mode="wb")
unzip("exdata_data_NEI_data-1.zip")

#Extract the data
NEI <- readRDS("summarySCC_PM25.rds") 

#Find Baltimore data and then aggregate it
balt <- NEI %>%
        filter(fips == "24510") %>% 
        group_by(year) %>% 
        summarize(totals=sum(Emissions))

#Graph it
png("EDA graph #2.png", width = 400, height = 400)

barplot(balt$totals,  
        names.arg = c(balt$year),
        col = "darkred",
        xlab = "Year",
        ylab = "Emissions",
        main = "PM25 Emissions for Baltimore"
        )

dev.off()
