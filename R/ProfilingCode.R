# The RStudio IDE includes integrated support for profiling with profvis. These features are available in the current Preview Release of RStudio.

# Below is an example of profvis in use. The code creates a scatter plot of the diamonds data set, which has about 54,000 rows, 
# fits a linear model, and draws a line for the model. (The plot isn’t displayed in this document, though.) If you copy and 
# paste this code into your R console, it’ll open a window with the same profvis interface that you see in this HTML document.

install.packages("profvis")


library(profvis)

profvis({
  data(diamonds, package = "ggplot2")

  plot(price ~ carat, data = diamonds)
  m <- lm(price ~ carat, data = diamonds)
  abline(m, col = "red")
})