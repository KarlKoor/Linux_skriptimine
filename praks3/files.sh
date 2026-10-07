#!/bin/bash

# Loob või tühjendab nõutud failid
clear_files() {
    local player_file="$1"
    local lottery_file="$2"

    > "$player_file" || return 1
    > "$lottery_file" || return 1

    return 0
}

# Kirjutab ühenumbrilise rea faili
append_to_file() {
    local file="$1"
    local value="$2"

    echo "$value" >> "$file" || return 1
    return 0
}
