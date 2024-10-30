#!/bin/bash

# Prompt the user to input the filename with .xvg extension
read -p "Enter the filename with .xvg extension: " filename

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found!"
    exit 1
fi

# Prompt the user to input the column number to operate on
read -p "Enter the column number to perform the operation on (1-based index): " column_number

# Prompt the user to input the interval to add
read -p "Enter the interval to add (e.g., 0.1): " interval

# Remove lines starting with @ and #
filtered_file="filtered_${filename}"
grep -v '^[#@]' "$filename" > "$filtered_file"

# Initialize the value to search
current_value=$(awk -v col="$column_number" '{print $col}' "$filtered_file" | head -1)

# Initialize output file
output_file="output_${filename%.xvg}.dat"
echo -e "Frame\tValue" > "$output_file"

# Function to find the frame corresponding to the current value
function find_frame {
    local value=$1
    awk -v col="$column_number" -v val="$value" -v tolerance="0.01" '{
        diff = $col - val;
        if (diff < 0) diff = -diff;
        if (diff <= tolerance) {
            print $1, $col;
            exit;
        }
    }' "$filtered_file"
}

# Loop until there are no more frames to process
while true; do
    result=$(find_frame "$current_value")
    if [ -z "$result" ]; then
        echo "No more matches found."
        break
    fi

    # Write the frame number and value to the output file
    echo "$result" >> "$output_file"

    # Extract the new value from the specified column
    new_value=$(echo "$result" | awk '{print $2}')

    # Update the current value by adding the interval
    current_value=$(echo "$new_value + $interval" | bc)
done

echo "Results written to $output_file"
