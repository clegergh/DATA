library(tidyverse)
library(nycflights13)

flights_gain <- flights |> 
  mutate(
    gain = dep_delay - arr_delay
  )

flights |> 
  select(where(is.character),
         tail_num =tailnum)