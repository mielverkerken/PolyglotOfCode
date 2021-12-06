#!/bin/bash

filename=$1
# Print error if file does not exist
[ ! -f "$filename" ] && echo "$filename does not exist." && exit 1

declare -a lines

# Read file line by line; trim whitespace and newlines
while IFS=$' \t\r\n' read line; do
    lines+=($line)
done < $filename


# oxygen
# Loop through all bits; could stop earlier but not necessary 
oxygen=("${lines[@]}")
i=0
while [[ $i -lt ${#lines[0]} && ${#oxygen[@]} -gt 1 ]]; do
    echo "$i"
    printf '%s' "${oxygen[*]}"
    echo
    count=0
    # Count for most common bit (0 or 1)
    for str in ${oxygen[@]}; do
        [[ ${str:$i:1} == "1" ]] && count=$((count + 1)) || count=$((count - 1))
    done
    # Save most common to variable
    [[ $count -ge 0 ]] && bit="1" || bit="0"
    # Filter lines based on most common bit
    for j in "${!oxygen[@]}"; do
        if [[ ${oxygen[j]:$i:1} != $bit ]]; then
            unset -v 'oxygen[j]'
        fi
    done
    ((i++))
done

# Co2
# Loop through all bits; could stop earlier but not necessary 
co=("${lines[@]}")
i=0
while [[ $i -lt ${#lines[0]} && ${#co[@]} -gt 1 ]]; do
    echo
    count=0
    # Count for most common bit (0 or 1)
    for str in ${co[@]}; do
        [[ ${str:$i:1} == "1" ]] && count=$((count + 1)) || count=$((count - 1))
    done
    # Save least common to variable
    [[ $count -ge 0 ]] && bit="0" || bit="1"

    echo "index: $i   bit: $bit"
    printf '%s' "${co[*]}"
    echo
    # Filter lines based on most common bit
    for j in "${!co[@]}"; do
        if [[ ${co[j]:$i:1} != $bit ]]; then
            unset -v 'co[j]'
        fi
    done
    ((i++))
done

oxygen=("${oxygen[@]}")
oxygen=$((2#${oxygen[0]}))
echo $oxygen

co=("${co[@]}")
co=$((2#${co[0]}))
echo $co

echo "oxygen: $oxygen"
echo "co: $co"
echo "Multiply: $(($oxygen*$co))"