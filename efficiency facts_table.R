
#CREATE PICK EFFICIENCY FACTS TABLE
pick_efficiency_facts <- join_facts %>%
  group_by(orderid_unique) %>%
  summarize(earliest_datetime = min(date_of_order),
            latest_datetime = max(date_of_order), number_of_picks = n())


#create a pick efficiency column
pick_efficiency_facts$efficiency_per_order <- 
  as.numeric(difftime(pick_efficiency_facts$latest_datetime,
                      pick_efficiency_facts$earliest_datetime,
                      units = "mins"))