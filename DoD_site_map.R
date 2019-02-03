library(tidyverse)
library(here)
library(ggrepel)
here()

# load site lat/long
DoD_sites <- read_csv(here('DoD_sites_latlong.csv')) 
DoD_sites

# get base layer
states <- map_data('state')

# assign which sites are labeled where
top_labels <- c("Lucky Peak Dam", 
                "Dugway Proving Ground", 
                "White Sands Missile Range", 
                "Fort Hood", 
                "Fort Riley", 
                "Big Oaks NWR", 
                "Fort Drum",
                "Fort Bragg")

bottom_labels <- c("Yakima Training Center", 
                  "Camp Pendleton", 
                  "Eglin Air Force Base")

# plot it
ggplot() + 
  geom_polygon(data = states, aes(x=long, y = lat, group = group), colour = "grey", fill = "grey98", size=0.5) + 
  #geom_label_repel(data=DoD_sites %>% filter(site %in% top_labels), aes(lon, y=lat, label=site), 
  #                 force=5, label.size = 0.8, segment.size = 0, nudge_y = -.5, nudge_x = 0, segment.color=NA) +
  #geom_label_repel(data=DoD_sites %>% filter(site %in% bottom_labels), aes(x=lon, y=lat, label=site), 
  #                 force=5, label.size = 0.8, segment.size = 0, nudge_y = .5, nudge_x = 0, segment.color=NA) + 
  geom_point(data=DoD_sites, aes(x=lon, y=lat), fill='salmon', color='black', shape=21, size=3) +
  coord_quickmap() +
  theme_bw() + 
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank(),
        legend.position = 'none')

ggsave('C:/Users/jasonwiniarski/Desktop/fig_s3_site_map.png', plot=site_map, height=20, width=50, units = 'cm')

# need to add flyway colors, Alaska as inset map w/Wainwright

