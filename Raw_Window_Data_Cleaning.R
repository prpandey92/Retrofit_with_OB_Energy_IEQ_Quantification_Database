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

SETWD_LIST_WIN_1_1_L <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_1/WIN_1_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_2/WIN_1_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_3/WIN_1_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_4/WIN_1_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_5/WIN_1_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_6/WIN_1_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_7/WIN_1_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_8/WIN_1_1_L")

SETWD_LIST_WIN_1_1_R <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_1/WIN_1_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_2/WIN_1_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_3/WIN_1_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_4/WIN_1_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_5/WIN_1_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_6/WIN_1_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_7/WIN_1_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_8/WIN_1_1_R")

SETWD_LIST_WIN_2_1_L <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_1/WIN_2_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_2/WIN_2_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_3/WIN_2_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_4/WIN_2_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_5/WIN_2_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_6/WIN_2_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_7/WIN_2_1_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_8/WIN_2_1_L")

SETWD_LIST_WIN_2_1_R <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_1/WIN_2_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_2/WIN_2_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_3/WIN_2_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_4/WIN_2_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_5/WIN_2_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_6/WIN_2_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_7/WIN_2_1_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_8/WIN_2_1_R")

SETWD_LIST_WIN_2_2_L <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_1/WIN_2_2_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_2/WIN_2_2_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_3/WIN_2_2_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_4/WIN_2_2_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_5/WIN_2_2_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_6/WIN_2_2_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_7/WIN_2_2_L",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_8/WIN_2_2_L")

SETWD_LIST_WIN_2_2_R <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_1/WIN_2_2_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_2/WIN_2_2_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_3/WIN_2_2_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_4/WIN_2_2_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_5/WIN_2_2_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_6/WIN_2_2_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_7/WIN_2_2_R",
                             "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows/HOME_341_8/WIN_2_2_R")

MASTER_LIST <- list(SETWD_LIST_WIN_1_1_L,
                    SETWD_LIST_WIN_1_1_R,
                    SETWD_LIST_WIN_2_1_L,
                    SETWD_LIST_WIN_2_1_R,
                    SETWD_LIST_WIN_2_2_L,
                    SETWD_LIST_WIN_2_2_R)

for (orange in seq(1,6,1)){
   for (kera in seq(1,8,1))
    
  {
    
    setwd(MASTER_LIST[[orange]][[kera]])
    
    fullpath = getwd()
    
    directoryname = basename(fullpath)
    
    dataset <- list.files(path=fullpath, full.names = TRUE) %>% 
      lapply(read_csv) %>% 
      bind_rows 
    
    dataset <- as.data.frame(dataset)
    
    dataset <- dataset[1:2]
    
    colnames(dataset) <- c('Timestamp', 'Window_O_C')
    
    dataset$Timestamp <- as.character(dataset$Timestamp)
    
    # Fix EDT and EST in strings.
    
    dataset$Timestamp <- gsub(c('EDT'), '', dataset$Timestamp)
    
    dataset$Timestamp <- gsub(c('EST'), '', dataset$Timestamp)
    
    dataset$Timestamp <- parse_date_time(dataset$Timestamp, "%m %d, %Y, %H:%M:%S %p ")
    
    dataset$Timestamp <- gsub(c('UTC'), '', dataset$Timestamp)
    
    dataset$Timestamp <- as.POSIXct(dataset$Timestamp, format = "%Y-%m-%d %H:%M:%S")   
    
    dataset <- dataset[order(as.POSIXct(dataset$Timestamp)),]
    
    dataset$Window_O_C <- as.character(dataset$Window_O_C)
    
    dataset[,3] <- NA
    
    dataset[,3][dataset[,2] == 'Closed'] <- 0
    
    dataset[,3][dataset[,2] == 'Open'] <- 1
    
    
    if (substr(directoryname, 8, 11) == '_1_1') {
      
      colnames(dataset) <- c('Timestamp', 'Window_O_C', 'Window')
      
    } else if ((substr(directoryname, 8, 11) == '_2_1')) {
      
      colnames(dataset) <- c('Timestamp', 'Window_O_C', 'Window')
      
    } else {
      
      colnames(dataset) <- c('Timestamp', 'Window_O_C', 'Window')
    }
       
    dataset$Window_O_C <- NULL
    
    ts <- seq.POSIXt(min(dataset$Timestamp), max(dataset$Timestamp), by= 'sec')
    
    df <- data.frame(Timestamp=ts)
    
    df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")     
    
    data_with_missing_times <- left_join(df, dataset)
    
    dataset <- data_with_missing_times
    
    dataset[,2] <- na.locf(dataset[,2])
    
    dataset$Timestamp_Sec_removed <- format(dataset$Timestamp,format = '%Y-%m-%d %H:%M')
    
    dataset <-  dataset %>% group_by(Timestamp_Sec_removed) %>%
      summarize(Window=  max(Window))
        
    # This step is needed because earlier Dataset table will present the data as a list. This will prevent
    # from doing Further analysis. So it is changed as follows.
    
    # Vectorize all the columns and then merge them into a data frame. I think data.table has some errors,
    # but data.frame can wipe those out.
    
    a <- unlist(dataset[,1], use.names = FALSE)
    
    b <- unlist(dataset[,2], use.names = FALSE)
    
    dataset <- data.frame(Timestamp = a, Window = b)
        
    if (substr(directoryname, 5, 11) == '1_1_L') 
      
    {
      
      colnames(dataset) <- c('Timestamp', 'Window_1_1_L')
      
    } else if ((substr(directoryname, 5, 11) == '1_1_R')) {
      
      colnames(dataset) <- c('Timestamp', 'Window_1_1_R')
      
    } else if ((substr(directoryname, 5, 11) == '2_1_L')) {
      
      colnames(dataset) <- c('Timestamp', 'Window_2_1_L')
      
    } else if ((substr(directoryname, 5, 11) == '2_1_R')) {
      
      colnames(dataset) <- c('Timestamp', 'Window_2_1_R')
      
    } else if ((substr(directoryname, 5, 11) == '2_2_L')) {
      
      colnames(dataset) <- c('Timestamp', 'Window_2_2_L')
      
    } else  {
      
      colnames(dataset) <- c('Timestamp', 'Window_2_2_R')
      
    } 
    
    dataset$Timestamp <- as.POSIXct(dataset$Timestamp, format = '%Y-%m-%d %H:%M')
    
    plot(dataset[,1], dataset[,2], type = 'l')
    
    dataset$Home_ID <- substr(MASTER_LIST[[orange]][[kera]], 64, 73)
    
    dataset$Window_ID <- directoryname
    
    HOME_ID_for_file_naming <- substr(MASTER_LIST[[orange]][[kera]], 64, 73)
    
    setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Windows")
    
    getwd()
    FileOut <- paste(c('WINDOW_Data_AUGUST_2022_TO_NOV_2022_', HOME_ID_for_file_naming, '_', directoryname,'.csv'), collapse='')
    getwd() 
    write.table(dataset, file=FileOut, quote=F, append=F, sep=',', row.names=F, col.names=T)
    
    rm(dataset)
    
  }
  
}

