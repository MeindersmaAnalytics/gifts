library(tidyverse)

# Number of gifts in the gift pool
gifts <- 1000

# Expected number of members that are gifting (or trying to gift)
members <- 1000

# Number of occasions to suggest a gift for
occasions <- 10

# How well should gifts fit the occasion to be eligible for recommendation?
x <- 0.5

# Sample size based on number of gifts and occasions and value of x
size <- round(gifts/occasions + sqrt(x)*(gifts/(occasions/(occasions-1))), 0)

# Define the required degree of similarity
similarity <- 0.2

# How many gifts are do we want to recommend?
gift_rec <- 8

# Create a dataframe for members with score reflecting their characteristics
df <- data.frame(member = rep(1:members, size),
                 gift = rep(1:size, each = members),
                 score_member = rep(rnorm(members), size),
                 score_gift = rep(rnorm(size), members)) %>%
  mutate(distance = abs(score_member - score_gift),
         recommended = (distance < similarity)*1)


df_plot <- df %>% group_by(member) %>% summarize(gifts = min(gift_rec, sum(recommended)))

hist(df_plot$gifts)
mean(df_plot$gifts==gift_rec)
