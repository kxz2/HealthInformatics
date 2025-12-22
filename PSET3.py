# task 1
import numpy as np

array = np.arange(1, 11)

total_sum = array.sum()

max_value = array.max()
min_value = array.min()

print("Array:", array)
print("Sum:", total_sum)
print("Max:", max_value)
print("Min:", min_value)

# task 2

arr1 = np.array([1, 2, 3])
arr2 = np.array([4, 5, 6])

addition = arr1 + arr2
multiplication = arr1 * arr2
print("Add:", addition)
print("Multiply:", multiplication)

# task 3

import matplotlib.pyplot as plt

x = [1, 2, 3, 4, 5]
y = [1, 4, 9, 16, 25]

plt.plot(x, y)
plt.xlabel("X")
plt.ylabel("Y")
plt.show()

# task 4

fig, ax = plt.subplots()

letters = ['A', 'B', 'C', 'D']
counts = [10, 20, 15, 25]
bar_colors = ['tab:red', 'tab:blue', 'tab:green', 'tab:orange']

ax.bar(letters, counts, color=bar_colors)

ax.set_ylabel('Count')
ax.set_title('Letters and Counts')

plt.show()
