# Remove zero value rows

join_non_zero <- join_df_unique %>% 
              filter(volume_of_order != "0")


#Filter negative volume rows

join_negative <- join_df_unique %>% 
  filter(volume_of_order < "0")



