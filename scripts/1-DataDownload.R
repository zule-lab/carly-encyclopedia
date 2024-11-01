#======= Script to download all necessary open-source data 

# source packages & custom functions 
source('R/packages.R')
source('R/download_file.R')



# Boundaries --------------------------------------------------------------

# montreal neighbourhoods
quartiers <- download_shp("https://donnees.montreal.ca/dataset/c8f37ad6-16ff-4cdc-9e5a-e47898656fc9/resource/d342d18e-f710-4991-a259-0092bac3d62c/download/quartiers_sociologiques_2014.zip", 
                          "input/quartiers.zip")

# dissemination areas
da_raw <- download_shp("https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lda_000b21a_e.zip",
                       "input/da_raw.zip")



# Canopy ------------------------------------------------------------------

can_2021 <- download_tif("https://observatoire.cmm.qc.ca/documents/carte/canope/2021/IC_TIFF/660_IndiceCanopee_2021_TIF.zip",
                         "input/canopy.zip", 
                         "660_IndiceCanopee_2021.tif")



# Census ------------------------------------------------------------------

census_raw <- download_csv("https://www12.statcan.gc.ca/census-recensement/2021/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=006_Quebec")



