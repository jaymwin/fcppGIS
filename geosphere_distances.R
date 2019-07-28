
library(readxl)
library(geosphere)

dat <- read_excel(here('raw_data/all_kestrel_returns.xlsx'))
dat

dat <- dat %>%
  select(tmin, Bflyway, winter, sex, Blat, Blong, Elat, Elong, dist)
dat

# function to calc. distances
calculate_distances <- as_mapper(~distm(x = c(..6, ..5),
                                        y = c(..8, ..7),
                                        fun = distHaversine) / 1000)
# calculate with pmap_dbl
dat <- dat %>%
  mutate(
    distance = pmap_dbl(., calculate_distances)
  )
dat
