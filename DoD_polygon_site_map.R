
library(tidyverse)
library(rgdal)
library(here)


DoD_sites <- readOGR(here(), 'DoD_site_polygon')

DoD_sites <- fortify(DoD_sites, region="SITE_NAME")

big_oaks <- readOGR(here(), 'big_oaks_nwr')
big_oaks <- fortify(big_oaks, region="LABELNAME")

big_oaks <- big_oaks %>%
  as.tibble()
big_oaks

DoD_sites <- DoD_sites %>%
  as.tibble()

DoD_sites <- rbind(DoD_sites, big_oaks)

unique(DoD_sites$id)

DoD_sites <- DoD_sites %>%
  filter(id %in% c("White Sands Missile Range", "Fort Bragg", "Fort Drum", "Eglin AFB",
                   "Fort Hood", "MCB Camp Pendleton", "Fort Riley", "Fort Wainwright",
                   "Yakima Training Center", "Dugway Proving Ground", "Big Oaks NWR", 'Minot AFB'))


USA <- map_data("usa")
  
ggplot() +
  geom_polygon(data=USA, aes(long,lat,group=group), color=NA, fill='gainsboro') +
  geom_polygon(data=DoD_sites, aes(long,lat,group=group), fill="purple", color=NA) +
  theme_bw() +
  theme(legend.position = 'none') +
  coord_map()
