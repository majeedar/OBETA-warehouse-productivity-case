#create df for volumes column


prod_con<- dbConnect(RMySQL::MySQL(),
                      dbname="production_data", host='localhost',
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
join_non_zero$volume.outlier.flag<-outlier.create.flag(join_non_zero$volume_of_order)

table(join_non_zero$volume.outlier.flag)

#create only outlier table on R

only_outlier_table <- filter(joined_df, volume.outlier.flag ==1)

#create a filtered table with no outlier

join_clean_df <- filter(join_non_zero, volume.outlier.flag ==0)

#copy only cleaned Values dates to mysql SCHEMA

dbWriteTable(prod_con, "join_clean_df",join_clean_df, overwrite=T)


