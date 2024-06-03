#IDENTIFY AND CLEAN DUPLICATED ROWS

#Flag duplicate rows

X<-warehouse_section_dim

x_dupli <- X %>%
  group_by_all() %>%
  mutate(is_duplicate = n() > 1)

table(x_dupli$is_duplicate)

#Create a DF and flag  for duplicated rows 

joined_df_dupli <- joined_df %>%
  group_by_all() %>%
  mutate(is_duplicate = n() > 1)

table(joined_df_dupli$is_duplicate)

# filter duplicate rows
only_dupli_rows <- joined_df %>%
  group_by_all() %>%
  filter(n() > 1)


#Remove duplicates
join_df_unique <- joined_df %>% distinct()