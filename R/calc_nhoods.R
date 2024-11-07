calc_nhoods <- function(arrond, quartiers, census, satellite){
  
  # DAs within neighbourhoods w census and satellite data 
  westmount <- arrond %>% 
    filter(NOM == "Westmount")
  
  parcex <- quartiers %>% 
    filter(Q_socio == "Parc-Extension")
  
  da <- readRDS('output/da_raw.rds')
  
  westmount_da <- st_intersection(westmount %>% st_transform(crs = st_crs(da)), da) %>% 
    select(c(NOM, DAUID)) %>% 
    st_drop_geometry() 
  
  parcex_da <- st_intersection(parcex %>% st_transform(crs = st_crs(da)), da) %>% 
    select(c(Q_socio, DAUID)) %>% 
    st_drop_geometry() %>% 
    rename(NOM = Q_socio)
  
  nhood_da <- rbind(westmount_da, parcex_da) %>% 
    left_join(., census, by = join_by(DAUID == da)) %>% 
    st_drop_geometry()
  
  nhood_da_sat <- nhood_da %>% 
    left_join(., satellite, by = "DAUID") %>% 
    filter(mean_ndvi > -1 & mean_ndvi < 1) %>% 
    pivot_longer(cols = c(per_vismin, medinc, mean_ndvi), names_to = "independent", values_to = "values") %>% 
    select(c(NOM.x, DAUID, mean_lst, independent, values)) %>% 
    mutate(NOM = NOM.x)
  
  return(nhood_da_sat)
  
  
}