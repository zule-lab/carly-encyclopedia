plot_map <- function(df, xmin, xmax, ymin, ymax){
  
  # set up bounding box - order: xmin, ymin, xmax, ymax
  bb <- st_bbox(df) %>% 
    st_transform(crs = 4326)
  
  mtl <- opq(bb) %>%
    add_osm_feature(key = 'highway', value = c('motorway', 'trunk', 
                                               'primary', 'secondary', 
                                               'tertiary', 'residential')) %>%
    osmdata_sf()
  
  roads <- st_as_sf(mtl$osm_lines)
  
  p <- ggplot() +
    geom_sf(data = roads, colour = "grey20", alpha = 0.6) + 
    geom_spatraster(data = df, aes(fill = `660_IndiceCanopee_2021`), 
                    na.rm = T, 
                    show.legend = F) + 
    scale_fill_gradient2(low = "darkgreen", mid = "darkgreen", 
                         high = "darkgreen", na.value = NA) +  
    coord_sf(xlim = c(xmin, xmax), ylim = c(ymin, ymax)) + 
    theme_bw() + 
    theme(panel.border = element_rect(linewidth = 1, fill = NA),
          panel.background = element_rect(fill = '#ddc48d'),
          panel.grid = element_line(color = '#323232', linewidth = 0.2),
          axis.text = element_text(size = 11, color = 'black'),
          axis.title = element_blank(), 
          plot.background = element_rect(fill = NA, colour = NA))
  
  return(p)
  
}
