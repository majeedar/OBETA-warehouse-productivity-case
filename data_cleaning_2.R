#create df for joined data on R Global environment

library(DBI)
library(RMySQL)

trans_con<- dbConnect(RMySQL::MySQL(),
                      dbname="transformation_data", host='localhost',
                      port=3306,
                      user='root',
                      password='mysql')


t_d <- tbl(con_trans, "joined_table")

#write join table to R env'n

joined_df <- collect(t_d)


#create outlier flag function


outlier.create.flag<-function(x)
{
  hist(x)
  summary(x)
  
  # using here the z values 
  flag<- ifelse(test = scale(x) > 3 | scale(x)< -3, yes = 1, no = 0)
  # number of outlier
  table(flag)
  
  # return the vector representing the flag variable
  flag  
}


# determine outlier for joined data and add to df
join_non_zero$volume_outlier_flag<-outlier.create.flag(join_non_zero$volume_of_order)



# create a table of only outliers


final_df_clean <- join_non_zero %>% 
  filter(volume_outlier_flag == "0")



#copy only cleaned Values dates to mysql SCHEMA

dbWriteTable(trans_con, "joined_df_clean",joined_df_clean, overwrite=T)
