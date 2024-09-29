#!/bin/bash




potential_files_dir="/home/labuser/snap/snapd-desktop-integration/current/potential_files"

input_file="../input.txt"

data="../LP_data.csv"


echo "Potential File,Element,Dimensions,Lattice Parameter (in Å), Cohesive Energy" >> "./LP_data.csv"

for potential_file in "$potential_files_dir"/*; do
    

    
    potential_filename=$(basename "$potential_file")
    dir_name="${potential_filename%.*}"
    mkdir -p "$dir_name"
    
    cd "$dir_name"
    
    cp "$input_file" .
   
    #cp "$potential_file" .
    sed -i "s|^pair_coeff \* \* [^ ]*|pair_coeff * * $potential_file|" "input.txt"
    
    lmp -in input.txt
    
    
    potential_file=$(grep "pair_coeff" "log.lammps" | awk '{print $4}')
    elements="Fe"
    
    cohesive_energy=$(grep "cohesive energy" "log.lammps" | awk '{print $NF}' | grep -E '^[+-]?[0-9]*[.]?[0-9]+$')
    lattice_parameter=$(grep "lp equals" "log.lammps" | awk '{print $NF}' | grep -E '^[+-]?[0-9]*[.]?[0-9]+$')
    
    box_size=$(grep "side_dimension" "log.lammps" | awk '{print $NF}' | grep -E '^[+-]?[0-9]*[.]?[0-9]+$')
    echo "$potential_filename,$elements,$box_size,$lattice_parameter,$cohesive_energy" >> "$data"
    cd ..
    
    
  done