# task 1
import pandas as pd
import matplotlib.pyplot as plt
df = pd.read_csv("/Users/kevinzhang/Downloads/adult_data (1).csv")

# task 2

plt.scatter(df["age"], df["hours-per-week"], alpha=0.5)

plt.xlabel("Age")
plt.ylabel("Hours/week")
plt.show()

# task 2 with heatmap

plt.hexbin(
    df["age"],
    df["hours-per-week"],
    gridsize=30,
    cmap="viridis"
)

plt.xlabel("Age")
plt.ylabel("Hours per Week")
plt.title("Age vs Hours per Week (Density Heatmap)")

plt.colorbar(label="Count")
plt.show()

# task 3 continuous v categorical box plot
df.boxplot(column="age", by="gross-income")

# Labels and title
plt.xlabel("Gross Income")
plt.ylabel("Age")
plt.title("Age Distribution by Gross Income")
plt.suptitle("")
plt.show()

# task 4 Categorical vs Categorical
# Group the data by 'gross-income' and 'education' and count occurrences
df["education"] = df["education"].astype(str).str.strip() # clean
df["gross-income"] = df["gross-income"].astype(str).str.strip() # clean
counts = (
    df.groupby(["education", "gross-income"])
      .size()
      .unstack(fill_value=0)
)

# Reindex education rows based on the correct order
correct_order = [
    "Preschool", "1st-4th", "5th-6th", "7th-8th", "9th", "10th", "11th",
    "12th", "HS-grad", "Some-college", "Assoc-voc", "Assoc-acdm",
    "Bachelors", "Masters", "Prof-school", "Doctorate"
]

counts = counts.reindex(correct_order)

# Create the stacked bar plot 
ax = counts.plot(kind="bar", stacked=True, figsize=(12, 6))

# Customize the plot
ax.set_xlabel("Education")
ax.set_ylabel("Count")
ax.set_title("Stacked Bar Plot of Gross Income by Education")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()

# Show the plot
plt.show()