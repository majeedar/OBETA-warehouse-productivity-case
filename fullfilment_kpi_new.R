#create df for fullfilment kpi

fullfil_kpi_df <- joined_df_clean[ , c( "warehouse_area","pickid_unique", "date_of_order" )]


#Maximum times, minimun times and number of picks per order
min_max2 <- fullfil_kpi_df %>%
  group_by(pickid_unique, warehouse_area) %>%
  summarize(earliest_datetime = min(date_of_order),
            latest_datetime = max(date_of_order), order_frequency = n())

#Average difference in Fullfilmenttime
min_max2$average_fullfilment_time<- (as.numeric(difftime(min_max2$latest_datetime, 
                                    min_max2$earliest_datetime, 
                                    units = "mins")))/min_max2$order_frequency