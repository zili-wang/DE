# This is a comment

# Creating variables
a <- 2
b <- 3
c <- a + b


# Sequences
a <- seq(from = 0, to = 10, by = 1)

# Repeating values
a <- rep(1,10)

# Concatenates numbers
a <- c(1,3,6,5,10)

# Text
a <- "Today Is A Nice Day"

b <- toupper(a)
b <- tolower(a)

# Dataframes
a <- seq(from = 1, to = 100, by = 1)
b <- seq(from = 0.1, to = 10, by = 0.1)
c <- a+b +sqrt(a)+b^2

# Combine into a dataframe
df <- data.frame(a,b,c)

# Summary
summary(df)

# Summary plot
plot(df)


# Create a dataframe based on variables that you create. The data frame
# Create four columns.
a <- seq(from = 1, to = 100, by = 1)
b <- rep (1, 100)
c <- c(a,b)
d <- sqrt(c)
df <- data.frame(a,b,c,d)
colnames(df) <- c('col1','col2','col3','col4')

# Read r data in df
df <- ChickWeight

# Summary 
summary(df)

# Visual summary
plot(df)

# Install packages using code
# install.packages('tidyverse')

# Activating a library
library(tidyverse)

# Pipe
sin(cos(log(sin(2))))

# Same operations chained after each other instead of nested
2 %>% 
  sin() %>% 
  log() %>% 
  cos() %>% 
  log() %>% 
  sin()

# Split - Apply - Combine
df %>% 
  group_by(Chick) %>% 
  summarise(m.weight = mean(weight)) -> df_2


# Mean and Sd per chicken
df %>% 
  group_by(Chick) %>% 
  summarise(m.weight = mean(weight), sd.weight = sd(weight)) -> df_2

# Mean and Sd per Diet
df %>% 
  group_by(Diet) %>% 
  summarise(m.weight = mean(weight), 
            sd.weight = sd(weight),
            min.weight = min(weight),
            max.weight = max(weight)) -> df_3

# Filter
df %>% 
  filter(weight > 50 | Time > 10) %>% View()

# Select
df %>% 
  select(weight,Time) %>% View()

#df <- read.csv('TopBabyNamesbyState.csv')

# ggplot
df <- ChickWeight

# Scatter plot
df %>% 
  ggplot()+
  geom_point(aes(x = Time, y = weight),alpha = 0.3)

# Line plot for each chicken
df %>% 
  ggplot()+
  geom_line(aes(x = Time, y = weight, group = Chick), alpha = 0.4)


# Manipulate the dataset using max()
df %>% 
  group_by(Chick) %>% 
  mutate(max.days = max(Time)) %>%
  filter(max.days == max(df$Time)) %>%
  select(-max.days) %>% 
  ggplot() + 
  # geom_point(aes(x = Time, y = weight, alpha = 0.4)) +
  geom_line(aes(x = Time, y = weight, group = Chick), alpha = 0.4)

# Notes - Aading layers
df %>% 
  ggplot() + 
  geom_point(aes(x = Time, y = weight), alpha = 0.4) +
  geom_line(aes(x = Time, y = weight, group = Chick), alpha = 0.4)

# Notes - Using color icw group
df %>% 
  ggplot() + 
  geom_line(aes(x = Time, y = weight, group = Chick, color= Diet), alpha = 0.4)

# Plot data 
df %>% 
  # Filter out chickens that die early on
  group_by(Chick) %>% 
  mutate(max.days = max(Time)) %>%
  filter(max.days == max(df$Time)) %>%
  select(-max.days) %>% 
  # Compute the average weight per diet at each time
  group_by(Time,Diet) %>% 
  summarise(m.weight = mean(weight), sd.weight = sd(weight)) %>%
  # PLot the average and sd weight over time
  ggplot()+
  geom_line(aes(x = Time, y = m.weight))+
  geom_ribbon(aes(x = Time, ymin = m.weight - sd.weight, ymax = m.weight + sd.weight), alpha = 0.3)+
  facet_wrap(~Diet)
ggsave('weight_over_time.png')

# Discontinous version
df %>% 
  # Filter out chickens that die early on
  group_by(Chick) %>% 
  mutate(max.days = max(Time)) %>%
  filter(max.days == max(df$Time)) %>%
  select(-max.days) %>% 
  # Compute the average weight per diet at each time
  group_by(Time,Diet) %>% 
  summarise(m.weight = mean(weight), sd.weight = sd(weight)) %>%
  # PLot the average and sd weight over time
  ggplot()+
  geom_point(aes(x = Time, y = m.weight))+
  geom_errorbar(aes(x = Time, ymin = m.weight - sd.weight, ymax = m.weight + sd.weight), alpha = 0.6)+
  facet_wrap(~Diet)
ggsave('weight_over_time.png')


