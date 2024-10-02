library(dplyr)
library(timetk)
library(lubridate)
library(data.table)
library(zoo)
library(tidyr)
library(MALDIquant)
library(readr)

setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_1")
HOUSE_341_1_data_CUM_SEC <- read.csv("Power_Meter_KW_341_1.csv", header=T)
setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_2")
HOUSE_341_2_data_CUM_SEC <- read.csv("Power_Meter_KW_341_2.csv", header=T)
setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_3")
HOUSE_341_3_data_CUM_SEC <- read.csv("Power_Meter_KW_341_3.csv", header=T)
setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_4")
HOUSE_341_4_data_CUM_SEC <- read.csv("Power_Meter_KW_341_4.csv", header=T)
setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_5")
HOUSE_341_5_data_CUM_SEC <- read.csv("Power_Meter_KW_341_5.csv", header=T)
setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_6")
HOUSE_341_6_data_CUM_SEC <- read.csv("Power_Meter_KW_341_6.csv", header=T)
setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_7")
HOUSE_341_7_data_CUM_SEC <- read.csv("Power_Meter_KW_341_7.csv", header=T)
setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter/HOME_341_8")
HOUSE_341_8_data_CUM_SEC <- read.csv("Power_Meter_KW_341_8.csv", header=T)

setwd("C:/Users/prati/Documents/Raw_Data_Files_After_Retrofit/Power_Meter")

List_of_Homes <- list(HOUSE_341_1_data_CUM_SEC, HOUSE_341_2_data_CUM_SEC, HOUSE_341_3_data_CUM_SEC,
                      HOUSE_341_4_data_CUM_SEC, HOUSE_341_5_data_CUM_SEC, HOUSE_341_6_data_CUM_SEC,
                      HOUSE_341_7_data_CUM_SEC, HOUSE_341_8_data_CUM_SEC)

List_of_Home_names <- list("341_1", "341_2", "341_3", "341_4",
                           "341_5", "341_6", "341_7", "341_8")

### HOME 341_8 has different format for date... Fix this file in future for automation.


