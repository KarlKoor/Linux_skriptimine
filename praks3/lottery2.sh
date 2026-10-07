#!/bin/bash

# Skripti asukoha tuvastamine abifailide laadimiseks
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Laadime moodulid käsuga source
source "$SCRIPT_DIR/files.sh"
source "$SCRIPT_DIR/input.sh"
source "$SCRIPT_DIR/lottery_functions.sh"
source "$SCRIPT_DIR/result.sh"

# Failide nimed
PLAYER_FILE="player_numbers.txt"
LOTTERY_FILE="lottery_numbers.txt"
RESULTS_FILE="results.txt"

main() {
    echo "========================================"
    echo "          LIHTNE LOTOMÄNG               "
    echo "========================================"

    # 1. Algseadistus
    clear_files "$PLAYER_FILE" "$LOTTERY_FILE"

    # 2. Mängija andmed
    local player_name
    player_name=$(read_player_name)
    echo "Tere, $player_name! Valime 5 erinevat numbrit vahemikust 1–50."
    echo ""

    # 3. Mängija numbrite küsimine
    local player_nums_str
    player_nums_str=$(get_player_numbers "$PLAYER_FILE")

    echo ""
    echo "Sinu valitud numbrid on:"
    local num
    for num in $player_nums_str; do
        echo "$num"
    done
    echo "----------------------------------------"

    # 4. Loosimine
    echo "Loosin 5 võidunumbrit..."
    local lottery_nums_str
    lottery_nums_str=$(draw_lottery_numbers "$LOTTERY_FILE")

    echo "Loositud võidunumbrid on:"
    for num in $lottery_nums_str; do
        echo "$num"
    done
    echo "----------------------------------------"

    # 5. Kontroll ja tulemus
    check_matches "$player_nums_str" "$lottery_nums_str"
    local matches=$?

    local result_text
    result_text=$(get_result_text "$matches")

    echo "Mängija: $player_name"
    echo "Tabamusi: $matches / 5"
    echo "Tulemus: $result_text"

    # 6. Salvestamine
    save_game_result "$RESULTS_FILE" "$player_name" "$player_nums_str" "$lottery_nums_str" "$matches" "$result_text"
}

# Käivitame põhiprogrammi
main
