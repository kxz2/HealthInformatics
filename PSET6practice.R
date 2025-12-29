# Lecture 6 PSET (R version) Kevin Zhang
library(tidyverse)
library(lubridate) 
library(broom)
library(dplyr)
library(ggplot2)

# Load data, change based on ur file
admissions_path <- "/Users/kevinzhang/Downloads/ADMISSIONS.csv"
icd_path        <- "/Users/kevinzhang/Downloads/DIAGNOSES_ICD.csv"

admissions_data <- readr::read_csv(admissions_path, show_col_types = FALSE)
icd_data        <- readr::read_csv(icd_path, show_col_types = FALSE)

cat("ADMISSIONS:", nrow(admissions_data), "rows,", ncol(admissions_data), "cols\n")
cat("DIAGNOSES_ICD:", nrow(icd_data), "rows,", ncol(icd_data), "cols\n")

dim(admissions_data)
# 129 22
dim(icd_data)
# 1761 5

# merge on subject_id only
data <- admissions_data %>%
  left_join(
    icd_data,
    by = "subject_id",
    relationship = "many-to-many",
    suffix = c("_admit", "_icd")
  )
# percent missing cell
missing_frac <- sum(is.na(data)) / (nrow(data) * ncol(data))
missing_frac
# 0.05292339. not a bunch of nans, which is cool. 94.5% of cells have good values.

# value counts
data %>%
  count(admission_type, sort = TRUE)
# Emergency 5841, elective 93, urgent 18

# task 1.1 summarize 3 categories

task_1_1 <- function(admissions_data) {
  summaries <- list(
    language = sort(table(admissions_data$language, useNA = "ifany"), decreasing = TRUE),
    marital_status = sort(table(admissions_data$marital_status, useNA = "ifany"), decreasing = TRUE),
    religion = sort(table(admissions_data$religion, useNA = "ifany"), decreasing = TRUE)
  )
  return(summaries)
}

summaries <- task_1_1(admissions_data)

summaries$religion
summaries$language
summaries$marital_status

# task 1.2 create 2 new variables

admissions_data <- admissions_data %>%
  mutate(
    length_of_hospital_stay = as.numeric(difftime(dischtime, admittime, units = "days")),
    .ed_raw = as.numeric(difftime(edouttime, edregtime, units = "days")),
    has_true_ed_duration = !is.na(.ed_raw),
    length_of_ed_stay = if_else(is.na(.ed_raw), length_of_hospital_stay, .ed_raw)
  ) %>%
  select(-.ed_raw)

#plot the density of length ed stay

ggplot(admissions_data, aes(x = length_of_ed_stay)) +
  geom_density(na.rm = TRUE) +
  coord_cartesian(xlim = c(-5, NA)) +
  labs(
    title = "Density of length_of_ed_stay",
    x = "length_of_ed_stay (days)",
    y = "Density"
  ) +
  theme_minimal()

# consider the absence of ed registration data

# missing ED registration time
missing_ed_reg <- mean(is.na(data$edregtime))
missing_ed_reg

# Proportion missing ED out time
missing_ed_out <- mean(is.na(data$edouttime))
missing_ed_out

# proportion of admit type
admission_type_props <- data %>%
  count(admission_type) %>%
  mutate(prop = n / nrow(data)) %>%
  arrange(desc(prop))

admission_type_props
# gets same output as in google assgt

# just adding the has_true_ed_duration to my 'data' variable
data <- data %>%
  mutate(
    has_true_ed_duration = !is.na(as.numeric(difftime(edouttime, edregtime, units = "days")))
  )

# how many we're missing
missing_true_ed_in_emergency <- data %>%
  filter(admission_type == "EMERGENCY") %>%
  summarise(missing = sum(!.data$has_true_ed_duration, na.rm = TRUE)) %>%
  pull(missing)

missing_true_ed_in_emergency
# 538

# fixing code____
data <- data %>%
  mutate(
    length_of_hospital_stay = as.numeric(difftime(dischtime, admittime, units = "days")),
    .ed_raw = as.numeric(difftime(edouttime, edregtime, units = "days")),
    length_of_ed_stay = if_else(is.na(.ed_raw), length_of_hospital_stay, .ed_raw)
  ) %>%
  select(-.ed_raw)
# ________##

los_summary <- data %>%
  summarise(
    # length_of_ed_stay
    ed_n = sum(!is.na(length_of_ed_stay)),
    ed_missing = sum(is.na(length_of_ed_stay)),
    ed_mean = mean(length_of_ed_stay, na.rm = TRUE),
    ed_sd = sd(length_of_ed_stay, na.rm = TRUE),
    ed_min = min(length_of_ed_stay, na.rm = TRUE),
    ed_q25 = quantile(length_of_ed_stay, 0.25, na.rm = TRUE),
    ed_median = median(length_of_ed_stay, na.rm = TRUE),
    ed_q75 = quantile(length_of_ed_stay, 0.75, na.rm = TRUE),
    ed_max = max(length_of_ed_stay, na.rm = TRUE),
    
    # length_of_hospital_stay
    hosp_n = sum(!is.na(length_of_hospital_stay)),
    hosp_missing = sum(is.na(length_of_hospital_stay)),
    hosp_mean = mean(length_of_hospital_stay, na.rm = TRUE),
    hosp_sd = sd(length_of_hospital_stay, na.rm = TRUE),
    hosp_min = min(length_of_hospital_stay, na.rm = TRUE),
    hosp_q25 = quantile(length_of_hospital_stay, 0.25, na.rm = TRUE),
    hosp_median = median(length_of_hospital_stay, na.rm = TRUE),
    hosp_q75 = quantile(length_of_hospital_stay, 0.75, na.rm = TRUE),
    hosp_max = max(length_of_hospital_stay, na.rm = TRUE)
  )

