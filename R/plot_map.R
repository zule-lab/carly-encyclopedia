plot_map <- function(df){
  
  p <- ggplot() +
    geom_spatraster(data = df, aes(fill = `660_IndiceCanopee_2021`), 
                    na.rm = T, 
                    show.legend = F) + 
    scale_fill_gradient2(low = "darkgreen", mid = "darkgreen", 
                         high = "darkgreen", na.value = NA) +  
    coord_sf() + 
    theme_bw()
  
  return(p)
  
}