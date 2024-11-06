#======= Script to calculate canopy cover in each DA 


# Prep --------------------------------------------------------------------

source('R/packages.R')

# data 
arrondissements <- readRDS('output/arrondissements.rds')
quartiers <- readRDS('output/quartiers.rds')
canopy <- readRDS('output/can_2021.rds')

# transform
arrond_trans <- st_transform(arrondissements, st_crs(canopy))
quart_trans <- st_transform(quartiers, st_crs(canopy))


# Calculations ------------------------------------------------------------

# calculate the fraction of each DA that is covered by each land cover category:

fracs_arrond <- exact_extract(canopy, arrond_trans, function(df) {
  
  df %>%
    mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
    group_by(NOM, value) %>%
    summarize(freq = sum(frac_total))
}, 
summarize_df = TRUE, 
include_cols = 'NOM', 
progress = FALSE)


fracs_quartiers <- exact_extract(canopy, quart_trans, function(df) {
  
  df %>%
    mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
    group_by(Q_socio, value) %>%
    summarize(freq = sum(frac_total))
}, 
summarize_df = TRUE, 
include_cols = 'Q_socio', 
progress = FALSE)


# high canopy cover & high income: Westmount (0.34)
# medium canopy cover & med income: Rosemont (0.23)
# low canopy cover & low income: Parc-Ex (0.13)

westmount <- arrond_trans %>% 
  filter(NOM == "Westmount") 

parcex <- quart_trans %>% 
  filter(Q_socio == "Parc-Extension")

rosemont <- quart_trans %>% 
  filter(Q_socio == "Rosemont")

r_westmount <- crop(canopy, westmount, mask = T) %>% 
  filter(`660_IndiceCanopee_2021` == 4)
r_parcex <- crop(canopy, parcex, mask = T) %>% 
  filter(`660_IndiceCanopee_2021` == 4)
r_rosemont <- crop(canopy, rosemont, mask = T) %>% 
  filter(`660_IndiceCanopee_2021` == 4)


# Save --------------------------------------------------------------------

saveRDS(r_westmount, 'output/westmount_canopy.rds')
saveRDS(r_parcex, 'output/parcex_canopy.rds')
saveRDS(r_rosemont, 'output/rosemont_canopy.rds')
