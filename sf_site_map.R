
library(sf)
library(albersusa)
library(sp)
library(tidyverse)
library(RColorBrewer)
library(here)

dod <- read_csv('https://raw.githubusercontent.com/jaymwin/fcpp_GIS/master/data/DoD_sites_latlong.csv')

dod_ak <- dod

coordinates(dod_ak) <- ~lon + lat
proj4string(dod_ak) = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
dod_ak <- as.data.frame(points_elided(dod_ak)) %>%
  rename(lon = x, lat = y)
dod_ak

dod <- dod %>%
  filter(site != 'Fort Wainwright')

usa <- usa_sf() %>%
  filter(name != 'Hawaii')

# by flyway ---------------------------------------------------------------

dod2 <- dod %>%
  mutate(
    flyway = case_when(
      site %in% c('Big Oaks NWR', 'Fort Bragg', 'Eglin Air Force Base',
                  'Fort Drum') ~ 'Eastern',
      site %in% c('Fort Riley', 'White Sands Missile Range', 
                  'Minot AFB', 'Fort Hood') ~ 'Central',
      TRUE ~ 'Western'
    )
  )

dod3 <- dod2 %>% 
  st_as_sf(coords = c("lon", "lat"))
dod3 <- st_set_crs(dod3, 4326)
st_is_longlat(dod3)

dod3 <- st_transform(dod3, "+proj=aea +lat_1=25 +lat_2=50 +lon_0=-100")

# by flyway
ggplot() +
  geom_sf(data = usa, fill = 'grey95') +
  geom_sf(data = dod3, aes(color = flyway), size = 3, show.legend = "point") +
  scale_color_viridis_d(end=0.8) +
  labs(
    x = 'Longitude',
    y = 'Latitude'
  ) +
  theme_minimal() + coord_sf(crs = "+proj=aea +lat_1=25 +lat_2=50 +lon_0=-100")

ggsave(here('map.png'), height = 4, width = 6, units = 'in', dpi = 600)

# by site ID
ggplot() +
  geom_sf(data = usa, fill = 'grey95') +
  geom_sf(data = dod3, aes(color = site), size = 4, show.legend = "point") +
  geom_sf(data = dod3, aes(shape = site), color = 'white', size = 2, show.legend = "point") +
  scale_color_manual(values = c(rep('tomato', 13)), name = 'Site') +
  scale_shape_manual(values = c(LETTERS[seq(from = 1, to = 13)]), name = 'Site') +
  labs(
    x = 'Longitude',
    y = 'Latitude'
  ) +
  theme_minimal() + coord_sf(crs = "+proj=aea +lat_1=25 +lat_2=50 +lon_0=-100")

ggsave(here('map.png'), height = 4, width = 6, units = 'in', dpi = 600)

