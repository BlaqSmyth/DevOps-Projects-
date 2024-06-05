#!/bin/bash

# Function to display the multiplication table
display_table() {
    local number=$1
    local start=$2
    local end=$3

    echo "The multiplication table for $number from $start to $end:"
    for (( i=start; i<=end; i++ )); do
        echo "$number x $i = $(( number * i ))"
    done
}

# Prompt the user to enter a number
read -p "Enter a number for the multiplication table: " number

# Validate that the input is a number
if ! [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a valid number."
    exit 1
fi

# Ask the user if they want a full table or a partial table
read -p "Do you want a full table or a partial table? (Enter 'f' for full, 'p' for partial): " choice

if [[ "$choice" == "f" ]]; then
    # Full table using list form for loop
    echo "The full multiplication table for $number:"
    for i in {1..10}; do
        echo "$number x $i = $(( number * i ))"
    done
elif [[ "$choice" == "p" ]]; then
    # Partial table
    read -p "Enter the starting number (between 1 and 10): " start
    read -p "Enter the ending number (between 1 and 10): " end

    # Validate the range
    if [[ "$start" =~ ^[0-9]+$ ]] && [[ "$end" =~ ^[0-9]+$ ]] && (( start >= 1 && start <= 10 )) && (( end >= 1 && end <= 10 )) && (( start <= end )); then
        display_table $number $start $end
    else
        echo "Invalid range. Showing full table instead."
        display_table $number 1 10
    fi
else
    echo "Invalid choice. Showing full table by default."
    display_table $number 1 10
fi

# Optionally, ask the user if they want to see the table in ascending or descending order
read -p "Do you want to see the table in ascending or descending order? (Enter 'a' for ascending, 'd' for descending): " order

if [[ "$order" == "d" ]]; then
    echo "The full multiplication table for $number in descending order:"
    for (( i=10; i>=1; i-- )); do
        echo "$number x $i = $(( number * i ))"
    done
else
    echo "The full multiplication table for $number in ascending order:"
    for (( i=1; i<=10; i++ )); do
        echo "$number x $i = $(( number * i ))"
    done
fi

