get_osm_data <- function(adress, our_key, our_value) {
  
  dane_search <- getbb(adress) %>%
    opq() %>%
    add_osm_feature(key = our_key, value = our_value) %>%
    osmdata_sf()
  
  return(dane_search)
}

get_x_y <- function(dane) {
  
  get_coords <- dane$bbox %>%
    str_split(",") %>%
    unlist() %>%
    as.numeric()
  
  x_long <- (get_coords[2] + get_coords[4])/2
  y_lat <- (get_coords[1] + get_coords[3])/2
  
  long_lat = list(lng_x = x_long, lat_y = y_lat)
  
  return(long_lat)
}

plot_points <- function(dane, our_adress) {

  get_coords <- get_x_y(dane)
  
  leaflet() %>%
    addTiles() %>%
    setView(lng = our_adress$long, lat = our_adress$lat, zoom = 14) %>%
    addMarkers(data = dane$osm_points,
               label= dane$osm_points$name) %>%
    addCircleMarkers(lng = our_adress$long, lat = our_adress$lat,
                     label= our_adress$street)

}