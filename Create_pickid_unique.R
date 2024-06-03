#CREATE UNIQUE PICK ID

#create a year column
library(lubridate)

joined_df_clean$order_year <- year(joined_df_clean$date_of_order)  



#Create column merge values of columns with merge columns (warehouse area, order year and orderid)
cl_mg <- c("order_year", "order_number")

join_non_zero$orderid_unique<- do.call(paste, c(join_non_zero
                                                 [cl_mg], sep=""))


