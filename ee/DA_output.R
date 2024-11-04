#======= Script to output assets for GEE code

# source packages 
source('R/packages.R')

# load data 
arrondissements <- readRDS('output/arrondissements.rds')
da_raw <- readRDS('output/da_raw.rds')

# intersect DAs with Montreal boundaries 
da_mtl <- st_intersection(da_raw, st_transform(arrondissements, crs = st_crs(da_raw)))

# save 
write_sf(da_mtl, 'ee/da_mtl.shp')
