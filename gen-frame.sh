#!/bin/bash

# Path to the configuration.gro file containing frame numbers in the first column
config_file="configure.dat"

# Path to the template .sh file
template_file="frame-sample.sh"

# Directory to save the generated .sh files
output_dir="generated_scripts"

# Create the output directory if it doesn't exist
mkdir -p $output_dir

# Read each frame number from the first column of the configuration.gro file
awk '{printf "%d\n", $1}' "$config_file" | while IFS= read -r frame_number; do
  # Define the output .sh file name
  output_file="$output_dir/frame-$frame_number.sh"

  # Replace XXXX with the current frame number and save to the output file
  sed "s/XXXX/$frame_number/g" "$template_file" > "$output_file"

  # Make the generated script executable
  chmod +x "$output_file"

  echo "Generated script: $output_file"
done
