library(tidyverse)
library(tidytext)
library(lubridate)
library(RSQLite)

get_buzzfeed_stories <- function(paging){
  url <- paste("https://www.buzzfeed.com/api/v2/feeds/news?p=", paging, sep = '')
  data <- jsonlite::fromJSON(url)
  stories <- data$buzzes
  stories %>%
    select(
      title,
      category,
      published_date,
      bylines
    ) %>%
  unnest(bylines) %>%
  select(title, category, published_date, display_name) -> stories
  stories
}

conn <- dbConnect(RSQLite::SQLite(), "BuzzFeedDB.db")

get_buzzfeed_stories(1) %>%
  dbWriteTable(conn, "BuzzFeed_data", .)

2 %>%
  map(., get_buzzfeed_stories) %>%
  compact() %>%
  reduce(bind_rows) %>%
  dbAppendTable(conn, "BuzzFeed_data", .)

3:1000 %>%
  map(., get_buzzfeed_stories) %>%
  compact() %>%
  reduce(bind_rows) %>%
  dbAppendTable(conn, "BuzzFeed_data", .)

1001:1750 %>%
  map(., get_buzzfeed_stories) %>%
  compact() %>%
  reduce(bind_rows) %>%
  dbAppendTable(conn, "BuzzFeed_data", .)

dbDisconnect(conn)

