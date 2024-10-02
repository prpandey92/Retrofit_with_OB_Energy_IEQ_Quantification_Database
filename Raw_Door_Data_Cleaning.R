# Libraries Needed...

library(data.table)
library(dplyr)
library(zoo)
library(timetk)
library(lubridate)
library(tidyr)
library(move)
library(R.utils)
library(readr)
library(stringr)
library(fasttime)

# Creating the list of directories. This list will pass to setwd(), which will loop over specified directories.
# The list can also be combined as a master list that can then be iterated, achieving fully autonomous code.

SETWD_LIST_DOOR_1_1 <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_1",
                            "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_2",
                            "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_3",
                            "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_4",
                            "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_5",
                            "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_6",
                            "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_7",
                            "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Door/HOME_341_8")
for (kera in seq(1,8,1))
    
  {
    
    setwd(SETWD_LIST_DOOR_1_1[[kera]])
    
    fullpath = getwd()
    
    directoryname = basename(fullpath)
    
    dataset <- list.files(path=fullpath, full.names = TRUE) %>% 
      lapply(read_csv) %>% 
      bind_rows 
    
    dataset <- as.data.frame(dataset)
    
    dataset <- dataset[1:2]
    
    colnames(dataset) <- c('Timestamp', 'Door_O_C')
    
    dataset$Timestamp <- as.character(dataset$Timestamp)
        
    # Fix EDT and EST in strings.
    
    dataset$Timestamp <- gsub(c('EDT'), '', dataset$Timestamp)
    
    dataset$Timestamp <- gsub(c('EST'), '', dataset$Timestamp)
    
    dataset$Timestamp <- parse_date_time(dataset$Timestamp, "%m %d, %Y, %H:%M:%S %p ")
    
    dataset$Timestamp <- gsub(c('UTC'), '', dataset$Timestamp)
    
    dataset$Timestamp <- as.POSIXct(dataset$Timestamp, format = "%Y-%m-%d %H:%M:%S")   
    
    dataset <- dataset[order(as.POSIXct(dataset$Timestamp)),]
    
    dataset$Door_O_C <- as.character(dataset$Door_O_C)
    
    dataset$Door <- NA
    
    dataset$Door[dataset[,2] == 'Closed'] <- 0
    
    dataset$Door[dataset[,2] == 'Open'] <- 1
    
    dataset$Door_O_C <- NULL
    
    ts <- seq.POSIXt(min(dataset$Timestamp), max(dataset$Timestamp), by= 'sec')
    
    df <- data.frame(Timestamp=ts)
    
    df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")     
    
    data_with_missing_times <- left_join(df, dataset)
    
    dataset <- data_with_missing_times
    
    dataset[,2] <- na.locf(dataset[,2])
    
    dataset$Timestamp_Sec_removed <- format(dataset$Timestamp,format = '%Y-%m-%d %H:%M')
    
    dataset <-  dataset %>% group_by(Timestamp_Sec_removed) %>%
      summarize(Door=  max(Door))
    
    # This step is needed because earlier Dataset table will present the data as a list. This will prevent
    # from doing Further analysis. So it is changed as follows.
    
    # Vectorize all the columns and then merge them into a data frame. I think data.table has some errors,
    # but data.frame can wipe those out.
    
    a <- unlist(dataset[,1], use.names = FALSE)
    
    b <- unlist(dataset[,2], use.names = FALSE)
    
    dataset <- data.frame(Timestamp = a, Door = b)
    
    dataset$Timestamp <- as.POSIXct(dataset$Timestamp, format = '%Y-%m-%d %H:%M')
    
    plot(dataset[,1], dataset[,2], type = 'l')
    
    setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit")
    
    getwd()
    FileOut <- paste(c('Overall_Door_Data_AUG_2022_TO_NOV_2022_', directoryname,'.csv'), collapse='')
    getwd() 
    write.table(dataset, file=FileOut, quote=F, append=F, sep=',', row.names=F, col.names=T)
    
    rm(dataset)
    
  }
