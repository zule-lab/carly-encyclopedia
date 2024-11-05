#======= Script to import and clean satellite imagery from GEE 


# Prep --------------------------------------------------------------------

source('R/packages.R')

lst <- read.csv('input/dissemination_areas_LST.csv') %>% 
  select(c(system.index, DAUID, count, max, mean, median, min, stdDev))

ndvi <- read.csv('input/dissemination_areas_NDVI.csv') %>% 
  select(c(system.index, DAUID, count, max, mean, median, min, stdDev))

da_raw <- readRDS('output/da_raw.rds')


# Clean -------------------------------------------------------------------


lst_ndvi_da <- inner_join(lst %>% mutate(DAUID = as.character(DAUID)), da_raw, by = 'DAUID') %>% 
  inner_join(., ndvi %>% mutate(DAUID = as.character(DAUID)), by = c("DAUID", "system.index"), suffix = c("_lst", "_ndvi")) %>% 
  separate_wider_delim(cols = system.index, delim = "_", names = c("satellite", "coverage", "date", "band")) %>% 
  mutate(date = as.Date(date, format = "%Y%m%d"))




# Save --------------------------------------------------------------------

saveRDS(lst_ndvi_da, 'output/satellite.rds')
