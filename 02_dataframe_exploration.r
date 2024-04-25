# This script contains examples of using dplyr, tidyr and ggplot. 
# One example based on the ChickWeight dataset. One example based on the iris dataset
# Both datasets are built in R. So you dont have to upload anything.

# To upload the .csv files.
# This can be done from the menu "Files". Click on the csv file and click on import. 

# Before running the code, make sure to activate the libraries by running these lines of code
# You can run a line of code by putting your cursor somwhere in the line and hit cmd + return for Mac
# For windows it is cntrl + enter. 

library(dplyr)
library(tidyr)
library(ggplot2)

##########################################################################################
# ChickWeight Example
##########################################################################################
# We use  split-apply-combine here on the ChickWeight dataset.
# First we split by Time and Diet using the function group_by(). Then we compute the mean and variance. 

ChickWeight %>% 
  group_by(Time,Diet) %>% 
  summarise(mean.weight = mean(weight), var.weight = var(weight))

# Notice that the outcome is only displayed on the console. 
# To store the outcome of this computation we need to assign it to a variable
# We create a dataframe here named df and store the result of the computation

df <- ChickWeight %>% 
  group_by(Time,Diet) %>% 
  summarise(mean.weight = mean(weight))

# We can plot the result of this computation. Notice that the result if not saved.
# The outcome is a visualisation which can be saved as an image
ChickWeight %>% 
  group_by(Time,Diet) %>% 
  summarise(mean.weight = mean(weight)) %>% 
  # Create an emply ggplot object
  ggplot()+
  #define the aestherics for the line geometry
  geom_line(aes(x = Time, y = mean.weight, color = Diet))+
  #save as a .png. You can choose other formats like .pdf, .svg and .jpeg
  ggsave("weight_per_diet_over_time.png")

# This plot does not include the variance. We can used the same code and add the variance.
# We have to add the variance to the summarise step first then add it to the plot
ChickWeight %>% 
  group_by(Time,Diet) %>% 
  # Here we create var.weight as the standard deviation (sd) in weight
  summarise(mean.weight = mean(weight), sd.weight = sd(weight)) %>% 
  # Create an emply ggplot object
  ggplot()+
  # Define the aestherics for the line geometry
  geom_line(aes(x = Time, y = mean.weight, color = Diet))+
  # Add a ribbon around the mean. The ribbons require ymin and ymax
  geom_ribbon(aes(x = Time, ymin = mean.weight - sd.weight, ymax = mean.weight + sd.weight, fill = Diet), alpha = 0.3)+
  #save as a .png. You can choose other formats like .pdf, .svg and .jpeg
  ggsave("weight_sd_per_diet_over_time.png")

# The plot is not easily readable. So lets facet it. Use the same code and add one line
ChickWeight %>% 
  group_by(Time,Diet) %>% 
  # Here we create var.weight as the standard deviation (sd) in weight
  summarise(mean.weight = mean(weight), sd.weight = sd(weight)) %>% 
  # Create an emply ggplot object
  ggplot()+
  # Define the aestherics for the line geometry
  geom_line(aes(x = Time, y = mean.weight, color = Diet))+
  # Add a ribbon around the mean. The ribbons require ymin and ymax
  geom_ribbon(aes(x = Time, ymin = mean.weight - sd.weight, ymax = mean.weight + sd.weight, fill = Diet), alpha = 0.3)+
  facet_wrap(~Diet)+
#save as a .png. You can choose other formats like .pdf, .svg and .jpeg
ggsave("weight_sd_per_diet_over_time_facet.png")

##########################################################################################
# Iris Example
##########################################################################################
# The iris dataset is about different types or flowers. There are three Species. For each four 
# different lengths of leaves are measured. 

# Have a look at the data
iris %>% View()

# We want to create a matrix with species on the x-axis and the four different measures on the y-axis
# So we have to transform the dataset to a table with three columns 
# One column with the species. One column with the measure. One column with the value
# For that we use the function gather() to convert the dataset from a wide format to a long format

df_iris <- iris %>%
  gather(key = "Measure", value = "Length", c("Sepal.Length","Sepal.Width","Petal.Length","Petal.Width"))

# What is happening here is the following
# Instead of having four columns, one for each measure, a key column named measure is created
# This column contains labels for the different measures. 
# The values are stored in a column named Length. 

# You can view the result here
df_iris %>% View()

# Now we can create a plot
df_iris %>% 
  # Do a simple analysis first
  group_by(Species, Measure) %>% 
  summarise(mean.length = mean(Length)) %>% 
  ggplot()+
  # Add geom_tile. This needs three values. In addition to x and y you need to choose a 
  # variable to fill the squares.
  # Notice that color = white adds a border around the squares
  geom_tile(aes(x = Species, y = Measure, fill = mean.length), color = "white", size = 1)+
  # This makes sure that the tiles are square. Looks nicer
  coord_equal()+
  # This reduces the plot to a minimal theme. Also nicer visually.
  theme_minimal()+
  ggsave("iris_heatmap.png")


# You can add the actual values to the plot by adding atext layer
df_iris %>% 
  group_by(Species, Measure) %>% 
  summarise(mean.length = mean(Length)) %>% 
  ggplot()+
  geom_tile(aes(x = Species, y = Measure, fill = mean.length), color = "white", size = 1)+
  # This adds the mean values to the squares. Notice that we use label to diplay the text
  geom_text(aes(x = Species, y = Measure, label = mean.length), color = "white")+
  coord_equal()+
  theme_minimal()+
  ggsave("iris_heatmap.png")

