#!/bin/bash

# ==========================================
# GLOBAALSED MUUTUJAD
# ==========================================
PLAYER_FILE="player_numbers.txt"
LOTTERY_FILE="lottery_numbers.txt"
RESULTS_FILE="results.txt"

player_name=""
player_numbers=()
lottery_numbers=()
matches=0
result_text=""

# ==========================================
# FUNKTSIOONID
# ==========================================

show_header() {
    echo "========================================"
    echo "          LIHTNE LOTOMÄNG               "
    echo "========================================"
}

# Loob või tühjendab vajalikud failid
clear_files() {
    > "$PLAYER_FILE"
    > "$LOTTERY_FILE"
}

# Küsib mängija nime
read_player() {
    read -p "Sisesta oma nimi: " player_name
    if [ -z "$player_name" ]; then
        player_name="Unknown"
    fi
    echo "Tere, $player_name! Valime 5 erinevat numbrit vahemikust 1–50."
    echo ""
}

# Küsib mängijalt 5 valideeritud numbrit
read_player_numbers() {
    while [ ${#player_numbers[@]} -lt 5 ]; do
        read -p "Sisesta number $(( ${#player_numbers[@]} + 1 )) (1-50): " input_num

        # Kontroll 1: Tühi sisend
        if [ -z "$input_num" ]; then
            echo "Viga: Sisend ei tohi olla tühi! Proovi uuesti."
            continue
        fi

        # Kontroll 2: Täisarv
        if ! [[ "$input_num" =~ ^[0-9]+$ ]]; then
            echo "Viga: Sisestatud väärtus peab olema täisarv! Proovi uuesti."
            continue
        fi

        # Kontroll 3: Vahemik 1-50
        if [ "$input_num" -lt 1 ] || [ "$input_num" -gt 50 ]; then
            echo "Viga: Number peab olema vahemikus 1–50! Proovi uuesti."
            continue
        fi

        # Kontroll 4: Duplikaat
        local already_selected=0
        for num in "${player_numbers[@]}"; do
            if [ "$num" -eq "$input_num" ]; then
                already_selected=1
                break
            fi
        done

        if [ "$already_selected" -eq 1 ]; then
            echo "Viga: Oled selle numbri juba valinud! Proovi uuesti."
            continue
        fi

        # Lisame massiivi ja salvestame faili
        player_numbers+=("$input_num")
        echo "$input_num" >> "$PLAYER_FILE"
    done
}

# Kuvab mängija valitud numbrid
show_player_numbers() {
    echo ""
    echo "Sinu valitud numbrid on:"
    for num in "${player_numbers[@]}"; do
        echo "$num"
    done
    echo "----------------------------------------"
}

# Loosib 5 juhuslikku kordumatut numbrit
generate_lottery_numbers() {
    while [ ${#lottery_numbers[@]} -lt 5 ]; do
        local rand_num=$(( ($RANDOM % 50) + 1 ))

        local is_duplicate=0
        for num in "${lottery_numbers[@]}"; do
            if [ "$num" -eq "$rand_num" ]; then
                is_duplicate=1
                break
            fi
        done

        if [ "$is_duplicate" -eq 0 ]; then
            lottery_numbers+=("$rand_num")
            echo "$rand_num" >> "$LOTTERY_FILE"
        fi
    done
}

# Kuvab võidunumbrid
show_lottery_numbers() {
    echo "Loosin 5 võidunumbrit..."
    echo "Loositud võidunumbrid on:"
    for num in "${lottery_numbers[@]}"; do
        echo "$num"
    done
    echo "----------------------------------------"
}

# Võrdleb numbreid ja arvutab tabamused
check_matches() {
    matches=0
    for p_num in "${player_numbers[@]}"; do
        echo "Kontrollin numbrit $p_num..."
        local hit=0
        for l_num in "${lottery_numbers[@]}"; do
            if [ "$p_num" -eq "$l_num" ]; then
                hit=1
                break
            fi
        done

        if [ "$hit" -eq 1 ]; then
            echo "TABAMUS!"
            matches=$((matches + 1))
        else
            echo "Ei tabanud."
        fi
        echo ""
    done

    # Hinnangu määramine
    case $matches in
        5) result_text="JACKPOT!" ;;
        4) result_text="Väga hea tulemus!" ;;
        3) result_text="Hea tulemus." ;;
        2) result_text="Kaks tabamust." ;;
        1) result_text="Üks tabamus." ;;
        0) result_text="Seekord tabamusi ei olnud." ;;
    esac
}

# Kuvab lõpptulemuse
show_result() {
    echo "Mängija: $player_name"
    echo "Tabamusi: $matches / 5"
    echo "Tulemus: $result_text"
}

# Salvestab tulemuse faili results.txt
save_result() {
    local current_date
    current_date=$(date)

    {
        echo "========================================"
        echo "Date: $current_date"
        echo "Player: $player_name"
        echo "Player numbers:"
        for num in "${player_numbers[@]}"; do
            echo "$num"
        done
        echo "Lottery numbers:"
        for num in "${lottery_numbers[@]}"; do
            echo "$num"
        done
        echo "Matches: $matches"
        echo "Result: $result_text"
    } >> "$RESULTS_FILE"
}

# ==========================================
# PROGRAMMI PÕHIOSA (MAIN)
# ==========================================

show_header
clear_files
read_player
read_player_numbers
show_player_numbers
generate_lottery_numbers
show_lottery_numbers
check_matches
show_result
save_result
