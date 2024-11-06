#======= Script to plot data


# Prep --------------------------------------------------------------------

source('R/packages.R')

# cleaned data
census <- readRDS('output/census.rds')
satellite <- readRDS('output/satellite.rds')

westmount <- readRDS('output/westmount_canopy.rds')
parcex <- readRDS('output/parcex_canopy.rds')
rosemont <- readRDS('output/rosemont_canopy.rds')


# scatterplot data

scatt <- left_join(census, satellite, by = join_by(da == DAUID)) %>% 
  filter(mean_ndvi > -1 & mean_ndvi < 1) %>% 
  pivot_longer(cols = c(per_vismin, medinc, mean_ndvi), names_to = "independent", values_to = "values") %>% 
  select(c(da, mean_lst, independent, values))



# Scatterplots  -----------------------------------------------------------

scatter <- ggplot(data = scatt, aes(x = values, y = mean_lst)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_wrap(vars(independent), scales = "free_x") +
  labs(x = "", y = "Land Surface Temperature") +
  theme_classic()


# Maps --------------------------------------------------------------------

# three maps: Parc-Ex, Rosemont, Westmount


ggplot() + 
  geom_spatraster(data = westmount, aes(fill = `660_IndiceCanopee_2021`), 
                  na.rm = T, 
                  show.legend = F) + 
  scale_fill_continuous(na.value = NA)



