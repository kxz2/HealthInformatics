# Task 1: Variable Declaration
# Declare variables of different data types as specified below.

# Declare an integer variable named 'num_students' and set its value to 30.
num_students = 30
# Declare a floating-point variable named 'average_score' and set its value to 85.5.
average_score = 85.5
# Declare a string variable named 'student_name' and set its value to 'John Doe'.
student_name = "John Doe"
# Declare a boolean variable named 'is_passing' and set its value to False.
is_passing = False

# Task 2
print("There are", num_students, "students in the class.")
print("The average score is", average_score, ".")
print("Student name:", student_name)
print("Passing status:", is_passing)
print_finished = True

# Task 3
original_price = 50
discount_percent = 0.25
discounted_price = original_price - (original_price * discount_percent)
# discounted_price = 0

#*******************CODE CHECKER ***************************************************************************
problems_completed = []
try:
	num_students
	average_score
	student_name
	is_passing
	assert(num_students == 30)
	assert(average_score == 85.5)
	assert(student_name != "")
	assert(is_passing == False)
	problems_completed.append(1)
	print_finished
	if (print_finished == True):
		problems_completed.append(2)
	discounted_price
	if (discounted_price == (50-50*0.25)):
		problems_completed.append(3)
except NameError:
	pass

print('You\'ve finished the following tasks: ' + str(problems_completed))
if (len(problems_completed) == 3):
	print('Nice work! You\'ve finished the first in class assignment.')
