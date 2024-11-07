plot_map <- function(df, vector, cols, angle, xmin, xmax, ymin, ymax){
  
  # crs
  crs_string <- paste0("+proj=omerc +lat_0=36.934 +lonc=-90.849 +alpha=0 +k_0=.7 +datum=WGS84 +units=m +no_defs +gamma=", angle)
  
  # set up bounding box - order: xmin, ymin, xmax, ymax
  bb <- st_bbox(df %>% project(., y = crs_string))
  
  p <- ggplot() +
    geom_sf(data = vector %>% st_transform(4326), 
            colour = cols,
            linewidth = 1.5, 
            fill = NA) + 
    #geom_sf(data = roads, colour = "grey20", alpha = 0.6) + 
    geom_spatraster(data = df, aes(fill = `660_IndiceCanopee_2021`), 
                    na.rm = T, 
                    show.legend = F) + 
    scale_fill_gradient2(low = "darkgreen", mid = "darkgreen", 
                         high = "darkgreen", na.value = NA) +  
    coord_sf(crs = crs_string,
             xlim = c(bb[1]+xmin, bb[3]-xmax), 
             ylim = c(bb[2]+ymin, bb[4]-ymax)) + 
    theme_bw() + 
    theme(panel.border = element_rect(linewidth = 1, fill = NA),
          panel.background = element_rect(fill = 'grey89'),
          panel.grid = element_line(color = '#323232', linewidth = 0.2),
          axis.text = element_text(size = 11, color = 'black'),
          axis.title = element_blank(), 
          axis.text.x = element_text(angle = 45, vjust = 0.5),
          plot.background = element_rect(fill = NA, colour = NA))
  
  return(p)
  
}
