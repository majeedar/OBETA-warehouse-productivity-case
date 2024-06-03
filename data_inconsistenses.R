
library(dplyr)
libra
#Create a order year column
joined_table$order_year <- year(joined_table$date_of_order)

#filter out order IDs which duplicates themselve in more than one order year 
duplicated_orderid <- joined_table %>%
  group_by(order_number) %>%
  filter(n_distinct(year) > 1) %>%
  select(order_number) %>%
  distinct()

set.seed(123)
df <- data.frame(
  ID = 1:10,
  Value = c(3, 0, 8, 0, 5, 0, 2, 9, 0, 6)
)


dfz <- filter(df, Value == 0) 
  nrow()
table(dfz)

#Filter rows with  zero order volume
zero_values<- filter(joined-table, Value == 0) 

table(zero_values)

df1<-(df,~ sum(is.na(.)))


set.seed(123)
data <- data.frame(
  order_id = sample(1:10, 20, replace = TRUE),
  year = sample(2020:2022, 20, replace = TRUE)
)


filtered_data1 <- data %>%
  group_by(order_id) %>%
  filter(n_distinct(year) > 1) %>%
ungroup()

table(data)


#filter out order IDs which duplicate themselves in more than one order year 
duplicated_orderid <- joined_table %>%
    group_by(order_number) %>%
    filter(n_distinct(year) > 1) %>%
    ungroup()
table()


