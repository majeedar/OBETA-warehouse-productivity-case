summary(facts_table$volume_of_order)
length(unique(facts_table$warehouse_area)
cou
  oi_t<<- facts_table %>% count(orderid_unique) %>% arrange(desc(n))     
 sdf <- facts_table %>% summarize(sd(volume_of_order))
 
 facts_table %>% count(volume_of_order) %>% arrange(desc(n))