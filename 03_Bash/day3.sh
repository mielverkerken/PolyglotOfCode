#!/bin/bash

filename=$1
[ ! -f "$filename" ] && echo "$filename does not exist." && exit 1

declare -a lines

while IFS=$' \t\r\n' read line; do
    lines+=($line)
done < $filename

declare -a numbers=( $(for i in {1..${#lines[0]}}; do echo 0; done) )

for str in ${lines[@]}; do
    for (( i=0; i<${#str}; i++)); do
        [[ ${str:$i:1} == "1" ]] && numbers[$i]=$((numbers[$i]+1)) || numbers[$i]=$((numbers[$i]-1))
    done
done

for str in ${numbers[@]}; do
    if [[ $str -gt 0 ]] 
    then
        gamma+="1"
        epsilon+="0"
    else
        gamma+="0"
        epsilon+="1"
    fi
done

echo "Gamma: $((2#$gamma))"
echo "Epsilon: $((2#$epsilon))"
echo "Multiply: $(($((2#$gamma))*$((2#$epsilon))))"