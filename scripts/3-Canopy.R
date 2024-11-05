#======= Script to calculate canopy cover in each DA 


# Prep --------------------------------------------------------------------

source('R/packages.R')

# data 
arrondissements <- readRDS('output/arrondissements.rds')
quartiers <- readRDS('output/quartiers.rds')
canopy <- readRDS('output/can_2021.rds')


# convert to same projection as canopy cover 
arrond_trans <- st_transform(arrondissements, st_crs(canopy))
quartiers_trans <- st_transform(quartiers, st_crs(canopy))

# Calculations ------------------------------------------------------------

# calculate the fraction of each DA that is covered by each land cover category:

fracs_arrondissement <- exact_extract(canopy, arrond_trans, function(df) {
  
  df %>%
    mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
    group_by(NOM, value) %>%
    summarize(freq = sum(frac_total))
  }, 
  summarize_df = TRUE, 
  include_cols = 'NOM', 
  progress = FALSE)

can_arrond <- fracs_arrondissement %>% 
  filter(value == 4) %>% 
  mutate(per_can = freq) %>% 
  select(-c(value, freq))
  


fracs_quartiers <- exact_extract(canopy, quartiers_trans, function(df) {
  
  df %>%
    mutate(frac_total = coverage_fraction / sum(coverage_fraction)) %>%
    group_by(Q_socio, value) %>%
    summarize(freq = sum(frac_total))
}, 
summarize_df = TRUE, 
include_cols = 'Q_socio', 
progress = FALSE)





# Save --------------------------------------------------------------------

saveRDS()
saveRDS()
