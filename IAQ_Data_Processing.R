# This code will clean files individually first and make them uniform.


library(data.table)
library(dplyr)
library(zoo)
library(timetk)
library(lubridate)
library(tidyr)
library(MALDIquant)
library(readr)
library(tidyverse)


Name_List_of_Homes <- list("351_1", "341_2", "341_3", "341_4",
                           "341_5", "341_6", "341_7", "341_8")


SETWD_LIST <- list("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_1",
                   "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_2",
                   "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_3",
                   "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_4",
                   "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_5",
                   "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_6",
                   "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_7",
                   "C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/HOME_341_8")


# Looping through all the home IAQ folders.

for (kera in seq(1,8,1))
  
{
  
  # Set the folder whose files needs to be iterated.
  
  setwd(SETWD_LIST[[kera]])
  
  
  fullpath = getwd()
  directoryname = basename(fullpath)
  
  # This will list all the files in a folder as a 'list' type.
  
  dataset <- list.files(path=fullpath, full.names = TRUE) %>%
    lapply(read_csv)
  
  
  # There are lot of for loops inside the major loop. This is necessary to avoid the error of post processing.
  # All the files in the folder are not responding to the manipulation at the beginning of the processing.
  
  # This needs to be sort out first to make it work.
  
  
  
  for (i in seq(1,length(dataset),1)){
    
    if (any(colnames(dataset[[i]]) == "Light")){
      
      dataset[[i]]$Illumination <- dataset[[i]]$Light
      dataset[[i]]$Light <- NULL
    }
    
    
    if (all(colnames(dataset[[i]]) != "TVOC")){
      
      dataset[[i]]$TVOC <- NA
    }
    
    
    names(dataset[[i]])[1] <- 'Timestamp'
    
    dataset[[i]]$Timestamp <- as.character(dataset[[i]]$Timestamp)
    
    # Fix EDT and EST in strings.
    
    dataset[[i]]$Timestamp <- gsub(c('EDT'), '', dataset[[i]]$Timestamp)
    dataset[[i]]$Timestamp <- gsub(c('EST'), '', dataset[[i]]$Timestamp)
    dataset[[i]]$Timestamp <- parse_date_time(dataset[[i]]$Timestamp, "%m %d, %Y, %H:%M:%S %p ")
    dataset[[i]]$Timestamp <- gsub(c('UTC'), '', dataset[[i]]$Timestamp)
    dataset[[i]]$Timestamp <- as.POSIXct(dataset[[i]]$Timestamp, format = "%Y-%m-%d %H:%M")   
    dataset[[i]] <- dataset[[i]][order(as.POSIXct(dataset[[i]]$Timestamp)),]
    
    dataset[[i]]$Signal <- NULL
    dataset[[i]]$Motion <- NULL
    
    
    dataset[[i]]$CO2 <- gsub("ppm","",as.character(dataset[[i]]$CO2))
    dataset[[i]]$CO2 <- gsub("ppm"," ",as.character(dataset[[i]]$CO2))
    dataset[[i]]$CO2 <- gsub("PPM","",as.character(dataset[[i]]$CO2))
    dataset[[i]]$CO2 <- gsub("PPM"," ",as.character(dataset[[i]]$CO2))
    dataset[[i]]$CO2 <- gsub(" ppm","",as.character(dataset[[i]]$CO2))
    dataset[[i]]$CO2 <- gsub(" ppm"," ",as.character(dataset[[i]]$CO2))
    dataset[[i]]$CO2 <- gsub(" PPM","",as.character(dataset[[i]]$CO2))
    dataset[[i]]$CO2 <- gsub(" PPM"," ",as.character(dataset[[i]]$CO2))
    
    dataset[[i]]$TVOC <- gsub("ppb","",as.character(dataset[[i]]$TVOC))
    dataset[[i]]$TVOC <- gsub("ppb"," ",as.character(dataset[[i]]$TVOC))
    dataset[[i]]$TVOC <- gsub("PPB","",as.character(dataset[[i]]$TVOC))
    dataset[[i]]$TVOC <- gsub("PPB"," ",as.character(dataset[[i]]$TVOC))
    dataset[[i]]$TVOC <- gsub(" ppb","",as.character(dataset[[i]]$TVOC))
    dataset[[i]]$TVOC <- gsub(" ppb"," ",as.character(dataset[[i]]$TVOC))
    dataset[[i]]$TVOC <- gsub(" PPB","",as.character(dataset[[i]]$TVOC))
    dataset[[i]]$TVOC <- gsub(" PPB"," ",as.character(dataset[[i]]$TVOC))
    
    dataset[[i]]$Temperature <- gsub(c('�F'), '', dataset[[i]]$Temperature)
    dataset[[i]]$Temperature <- gsub(c('�C'), '', dataset[[i]]$Temperature)
    dataset[[i]]$Temperature <- gsub(c('�F'), ' ', dataset[[i]]$Temperature)
    dataset[[i]]$Temperature <- gsub(c('�C'), ' ', dataset[[i]]$Temperature)
    
    dataset[[i]]$Humidity <- gsub("[\\%,]", '', dataset[[i]]$Humidity)
    dataset[[i]]$Humidity <- gsub("[\\%,]", ' ', dataset[[i]]$Humidity)
    
    dataset[[i]]$Illumination <- gsub('Lux', '', dataset[[i]]$Illumination)
    dataset[[i]]$Illumination <- gsub('Lux', ' ', dataset[[i]]$Illumination)
    dataset[[i]]$Illumination <- gsub('lux', '', dataset[[i]]$Illumination)
    dataset[[i]]$Illumination <- gsub('lux', ' ', dataset[[i]]$Illumination)
    dataset[[i]]$Illumination <- gsub('LUX', '', dataset[[i]]$Illumination)
    dataset[[i]]$Illumination <- gsub('LUX', ' ', dataset[[i]]$Illumination)
    
  }
  
  # Beginning of the second for loop.
  
  
  for (i in seq(1,length(dataset),1))
    
  {  
    
    dataset[[i]] <- dataset[[i]][c("Timestamp", "CO2", "TVOC", "Temperature", "Humidity", "Illumination")]
    
    colnames(dataset[[i]]) <- c('Timestamp', 'Indoor_CO2_PPM', 'Indoor_TVOC_PPB', 
                                'Indoor_Temperature_C', 'Indoor_RH_Percent', 'Illumination_LUX')
  }
  
  
  for (i in seq(1,length(dataset),1))
    
  {
    
    dataset[[i]]$Indoor_CO2_PPM <- as.numeric(dataset[[i]]$Indoor_CO2_PPM)
    dataset[[i]]$Indoor_TVOC_PPB <- as.numeric(dataset[[i]]$Indoor_TVOC_PPB)
    dataset[[i]]$Indoor_Temperature_C <- as.numeric(dataset[[i]]$Indoor_Temperature_C)
    dataset[[i]]$Indoor_RH_Percent <- as.numeric(dataset[[i]]$Indoor_RH_Percent)
    dataset[[i]]$Illumination_LUX <- as.numeric(dataset[[i]]$Illumination_LUX)
    
    dataset[[i]] <- distinct(dataset[[i]], Timestamp, .keep_all= TRUE)
    
    dataset[[i]]$Timestamp <- as.POSIXct(dataset[[i]]$Timestamp, format = "%Y-%m-%d %H:%M") 
    
    
  }
  
  # Setting the Temperature if range is beyond normal Celsius Scale Range. At very few instances,
  # for some months the csv files records degrees F instead of degrees C. This code will change that. 
  
  
  for (i in seq(1,length(dataset),1))
    
  {
    
    if (mean(dataset[[i]]$Indoor_Temperature_C[!is.na(dataset[[i]]$Indoor_Temperature_C)]) > 50)
      
    {
      
      dataset[[i]]$Indoor_Temperature_C <- (dataset[[i]]$Indoor_Temperature_C-32)/1.80
      
    } else {
      
      dataset[[i]]$Indoor_Temperature_C <- dataset[[i]]$Indoor_Temperature_C
      
    }
    
  }
  
  # This code will not combine all the files in the list and the processing will start as the earlier
  # version of the code.
  
  
  dataset <- bind_rows(dataset)
  
  dataset <- dataset[order(as.POSIXct(dataset$Timestamp)),]
  
  dataset <- dataset[20:nrow(dataset),]
  
  start_index_elevated_temp <- which.max(dataset$Indoor_Temperature_C)
  
  dataset$Indoor_Temperature_C[(which.max(dataset$Indoor_Temperature_C)-50):(which.max(dataset$Indoor_Temperature_C)+20)] <- 
    min(dataset$Indoor_Temperature_C[(which.max(dataset$Indoor_Temperature_C)-50):(which.max(dataset$Indoor_Temperature_C)+20)])
  
  plot(dataset$Timestamp, dataset$Indoor_Temperature_C, type ='l')
  plot(dataset$Timestamp, dataset$Indoor_CO2_PPM, type ='l')
  plot(dataset$Timestamp, dataset$Indoor_TVOC_PPB, type ='l')
  plot(dataset$Timestamp, dataset$Indoor_RH_Percent, type ='l')
  plot(dataset$Timestamp, dataset$Illumination_LUX, type ='l')
  
  
  
  
  # dataset[dataset$Timestamp > "2021-09-29 10:13" & dataset$Timestamp < "2021-09-29 19:00",]$Indoor_Temperature_C <- 
  #   ((dataset[dataset$Timestamp > "2021-09-29 10:13" & dataset$Timestamp < "2021-09-29 19:00",]$Indoor_Temperature_C)-32)/1.8
  # 
  
  ts <- seq.POSIXt(min(dataset$Timestamp), max(dataset$Timestamp), by="min")
  
  ts <- format.POSIXct(ts,'%m/%d/%Y %H:%M:%S')
  
  df <- data.frame(Timestamp=ts)
  
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%m/%d/%Y %H:%M")
  
  data_with_missing_times <- full_join(df, dataset)
  
  dataset <- data_with_missing_times
  
  rm(data_with_missing_times,df,ts)
  
  
  dataset$Indoor_CO2_PPM <- na.approx(dataset$Indoor_CO2_PPM)  # Excellent Function.... Works very well..
  dataset$Indoor_TVOC_PPB <- na.approx(dataset$Indoor_TVOC_PPB)
  dataset$Indoor_Temperature_C <- na.approx(dataset$Indoor_Temperature_C)
  dataset$Indoor_RH_Percent <- na.approx(dataset$Indoor_RH_Percent)
  dataset$Illumination_LUX <- na.approx(dataset$Illumination_LUX)
  
  dataset <- distinct(dataset, Timestamp, .keep_all= TRUE)
  
  
  # Setting up correct baseline for the CO2 plot using MALQIQUANT Package.
  # The baseline of CO2 concentration during the year 2021 needs to be configured.
  
  # dataset$Timestamp <- strptime(dataset$Timestamp, "%Y-%m-%d %H:%M:%S",tz="America/New_York")
  # 
  # Start_Index_Spring_Break <- match(as.POSIXct("2022-05-17 01:00:00"), as.POSIXct(dataset$Timestamp))
  # 
  # End_Index_Spring_Break <- match(as.POSIXct("2022-05-21 01:00:00"), as.POSIXct(dataset$Timestamp))
  # 
  # smooth_data <- dataset$Indoor_CO2_PPM[Start_Index_Spring_Break:End_Index_Spring_Break]
  # 
  # s <- createMassSpectrum(mass = 1:length(smooth_data), intensity = smooth_data)
  # 
  # spectra <- smoothIntensity(s, method = "SavitzkyGolay", halfWindowSize = 5)
  # 
  # baseline <- estimateBaseline(spectra, method = "SNIP", iterations = 100)
  # 
  # baseline <- baseline[,2]
  # 
  # mean(baseline)
  # 
  # Outdoor_baseline <- 418
  # 
  # Outdoor_Baseline_Difference <- Outdoor_baseline - mean(baseline)
  
  ## The mean baseline thus found by the algorithm is about 325.40 PPM. Outdoor Baseline for the CO2
  ## concentration at present date is about 408 PPM
  
  # to fix this, the baseline should be shifted by the difference between outdoor CO2 PPM and the indoor
  # baseline found by the algorithm
  # 
  # dataset$Indoor_CO2_PPM_Correct_BL <- dataset$Indoor_CO2_PPM + Outdoor_Baseline_Difference
  # 
  # dataset$Indoor_CO2_PPM_Correct_BL <- as.numeric(dataset$Indoor_CO2_PPM_Correct_BL)
  # 
  # 
  # plot(dataset$Indoor_CO2_PPM, type ='l', col ='blue', xlab = c(paste('Time Elapsed in Minutes')),
  #      ylab = 'Indoor_CO2_PPM')
  # 
  # lines(dataset$Indoor_CO2_PPM_Correct_BL, col= 'red')
  # 
  # 
  # dataset$Indoor_CO2_PPM <- dataset$Indoor_CO2_PPM_Correct_BL
  # 
  # dataset$Indoor_CO2_PPM_Correct_BL <- NULL
  
  
  # Very important step is to change the destination of the folder where the file needs to be saved.
  # This will avoid duplicated files to be processed in the near future.
  
  
  setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/IAQ/Processed")
  
  getwd()
  FileOut <- paste(c('POST_RETROFIT_IAQ_DATA_AUGUST_2022_TO_DEC_2022_',Name_List_of_Homes[[kera]],'.csv'), collapse='')
  getwd()
  write.table(dataset, file=FileOut, quote=F, append=F, sep=',', row.names=F, col.names=T)
  
  
}

