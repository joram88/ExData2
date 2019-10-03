library(tidyverse)
library(downloader)

#Download the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(url, dest="exdata_data_NEI_data-1.zip", mode="wb")
unzip("exdata_data_NEI_data-1.zip")

#Extract the data

NEI <- readRDS("summarySCC_PM25.rds") 
SCC <- readRDS("Source_Classification_Code.rds")

#I look for the SCC codes that include vehicles
vehcodes <- filter(SCC, grepl("Vehicle", SCC.Level.Two))

#Get the FIPS codes for both cities
baltveh <- NEI %>% 
        filter(fips == "24510") %>% 
        subset(SCC %in% vehcodes$SCC)
        baltveh$name = "Baltimore"

LAveh <- NEI %>% 
        filter(fips == "06037") %>% 
        subset(SCC %in% vehcodes$SCC)
LAveh$name = "Los Angeles"

both <- rbind(baltveh, LAveh)

#Get the totals and then determine their yearly pct change
bothtot <- both %>%
        group_by(name, year) %>% 
        summarize(totals=sum(Emissions))

pct_chg <- bothtot %>% 
        group_by(name) %>% 
        mutate(pct_change = ((totals-lag(totals))/lag(totals))) %>% 
        na.omit(pct_change)

#I was getting decimal points on x axis for some reason
#so I added this line of code

scaleFUN <- function(x) sprintf("%.0f", x)

png("EDA graph #6.png", width = 400, height = 400)

#Graph it
par(mfrow=c(1,2))
ggplot(data = pct_chg)+
        geom_col(mapping = aes(year, pct_change))+
        facet_wrap(.~name)+labs(x = "Year", y = "Percent Change",
                               title = "Percent Change in Vehicle Emissions Comparison")+
        scale_x_continuous(labels=scaleFUN)
dev.off()

#As we can see, Baltimore has seen a more significant drop
#in emissions as a percentage of total, while LA had increases
#in 2002 and 2005 before dropping a bit