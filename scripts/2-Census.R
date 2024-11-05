#======= Script to calculate relevant socioeconomic variables 


# Prep --------------------------------------------------------------------

# source packages & custom functions 
source('R/packages.R')

# load data 
da_raw <- readRDS('output/da_raw.rds')
census_raw <- readRDS('output/census_raw.rds')
arrondissements <- readRDS('output/arrondissements.rds')

# calculate census vars 
study_da <- st_intersection(da_raw, st_transform(arrondissements, crs = st_crs(da_raw)))


# Calculations ------------------------------------------------------------

census_da_f <- census_raw %>%
  select(c("ALT_GEO_CODE","CHARACTERISTIC_ID","C1_COUNT_TOTAL")) %>%
  rename(DAUID = "ALT_GEO_CODE",
         sofac = "CHARACTERISTIC_ID",
         sonum = "C1_COUNT_TOTAL") %>%
  mutate(DAUID = as.character(DAUID)) %>% 
  right_join(study_da, by = "DAUID") %>%
  filter(sofac %in% c(1, 6:7, 115, 1683:1684)) 

# we are interested in income and visible minorities 

# 1   Population 2021
# 6   Pop density per sq km
# 7   Land area sq km

# Income statistics in 2020 for the population aged 15 years and over in private households - 100% data (10)
# 115   Median after-tax income in 2020 among recipients ($)

# 1683	Total - Visible minority for the population in private households - 25% sample data (117)
# 1684	  Total visible minority population (118)


census_da_w <- census_da_f %>% pivot_wider(names_from = sofac, values_from = sonum)

census_da_r <- census_da_w %>%
  rename(totpop = "1") %>%
  rename(popdens = "6") %>%
  rename(area = "7") %>% 
  rename(medinc = "115") %>% 
  rename(totvismin = "1683") %>% 
  rename(vismin = "1684")

census_da_sf <- st_as_sf(census_da_r, sf_column_name = c("geometry"), crs = st_crs(study_da))

census_da_na <- census_da_sf %>% 
  drop_na(DAUID)  %>%
  mutate(da = as.factor(DAUID)) %>%
  mutate(across(c(totpop:vismin), ~as.numeric(.))) %>%
  select(-c(DGUID, LANDAREA, PRUID, DAUID))

# population percentages
can_cen_pp <- census_da_na %>% 
  mutate(per_vismin = vismin/totvismin)


# Save --------------------------------------------------------------------

saveRDS(can_cen_pp, 'output/census.rds')
