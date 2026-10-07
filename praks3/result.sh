#!/bin/bash

# Tagastab vastava teksti vastavalt tabamuste arvule
get_result_text() {
    local matches="$1"

    case "$matches" in
        5) echo "JACKPOT!" ;;
        4) echo "Väga hea tulemus!" ;;
        3) echo "Hea tulemus." ;;
        2) echo "Kaks tabamust." ;;
        1) echo "Üks tabamus." ;;
        0) echo "Seekord tabamusi ei olnud." ;;
        *) echo "Tundmatu tulemus." ;;
    esac
}

# Salvestab mängu ajaloo faili results.txt
save_game_result() {
    local results_file="$1"
    local player_name="$2"
    local player_nums_str="$3"
    local lottery_nums_str="$4"
    local matches="$5"
    local result_text="$6"

    local current_date
    current_date=$(date)

    local -a player_nums=($player_nums_str)
    local -a lottery_nums=($lottery_nums_str)

    {
        echo "========================================"
        echo "Date: $current_date"
        echo "Player: $player_name"
        echo "Player numbers:"
        for num in "${player_nums[@]}"; do
            echo "$num"
        done
        echo "Lottery numbers:"
        for num in "${lottery_nums[@]}"; do
            echo "$num"
        done
        echo "Matches: $matches"
        echo "Result: $result_text"
    } >> "$results_file" || return 1

    return 0
}