los_summary
# above is brute force base R way to get data like Python
# this is a more elegant way
library(psych)

psych::describe(data[, c("length_of_ed_stay", "length_of_hospital_stay")])

# task 1.4 

ggplot(data, aes(x = length_of_ed_stay, y = length_of_hospital_stay)) +
  geom_point(alpha = 0.1, size = 1, na.rm = TRUE) +
  labs(
    x = "Length of ED Stay",
    y = "Length of Hospital Stay"
  ) +
  theme_minimal()

# task 2

# task 2.1 : V5867 is current/long-term insulin use
# 
#2.1 parse into major and minor icd codes
data <- data %>%
  mutate(
    icd9_code = as.character(icd9_code),
    icd_major_code = substr(icd9_code, 1, 3),
    icd_minor_code = substr(icd9_code, 4, nchar(icd9_code))
  )

# bar plot
plot_df <- data %>%
  filter(!is.na(icd_major_code)) %>%
  filter(dplyr::between(icd_major_code, "190", "290")) %>%
  count(icd_major_code, sort = TRUE)

ggplot(plot_df, aes(x = reorder(icd_major_code, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "icd_major_code",
    y = "Count",
    title = "ICD9 Major Codes (190–290)"
  ) +
  theme_minimal()

# filter by 276; Disorders of fluid, electrolyte, and acid-base balance
analyte <- data %>%
  filter(icd_major_code == "276")

dim(analyte)   # 260 26; Disorders of fluid, electrolyte, and acid-base balance

# task 3 conduct analysis

non_analytic_columns <- c("hadm_id_admit", "row_id_admit", "subject_id",
                          "row_id_icd", "hadm_id_icd", "seq_num")

stuff_we_care_about <- analyte %>%
  select(-all_of(intersect(non_analytic_columns, names(analyte))))

psych::describe(analyte_slim %>% select(where(is.numeric)))

analyte <- analyte %>%
  mutate(
    # Hospital LOS (days)
    length_of_hospital_stay = as.numeric(difftime(dischtime, admittime, units = "days")),
    
    # ED LOS raw (days)
    .ed_raw = as.numeric(difftime(edouttime, edregtime, units = "days")),
    
    # Coerce = TRUE: fill missing ED LOS with hospital LOS
    length_of_ed_stay = if_else(is.na(.ed_raw), length_of_hospital_stay, .ed_raw)
  ) %>%
  select(-.ed_raw)

df <- analyte %>%
  transmute(
    hospital_expire_flag = as.integer(hospital_expire_flag),
    length_of_ed_stay = as.numeric(length_of_ed_stay),
    length_of_hospital_stay = as.numeric(length_of_hospital_stay),
    insurance = as.character(insurance),
    ethnicity = as.character(ethnicity)
  )

# Question 1: In our data, how fatal is disorders of fluid (276)
analyte %>%
  count(discharge_location, sort = TRUE)
percent_deceased <- mean(!is.na(analyte$deathtime))
cat(sprintf("Deceased: %.2f%%\n", percent_deceased * 100)) # to get the nice output 13.85%

# question 1.1 Is mortality predicted by length of stay?

ggplot(analyte, aes(x = factor(hospital_expire_flag), y = length_of_hospital_stay)) +
  geom_jitter(width = 0.15, alpha = 0.6, na.rm = TRUE) +
  labs(
    x = "Hospital Expire Flag",
    y = "Length of Hospital Stay",
    title = "Hospital Expire Flag vs. Length of Hospital Stay"
  ) +
  theme_minimal()


ggplot(analyte, aes(x = factor(hospital_expire_flag), y = length_of_ed_stay)) +
  geom_jitter(width = 0.15, alpha = 0.6, na.rm = TRUE) +
  labs(
    x = "Hospital Expire Flag",
    y = "Length of ED Stay",
    title = "Hospital Expire Flag vs. Length of ED Stay"
  ) +
  theme_minimal()
analyte %>%
  count(icd_minor_code, sort = TRUE) # most common is icd 276.0 hyperosmolality and/or hypernatremia

fit1_1a <- lm(hospital_expire_flag ~ length_of_hospital_stay, data = analyte)
anova(fit1_1a)
# hospital stay is barely statistically significant p < 0.05, (0.04997); 

fit1_1b <- lm(hospital_expire_flag ~ length_of_ed_stay, data = analyte)
anova(fit1_1b)
# ed stay is not statistically significant p > 0.05
fit_lm <- lm(hospital_expire_flag ~ factor(admission_type), data = analyte)
anova(fit_lm)
# Given that most of the data is ED, is there anything interesting to see from the other admission types? Anything predictive towards adverse outcomes?
# no!  P > 0.05

analyte %>%
  count(admission_type, sort = TRUE)
# 257 emergency 3 elective

