library(tidyverse)
library(nycflights13)

flights_gain <- flights |> 
  mutate(
    gain = dep_delay - arr_delay
  )

flights |> 
  select(where(is.character),
         tail_num =tailnum)

arrange(mutate(filter(flights, dest == "DSM"), speed = distance / air_time * 60), desc(speed))

flights_avg_delay <- flights |> 
  group_by(dest) |> 
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE))
View(flights_avg_delay)