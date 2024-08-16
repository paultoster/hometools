str1 = """

a = 3
b = 6
res = a + b

print(res)
"""

print("The output of the code present in the string is ")
exec(str1)
print(f"a={a:8.2f}")
print(f"b={b:8.3f}")