!/bin/bash

# Define the path to the configurations.dat file
config_file="./configurations.dat"

# Define the source directory containing the conf*.gro files
source_dir="./windows_"

# Check if configurations.dat exists
if [[ ! -f "$config_file" ]]; then
  echo "Error: $config_file not found."
  exit 1
fi

# Check if the source directory exists
if [[ ! -d "$source_dir" ]]; then
  echo "Error: Source directory $source_dir not found."
  exit 1
fi

# Read each line from configurations.dat
while IFS=' ' read -r frame_number distance; do
  # Extract the integer part of the frame number
  int_frame_number=$(printf "%.0f" "$frame_number")

  # Construct the filename based on the integer frame number
  src_file="$source_dir/conf${int_frame_number}.gro"

  # Check if the source file exists
  if [[ -f "$src_file" ]]; then
    # Copy the file to the current directory
    cp "$src_file" .
    echo "Copied: $src_file"
  else
    echo "Warning: $src_file does not exist."
  fi
done < "$config_file"
