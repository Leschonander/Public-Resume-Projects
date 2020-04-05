library(tidyverse)
library(lubridate)
library(sf)
library(xml2)
library(leaflet)
source("PlotWork.R")

fire_feed <- "https://inciweb.nwcg.gov/feeds/rss/incidents/"

parse_fires <- function(){
  items <- fire_feed %>%
    read_xml() %>%
    xml_find_all(".//item")

  
  tibble(
    Title = items %>%
      xml_find_all(".//title") %>%
      xml_text(),
    
    Desc = items %>%
      xml_find_all(".//description") %>%
      xml_text(),
    
    Lat =  items %>%
      xml_find_all(".//geo:lat") %>%
      xml_text() %>%
      as.numeric(),
    
    Long = items %>%
      xml_find_all(".//geo:long") %>%
      xml_text() %>%
      as.numeric(),
    
    Date = items %>%
      xml_find_all(".//pubDate") %>%
      xml_text() %>%
      word(., 2, 4) %>%
      dmy(),
    
    Date_Time = items %>%
      xml_find_all(".//pubDate") %>%
      xml_text() %>%
      word(., 2, 5) %>%
      parse_date_time("dmy HMS")
  ) %>%
    mutate(
      Fire_Status = sub("\\).*", "", sub(".*\\(", "", Title)) 

    )
}
# https://inciweb.nwcg.gov/incident/6595/
fires <- parse_fires()

load_state_map <- function(){
  usa <- map_data('state') %>%
    fortify() 
  
  usa$region <- str_to_title(usa$region) 
  usa
}
USA <- load_state_map()

# A regular map
ggplot() +
  geom_polygon(data = USA, aes(x = long, y = lat, group = group), fill="grey40", colour="grey90", alpha=1) +
  geom_point(data = fires, aes(x = Long, y = Lat), size = 2, alpha = 1, colour = "red")  + 
  coord_sf(crs = 26910) + theme_my_axios() + map_edit() + labs(
    x = "",
    y = "",
    title = "Wildfires",
    subtitle = "Source: inciweb",
    caption = "@LarsESchonander"
  ) 
