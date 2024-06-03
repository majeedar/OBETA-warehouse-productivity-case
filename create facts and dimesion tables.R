library(DBI)
library(RMySQL)
library(dplyr)

# connect to staging data Schema

prod_con<- dbConnect(RMySQL::MySQL(),
                    dbname="production_data", host='localhost',
                    port=3306,
                    user='root',
                    password='mysql')

#NB: Remember to enable mysql so that R can read from it 
# run code on mysql: SET GLOBAL local_infile = 'ON'

#TABLE 1 WAREHOUSE SECTION DATAFRAME/Dimension

#create warehouse name

  #Create Warehouse name column in

join_facts <- join_facts %>%
  mutate(section_name = case_when(
    grepl("AKL", warehouse_area, ignore.case = TRUE) ~ "Automated Small-Parts Warehouse",
    grepl("HRL", warehouse_area, ignore.case = TRUE) ~ "High Bay Storage for Pallets",
    grepl("SHL", warehouse_area, ignore.case = TRUE) ~ "Shuttle house",
    grepl("Kabellager", warehouse_area, ignore.case = TRUE) ~ "Cable Storage",
    grepl("Manuell", warehouse_area, ignore.case = TRUE) ~ "Manual Warehouse",
    TRUE ~ "Other"
  ))


#Create warehouse dimension table with Warehouse name and section

warehouse_section_dim <- join_facts[,c("warehouse_area", 
                                      "section_name")]
  
#remove duplicated rows from WH dim
warehouse_section_dim <- warehouse_section_df %>% distinct()

#copy the created warehouse section dim Table into my mysql's SCHEMA production data


dbWriteTable(prod_con,"warehouse_section_dim",warehouse_section_dim,row.names=FALSE)



#TABLE 2 PRODUCT DIMENSION

#Create Product dimension table

product_dim <- join_facts[,c("product_id", "description", "product_group", 
                                "quantity_unit")]
#remove duplicated rows
product_dim <- product_dim %>% distinct()

#copy the created product dim Table into my mysql's SCHEMA production data


dbWriteTable(prod_con,"product_dim",product_dim,row.names=FALSE)



#TABLE 3 ORDER DIMENSION

#Create Order dimension table 

order_dim <- join_facts[,c("orderid_unique", "order_number", "order_origin", 

                                "position_in_order", "date_of_order")]

#remove duplicated rows
order_dim <- order_dim %>% distinct()

#copy the created order dim Table into my mysql's SCHEMA production data


dbWriteTable(prod_con,"order_dim",order_dim,row.names=FALSE)



#Create Time Dimension


time_dim <- join_facts[,c("date_of_order", "order_year" )]

# Extract day

library(lubridate)

time_dim$day <- day(time_dim$date_of_order)

#extract_month

time_dim$month <- month(time_dim$date_of_order)

#extract Year if you didnt have it for the unique on your join_facts table

time_dim$year <- year(time_dim$date_of_order)


#COPY Time DIMESION TABLE INTO MYSQL

dbWriteTable(prod_con,"time_dim",time_dim,row.names=FALSE)



#Create Facts Table

facts_table <- join_facts[,c("warehouse_area","orderid_unique", "product_id", 
                             "date_of_order", "position_in_order",
                              "volume_of_order", "pick_efficiency")]




#COPY FACTS TABLE  INTO MYSQL

dbWriteTable(prod_con,"facts_table",facts_table,row.names=FALSE)





