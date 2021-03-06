## Plot 5

## Question: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

## The data is taken from the link provided on the Coursera EDA Project2 site.

## Plot file is plot5.png

## Author : Michael Hunt

## Initial admin (clear work space, set working directory, load packages required)

        rm(list=ls())
        library(dplyr)
        library(ggplot2)

# (amend pathway as appropriate)

        setwd("C:/Users/Mike/Rspace/JHU_EDA/CP2") # home
        #setwd("H:/Rspace/JHU_Data_Science/JHU_EDA/CP2") # work


## Create rds file of NEI data and code files in ./data directory - or skip if already there.

# Create sub-directory of the working dir called "data" if one does not exist already

        if(!file.exists("data")){
                dir.create("data")
        }

# if data subset not already downloaded and in rds file,

# if rds of NEI data already present in ./data, read it into data.frame NEI
# and read code file into data frame SCC

        if(file.exists("./data/summarySCC_PM25.rds")){
                print("data already in ./data directory")
        
                NEI <- readRDS("./data/summarySCC_PM25.rds")
                SCC <- readRDS("./data/Source_Classification_Code.rds")
        } 

# If the files aren't there, we have to download then unzip them.

        if(!file.exists("./data/summarySCC_PM25.rds")){
        
                print("downloading NEI data from site" )
                temp<-tempfile()
                fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
                download.file(fileURL,temp, mode="wb")
                unzip(temp, "summarySCC_PM25.rds")
                file.rename(from="summarySCC_PM25.rds",to="./data/summarySCC_PM25.rds")
                
                ##read data from rds file into data frame NEI
                NEI <- readRDS("./data/summarySCC_PM25.rds")
                
                ## unzip code file too
                unzip(temp,"Source_Classification_Code.rds")
                file.rename(from="Source_Classification_Code.rds",to="./data/Source_Classification_Code.rds")
                
                ##read data from rds file into data frame NEI
                SCC <- readRDS("./data/Source_Classification_Code.rds")       
        }

##

# data are now in date.frame NEI
# source codes are in data.frame SCC

# Look at the data
# str(NEI)

## Process the data as necessary
        
# We will define "motor vehicle" as being whatever is denoted by type "ON-ROAD" in the NEI data.
# this seems reasonable given this explanation of the NEI data by the EPA
# http://www.epa.gov/ttnchie1/net/2011inventory.html
        
# Filter fromNEI the rows where $type is "ON-ROAD" AND where $fips = "24510" ie Baltimore City
             
        mv.data<-NEI[NEI$type=="ON-ROAD" & NEI$fips=="24510",]
        
# Find annual emissions totals for motor vehicles from Baltimore.
        
        mv.totals<-aggregate(mv.data$Emissions,by=list(mv.data$year),FUN="sum")
        names(mv.totals)[names(mv.totals)=="Group.1"] <- "Year"
        names(mv.totals)[names(mv.totals)=="x"] <- "Emissions"

# Convert annual totals to Mt or kt etc, if necessary
        
        #mv.totals$Emissions<-mv.totals$Emissions/1e3 # 1e3 for kt, 1e6 for Mt
        
## Create plot5 in png file

#open png device;create "plot5.png" in working directory
        
        png("plot5.png")
        
#create plot and send to the file

## Setup ggplot with data frame

        g <- ggplot(mv.totals, aes(Year, Emissions))+
                geom_point(size=4)+
                geom_smooth(method="lm", se=FALSE)+ # add linear regression line
                scale_y_continuous(limits = c(0, max(mv.totals$Emissions)))+
                theme(axis.text.x = element_text(size=14),
                      axis.text.y=element_text(size=14))+
                labs(x = "Year",y = "Annual Emissions (t)")+
                theme(axis.title.x = element_text(size=14,vjust=-.5),
                      axis.title.y=element_text(size=14,vjust=1.2))+
                ggtitle("Annual Baltimore emissions from motor vehicle usage")+
                theme(plot.title = element_text(size=14, face="bold", vjust=2, lineheight=.6))
        
                #labs(title = "Annual Baltimore emissions from motor vehicle usage")
        g
# close the png file device
        
        dev.off() 
