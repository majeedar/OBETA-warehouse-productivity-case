library(dplyr)

pick_efficiency_new <- facts_table %>%
  group_by(orderid_unique, warehouse_area) %>%
  summarize(earliest_datetime = min(date_of_order),
            latest_time = max(date_of_order), 
            order_frequency = n())


# difference in efficiency per order
pick_efficiency_new$efficiency_per_order<- 
  as.numeric(difftime(pick_efficiency_new$latest_time, 
  pick_efficiency_new$earliest_datetime, units = "mins"))

# difference in efficiency per product
pick_efficiency_new$efficiency_per_product<- 
  pick_efficiency_new$efficiency_per_order/
  pick_efficiency_new$order_frequency



pick_efficiency_new <- pick_efficiency_new[,c("orderid_unique", "warehouse_area",
                    "earliest_datetime", "efficiency_per_order", 
                    "efficiency_per_product","order_frequency")]


# create efficiency table and copy to mysql
library(DBI)
library(RMySQL)
library(dplyr)

# connect to staging data Schema

prod_con<- dbConnect(RMySQL::MySQL(),
                     dbname="production_data", host='localhost',
                     port=3306,
                     user='root',
                     password='mysql')

dbWriteTable(prod_con,"pick_efficiency_new",pick_efficiency_new,row.names=FALSE)



#group per month and year and warehouse area

efficiency_table <- efficiency_table %>%
  mutate(year = year(earliest_datetime), month = month(earliest_datetime))

monthly_efficiency <- efficiency_table %>%
  group_by(warehouse_area,year, month) %>%
  summarize(avr_efficiency=mean(average_efficiency))
#Copy to mysql
dbWriteTable(prod_con,"monthly_efficiency",monthly_efficiency,overwrite=T)

 
#CREATE Average PICK EFFICIENCY

efficiency_dim1$avg_efficiency_per_pick<- (efficiency_dim1$average_efficiency)/(efficiency_dim1$order_frequency)



avg_efficiency_pick <- efficiency_dim1[,c("orderid_unique", "warehouse_area","earliest_datetime", "avg_efficiency_per_pick")]


#GROUP average pick efficiency per month and year and warehouse area

avg_efficiency_pick <- avg_efficiency_pick %>%
  mutate(year = year(earliest_datetime), month = month(earliest_datetime))

monthly_effi_per_pick <- avg_efficiency_pick %>%
  group_by(warehouse_area,year, month) %>%
  summarize(avg_efficiency_per_pick=mean(avg_efficiency_per_pick))
#Copy to mysql
dbWriteTable(prod_con,"monthly_effi_per_pick",monthly_effi_per_pick,overwrite=T)


