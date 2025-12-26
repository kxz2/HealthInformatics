library(tidyverse)
# downloaded locally
nhanes <- read_csv("/Users/kevinzhang/Downloads/NHANES.csv")
head(nhanes)

# use .info() to summarize details about column names, number of rows, 
# there's no .info for R so i can use glimpse
glimpse(nhanes)

# drop rows where either 'TotChol' or 'BMI_WHO' is null
nhanes_clean <- nhanes %>%
  mutate(
    BMI_WHO = na_if(BMI_WHO, "NA"),
    BMI_WHO = na_if(BMI_WHO, ""),
    BMI_WHO = na_if(BMI_WHO, " ")
  ) %>%
  drop_na(TotChol, BMI_WHO)
# this was the best way to do it because # nhanes_clean <- nhanes %>%
# # drop_na(TotChol, BMI_WHO) did not work

## provide the count, mean, standard deviation, minimum, maximum, median, 1st and 3rd quartilies for the 'TotChol' (total cholesterol) column
nhanes_clean %>%
  summarise(
    count   = n(),
    mean    = mean(TotChol, na.rm = TRUE),
    sd      = sd(TotChol, na.rm = TRUE),
    min     = min(TotChol, na.rm = TRUE),
    q1      = quantile(TotChol, 0.25, na.rm = TRUE),
    median  = median(TotChol, na.rm = TRUE),
    q3      = quantile(TotChol, 0.75, na.rm = TRUE),
    max     = max(TotChol, na.rm = TRUE)
  )

# obtain the unique values in the 'BMI_WHO' column and the frequencies for each
bmi_freq <- nhanes %>%
  count(BMI_WHO, sort = TRUE)

bmi_freq
unique(nhanes$BMI_WHO)

# create a boxplot of total cholesterol grouped by BMI category using TWO different data visualization libraries of your choice
# (i.e., each BMI category should have its own boxplot for total cholesterol)

# (1) boxplot code here using ggplot2

library(ggplot2)

ggplot(nhanes, aes(x = BMI_WHO, y = TotChol)) +
  geom_boxplot() +
  labs(
    title = "Total Cholesterol by BMI Category (BMI_WHO)",
    x = "BMI Category (BMI_WHO)",
    y = "Total Cholesterol (TotChol)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# (2) create the same boxplot using a different visualization library
# base R

boxplot(
  TotChol ~ BMI_WHO,
  data = nhanes,
  main = "Total Cholesterol by BMI Category (BMI_WHO)",
  xlab = "BMI Category (BMI_WHO)",
  ylab = "Total Cholesterol (TotChol)"
)

# run your ANOVA code here

anova <- aov(TotChol ~ BMI_WHO, data = nhanes)

summary(anova)