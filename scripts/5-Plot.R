#======= Script to plot data


# Prep --------------------------------------------------------------------

source('R/packages.R')
source('R/plot_map.R')
source('R/calc_nhoods.R')

# cleaned data
census <- readRDS('output/census.rds')
satellite <- readRDS('output/satellite.rds')

westmount <- readRDS('output/westmount_canopy.rds')
parcex <- readRDS('output/parcex_canopy.rds')
rosemont <- readRDS('output/rosemont_canopy.rds')

arrond <- readRDS('output/arrondissements.rds')
quartiers <- readRDS('output/quartiers.rds')


# scatterplot data

scatt <- left_join(census, satellite, by = join_by(da == DAUID)) %>% 
  filter(mean_ndvi > -1 & mean_ndvi < 1) %>% 
  pivot_longer(cols = c(per_vismin, medinc, mean_ndvi), names_to = "independent", values_to = "values") %>% 
  select(c(da, mean_lst, independent, values))

scatt_nhoods <- calc_nhoods(arrond, quartiers, census, satellite)

# Scatterplots  -----------------------------------------------------------

# New facet label names for supp variable
supp.labs <- c("Mean NDVI", "Median Income", "Visible Minorities (%)")
names(supp.labs) <- c("mean_ndvi", "medinc", "per_vismin")


scatter <- ggplot(data = scatt, aes(x = values, y = mean_lst)) + 
  geom_point(colour = 'gray10', alpha = 0.5) + 
  geom_point(data = scatt_nhoods, aes(colour = NOM), alpha = 0.5) + 
  geom_smooth( method = "lm") + 
  facet_wrap(vars(independent), 
             scales = "free_x",
             strip.position = "bottom",
             labeller = labeller(independent = supp.labs)) +
  labs(x = "", y = "Land Surface Temperature (\u00B0C)", colour = "") + 
  scale_colour_manual(values = c("goldenrod", "navyblue")) + 
  theme_classic() + 
  theme(strip.placement = 'outside',
        strip.background = element_blank(),
        axis.text = element_text(size = 11, color = 'black'),
        strip.text = element_text(size = 11, color = 'black'),
        legend.position = 'top',
        legend.text = element_text(size = 11))


# Maps --------------------------------------------------------------------

# three maps: Parc-Ex, Rosemont, Westmount

w <- plot_map(westmount, arrond, "navyblue", angle = 55, 
              xmin = 500, xmax = 500, ymin = 600, ymax = 300) +
  ggtitle('Westmount: 36% canopy cover, median income $42,500')

pe <- plot_map(parcex, quartiers, "goldenrod", 70, 
               xmin = 450, xmax = 300, ymin = 100, ymax = 100) +
  ggtitle('Parc-Extension: 13% canopy cover, median income $30,300')



# Full --------------------------------------------------------------------

f <- scatter / (w + pe + plot_layout(widths = c(1, 1)))

ggsave('graphics/draft.png', f, width = 12, height = 10, units = 'in')
