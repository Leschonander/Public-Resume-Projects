not_mine <- c("Your Top Songs 2016", "Vietnam War Era Music", "The Young Pope: Official Playlist", "Spotify.Me", "SLEEP B", "SLEEP A", "Metal Gear Solid V - The Phantom Pain", "Hotline Miami OST", "Fallout: New Vegas", "Danger Mouse Jukebox", "<U+2116> 7")
my_track_features <- filter(my_track_features, !playlist_name %in% not_mine)

ggplot(my_track_features, aes(x = danceability, y = playlist_name)) + 
  geom_density_ridges() + 
  labs(x = "Danceability",y = "Track Name")
ggtitle("Ridgeplot of danceability for my playlists", subtitle = paste0("Based on loudness pulled from Spotify's Web API with spotifyr"))

my_rock_data <-  data.frame(rock_metal$speechiness, rock_metal$acousticness, rock_metal$instrumentalness, rock_metal$liveness, rock_metal$valence, rock_metal$tempo, rock_metal$duration_ms, rock_metal$danceability)
rockcor <- cor(my_rock_data)
corrplot(rockcor, method = "number")

iggypop <- get_artist_audio_features("Iggy Pop")

ggplot(iggypop, aes(x = loudness, y = album_name)) + 
  geom_density_ridges() + 
  labs(x = "Loudness",y = "Album Name")
ggtitle("Ridgeplot of Iggy Pop Loudness", subtitle = paste0("Based on loudness pulled from Spotify's Web API with spotifyr"))

iggypop_data <- data.frame(iggypop$speechiness, iggypop$acousticness, iggypop$instrumentalness, iggypop$liveness, iggypop$valence, iggypop$tempo, iggypop$duration_ms, iggypop$danceability)
round(cor(iggypop_data),2)
View(round(cor(iggypop_data),2))

igcor <- cor(iggypop_data)
corrplot(igcor, method = "circle")
corrplot(igcor, method = "number")