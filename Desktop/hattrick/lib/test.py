def find_percentage(part, whole):
    if whole == 0:
        return None  # Avoid division by zero
    return (part / whole) * 100

result = find_percentage(103, 120)
if result is not None:
    print(f"{103} is {result}% of {120}")
else:
    print("Cannot calculate percentage when the denominator is zero.")
