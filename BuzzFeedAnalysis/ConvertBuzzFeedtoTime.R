library(tidyverse)
library(lubridate)
library(RSQLite)

con = dbConnect(SQLite(), dbname="BuzzFeedDB.db")

query <- dbSendQuery(con, "SELECT * FROM BuzzFeed_data")
df <- dbFetch(query, n = -1)

df %>% mutate(
  date = as_date(published_date),
  year = year(date),
  month = month(date),
  day = day(date),
  hour = hour(published_date)
) -> df

df %>%
  group_by(date) %>%
  count() %>%
  rename(articlesPerDay = n) -> df_grouped

write_csv(df_grouped,"C:/Users/Schonanderl/Documents/dataProjects/ArticleTitleTextAnalysis/df_grouped.csv")