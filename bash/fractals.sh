#!/bin/bash

print_single_line() {
    positions=$1

    line=$(yes '_' | tr -d '\n' | head -c 100)
    IFS=',' read -ra indices <<< "$positions"
    for index in "${indices[@]}"
    do
        line=${line:0:index}1${line:index+1}
    done

    echo $line
}

determine_positions() {
    local index=$1
    local current_height=$2
    local positions
    
    if [[ $current_height -lt $(( current_tree_height / 2 )) ]]
    then
        echo $current_root_positions
	return
    fi
    
    IFS=',' read -ra roots_array <<< "$current_root_positions"
    for root in "${roots_array[@]}"
    do
	left=$((root - current_height + current_tree_height / 2 - 1))
	right=$((root + current_height - current_tree_height / 2 + 1))
	positions+=$(echo "${left},${right},")
    done
    
    [[ ${positions: -1} == "," ]] && positions=${positions::-1}

    echo $positions
}

get_root_positions() {
    fractals_length=${#fractals[@]}
    local index=$(( fractals_length - 1 ))

    echo "${fractals[index]}"
}

## Execution

read -p "Number of iterations: " n

first_tree_length=32
current_tree_height=$first_tree_length
first_root_positions="49"
current_root_positions=$first_root_positions

fractals=()

for ((i=0; $i<$n; i++))
do
    for ((current_height=0; $current_height <= $current_tree_height; current_height++))
    do
	positions=$(determine_positions  "$i" "$current_height")
        fractals+=($positions)	
    done
    
    current_tree_height=$(( current_tree_height / 2 ))
    current_root_positions=$( get_root_positions "$i")
done

fractals_length=${#fractals[@]}

for ((i=63; i > 0; i--))
do
    if [[ $i -ge $fractals_length ]]
    then
        print_single_line ""
        continue
    fi 

    print_single_line ${fractals[i]}
done
