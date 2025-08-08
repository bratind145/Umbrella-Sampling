#!/bin/bash

# Set output filenames
tpr_output="tpr-files.dat"
pullf_output="pullf-files.dat"

# Gather and sort .tpr files
printf "%s\n" md-um*.tpr | sort > "$tpr_output"

# Gather and sort _pullf.xvg files
printf "%s\n" md-um*_pullf.xvg | sort > "$pullf_output"

echo "Sorted filenames written to $tpr_output and $pullf_output."