for (kera in seq(1,8,1)){
  
  colnames(List_of_Homes[[kera]])[1] <- "Timestamp"
  
  List_of_Homes[[kera]]$Timestamp <- as.POSIXct(List_of_Homes[[kera]]$Timestamp, format = "%m/%d/%Y %H:%M")
  
  List_of_Homes[[kera]]<- 
    List_of_Homes[[kera]][order(as.POSIXct(List_of_Homes[[kera]]$Timestamp, format="%Y-%m-%d %H:%M")),]
  
  List_of_Homes[[kera]] <-  List_of_Homes[[kera]][5:nrow(List_of_Homes[[kera]]),]
  
  List_of_Homes[[kera]][2:ncol(List_of_Homes[[kera]])] <- 
    abs(List_of_Homes[[kera]][2:ncol(List_of_Homes[[kera]])])
  
  ## one fix here... use %in% to find out
  
  List_of_Homes[[kera]] <- List_of_Homes[[kera]][c("Timestamp", "Stove.Receptacle..kW.", "Refrigerator..kW.", 
                                                   "Counter.GFCI.Receptacles..kW.","Exhaust.Hood.Liv.Rm.Plug..kW.","Bathroom.Heat.GFCI..kW.",          
                                                   "Bedroom1.D.Duplex.Recpt..kW.", "Bedroom2.D.Duplex.Recpt..kW.", "Lighting.Circuit..kW.", "Bathroom.Circuit..kW.",            
                                                   "Water.Heater..kW.", "Bedroom1.and.Bedroom2.Heat..kW.", "First.Floor.Heat.Pump..kW.", "HRVs..kW.")]
  
  
  colnames(List_of_Homes[[kera]]) <- c("Timestamp", "Stove_Receptacle_KW", "Refrigerator_KW", 
                                       "Counter_GFCI_Receptacles_KW","Exhaust_Hood_Liv_Rm_Plug_KW", 
                                       "Bathroom_Heat_GFCI_KW", "Bedroom_1_D_Duplex_Recpt_KW",         
                                       "Bedroom_2_D_Duplex_Recpt_KW", "Lighting_Circuit_KW", 
                                       "Bathroom_Circuit_KW", "Water_Heater_KW", "Bedroom_1_and_2_Heat_KW",
                                       "First_Floor_Heat_Pump_KW", "HRV_KW")
                                       
  
  List_of_Homes[[kera]]$Timestamp <- as.POSIXct(List_of_Homes[[kera]]$Timestamp, format = "%Y-%m-%d %H:%M") 
  
  ts <- seq.POSIXt(min(List_of_Homes[[kera]]$Timestamp), max(List_of_Homes[[kera]]$Timestamp), by="min")
  
  ts <- format.POSIXct(ts,'%Y-%m-%d %H:%M')
  
  df <- data.frame(Timestamp=ts)
  
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M")
  
  data_with_missing_times <- full_join(df, List_of_Homes[[kera]])
  
  List_of_Homes[[kera]] <- data_with_missing_times
  
  
  for (i in seq(1,ncol(List_of_Homes[[kera]]),1))
    
  {
    
    List_of_Homes[[kera]][,i] <- na.locf(List_of_Homes[[kera]][,i])
    
  }
  
  
  List_of_Homes[[kera]]$Stove_Receptacle_KWh <- NA
  List_of_Homes[[kera]]$Refrigerator_KWh <- NA
  List_of_Homes[[kera]]$Counter_GFCI_Receptacles_KWh <- NA
  List_of_Homes[[kera]]$Exhaust_Hood_Liv_Rm_Plug_KWh <- NA
  List_of_Homes[[kera]]$Bathroom_Heat_GFCI_KWh <- NA
  List_of_Homes[[kera]]$Bedroom_1_D_Duplex_Recpt_KWh <- NA
  List_of_Homes[[kera]]$Bedroom_2_D_Duplex_Recpt_KWh <- NA
  List_of_Homes[[kera]]$Lighting_Circuit_KWh <- NA
  List_of_Homes[[kera]]$Bathroom_Circuit_KWh <- NA
  List_of_Homes[[kera]]$Water_Heater_KWh <- NA
  List_of_Homes[[kera]]$Bedroom_1_and_2_Heat_KWh <- NA
  List_of_Homes[[kera]]$First_Floor_Heat_Pump_KWh <- NA
  List_of_Homes[[kera]]$HRV_KWh <- NA
  
  
  
  List_of_Homes[[kera]]$Stove_Receptacle_KWh <- List_of_Homes[[kera]]$Stove_Receptacle_KW*0.016666
  List_of_Homes[[kera]]$Refrigerator_KWh <- List_of_Homes[[kera]]$Refrigerator_KW*0.016666
  List_of_Homes[[kera]]$Counter_GFCI_Receptacles_KWh <- List_of_Homes[[kera]]$Counter_GFCI_Receptacles_KW*0.016666
  List_of_Homes[[kera]]$Exhaust_Hood_Liv_Rm_Plug_KWh <- List_of_Homes[[kera]]$Exhaust_Hood_Liv_Rm_Plug_KW*0.016666
  List_of_Homes[[kera]]$Bathroom_Heat_GFCI_KWh <- List_of_Homes[[kera]]$Bathroom_Heat_GFCI_KW*0.016666
  List_of_Homes[[kera]]$Bedroom_1_D_Duplex_Recpt_KWh <- List_of_Homes[[kera]]$Bedroom_1_D_Duplex_Recpt_KW*0.016666
  List_of_Homes[[kera]]$Bedroom_2_D_Duplex_Recpt_KWh <- List_of_Homes[[kera]]$Bedroom_2_D_Duplex_Recpt_KW*0.016666
  List_of_Homes[[kera]]$Lighting_Circuit_KWh <- List_of_Homes[[kera]]$Lighting_Circuit_KW*0.016666
  List_of_Homes[[kera]]$Bathroom_Circuit_KWh <- List_of_Homes[[kera]]$Bathroom_Circuit_KW*0.016666
  List_of_Homes[[kera]]$Bedroom_1_and_2_Heat_KWh <- List_of_Homes[[kera]]$Bedroom_1_and_2_Heat_KW*0.016666
  List_of_Homes[[kera]]$Water_Heater_KWh <- List_of_Homes[[kera]]$Water_Heater_KW*0.016666
  List_of_Homes[[kera]]$First_Floor_Heat_Pump_KWh <- List_of_Homes[[kera]]$First_Floor_Heat_Pump_KW*0.016666
  List_of_Homes[[kera]]$HRV_KWh <- List_of_Homes[[kera]]$HRV_KW*0.016666
  
  
  List_of_Homes[[kera]]$HVAC_Energy_usage_KWh <- 
    (List_of_Homes[[kera]]$Bathroom_Heat_GFCI_KW+
        List_of_Homes[[kera]]$Bedroom_1_and_2_Heat_KW+
        List_of_Homes[[kera]]$First_Floor_Heat_Pump_KW)*0.016666
  
  
  List_of_Homes[[kera]]$Overall_Energy_usage_KWh <- 
    (List_of_Homes[[kera]]$Stove_Receptacle_KW+
       List_of_Homes[[kera]]$Refrigerator_KW+
       List_of_Homes[[kera]]$Counter_GFCI_Receptacles_KW+
       List_of_Homes[[kera]]$Exhaust_Hood_Liv_Rm_Plug_KW+
       List_of_Homes[[kera]]$Bathroom_Heat_GFCI_KW+
       List_of_Homes[[kera]]$Bedroom_1_D_Duplex_Recpt_KW+
       List_of_Homes[[kera]]$Bedroom_2_D_Duplex_Recpt_KW+
       List_of_Homes[[kera]]$Lighting_Circuit_KW+
       List_of_Homes[[kera]]$Bathroom_Circuit_KW+
       List_of_Homes[[kera]]$Bedroom_1_and_2_Heat_KW+
       List_of_Homes[[kera]]$First_Floor_Heat_Pump_KW+
       List_of_Homes[[kera]]$Water_Heater_KW+
       List_of_Homes[[kera]]$HRV_KW)*0.016666
}



for (i in seq(1,8,1))
  
{
  
  getwd()
  FileOut <- paste(c('Processed_Energy_KWh_',List_of_Home_names[[i]],'.csv'), collapse='')
  getwd() 
  write.table(List_of_Homes[[i]], file=FileOut, quote=F, append=F, sep=',', row.names=F, col.names=T)
  
}

