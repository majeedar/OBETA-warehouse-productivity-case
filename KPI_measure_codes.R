#KPI 1.1 
        #Total volume of picks per warehouse section

total_volume_wh <- aggregate(volume_of_order ~ warehouse_area, 
                             data = final_df_clean, sum)

        #average pick efficiency= average pick vulome per month,year
library(lubridate)
library(dplyr)



# KPI 1.2 
    #Total volume of picks per product group 

total_volume_pg <- aggregate(volume_of_order ~ product_group, 
                             data = final_df_clean, sum)

#total volume per month and year
total_volume_monthly <- aggregate(volume_of_order ~ year_month, 
                             data = joined_df_clean, sum)

total_volume_yearly <- aggregate(volume_of_order ~ order_year1, 
                             data = joined_df_clean, sum)

#total volume per month and year in dplyr and lubridate

library(lubridate)
library(dplyr)

#convert and create a datetime column

final_df_clean$date_of_order <- 
    as.POSIXct(final_df_clean$date_of_order, format = "%y%m%d %H:%M:%S")


final_df_clean$month_of_order <- final_df_clean %>%
  mutate(month = floor_date(date_of_order, "month"))

# Group by month and summarize the numeric column
result <- your_data %>%
  group_by(month) %>%
  summarise(sum_numeric_col = sum(numeric_col))





create








