
#create df for fullfilment kpi

fullfil_kpi_df <- joined_df_clean[ , c( "warehouse_area","pickid_unique", "date_of_order" )]




#Maximum and minimun times
min_max <- fullfilment_table %>%
  group_by(new_orderid) %>%
  summarize(earliest_datetime = min(date_of_order),
            latest_datetime = max(date_of_order))


#Maximum times, minimun times and number of picks per order
min_max2 <- fullfilment_table %>%
  group_by(new_orderid) %>%
  summarize(earliest_datetime = min(date_of_order),
            latest_datetime = max(date_of_order), order_frequency = n())


# find Fullfilment time i.e. difference between max and min pick times per order number

pick_efficiency_facts$pick_efficiency <- as.numeric(difftime
                          (pick_efficiency_facts$latest_datetime, pick_efficiency_facts$earliest_datetime, 
                          units = "mins"))
  

  
#write kpi to mysql db
dbWriteTable(trans_con, "min_max",min_max, overwrite=T)

# find Fullfilment time i.e. difference between max and min pick times per order number with frequencies of picks

min_max2$fullfilment_time2 <- (as.numeric(difftime(min_max$latest_datetime, min_max$earliest_datetime, 
                                                units = "mins")))/min_max2$order_frequency

#write kpi to mysql db

dbWriteTable(trans_con, "min_max2",min_max2, overwrite=T)

rm(only_outlier_table,trans_con,)

  