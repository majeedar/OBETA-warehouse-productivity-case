# create month_year column 

joined_df_clean$order_month <- month(joined_df_clean$date_of_order) 

ym<- c("order_year1", "order_month")



joined_df_clean$year_month <- do.call(paste, c(joined_df_clean
                                               [ym], sep="-"))


table(join_facts$volume.outlier.flag)

write.csv2(total_volume_monthly, file = "C:/Users/Majeed Win10/Documents/DS1/Group Work/total_monthly.csv", row.names = FALSE)
class(total_volume_monthly)



