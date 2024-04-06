# Function to read values from file and return as a list
def read_values_from_file(filename):
    with open(filename, 'r') as file:
        values = file.readline().split(',')
        # Convert values to integers
        values = [int(val.strip()) for val in values]
    return values

# Function to compare two lists of values and count non-matching numbers
def count_non_matching_values(values1, values2):
    non_matching_count = 0
    for val1, val2 in zip(values1, values2):
        if val1 != val2:
            non_matching_count += 1
    return non_matching_count

# Main function
def main():
    # Read values from both files
    conv_scc_out_values = read_values_from_file("../src/conv_acc_out.txt")
    ofm_values = read_values_from_file("ofm.txt")

    # Compare values and count non-matching numbers
    non_matching_count = count_non_matching_values(conv_scc_out_values, ofm_values)

    # Output the result
    print("Number of non-matching values:", non_matching_count)

if __name__ == "__main__":
    main()

