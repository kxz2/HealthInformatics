# task 1: Write a function that converts lbs to kg.
lbs_to_kg <- function(lbs) {
  lbs * 0.453592
}
# task 2: Write a function that converts inches to meters.
in_to_m <- function(inches) {
  inches * 0.0254
}
# task 3: Write a function that takes a weight in lbs and a height in inches and returns BMI. Use the functions you made in the last two tasks.
bmi <- function(weight_lbs, height_in) {
  weight_kg <- lbs_to_kg(weight_lbs)
  height_m <- in_to_m(height_in)
  weight_kg / (height_m^2)
}


# Task 4 Convert these weights to kg and print the list using a for loop.
weights_lbs <- c(145, 123, 174, 109, 182, 213)
weights_kgs <- numeric(length(weights_lbs))

for (weight in weights_lbs) {
  print(lbs_to_kg(weight))
}

# Write a function that takes in a patient's temperature in ºF and prints:

# "no fever" if temperature < 99.1
# "low-grade fever" if temperature 99.1-100.4
# "moderate-grade fever" if temperature 100.5-102.2
# "high-grade fever" if temperature 102.3-105.8
# "hyperthermia" if tempeature > 105.8

temp_algorithm <- function(temp) {
  if (temp < 99.1) {
      print("no fever")
  } else if (temp >= 99.1 && temp <= 100.4) {
      print("low-grade fever")
  } else if (temp >= 100.5 && temp <= 102.2) {
    print("moderate-grade fever")
  } else if (temp >= 102.3 && temp <= 105.8) {
    print("high-grade fever")
  } else {
    print("hyperthermia")
  }
}

