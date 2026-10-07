#!/bin/bash

# Küsib mängija nime
read_player_name() {
    local name
    read -p "Sisesta oma nimi: " name

    if [ -z "$name" ]; then
        echo "Unknown"
    else
        echo "$name"
    fi
}

# Valideerib ühe sisestatud numbri
validate_number() {
    local input="$1"
    shift
    local existing_numbers=("$@")

    # Kontroll 1: Midagi on sisestatud
    if [ -z "$input" ]; then
        echo "Viga: Sisend ei tohi olla tühi! Proovi uuesti." >&2
        return 1
    fi

    # Kontroll 2: Täisarv
    if ! [[ "$input" =~ ^[0-9]+$ ]]; then
        echo "Viga: Sisestatud väärtus peab olema täisarv! Proovi uuesti." >&2
        return 1
    fi

    # Kontroll 3: Vahemik 1–50
    if [ "$input" -lt 1 ] || [ "$input" -gt 50 ]; then
        echo "Viga: Number peab olema vahemikus 1–50! Proovi uuesti." >&2
        return 1
    fi

    # Kontroll 4: Kordumatus
    local num
    for num in "${existing_numbers[@]}"; do
        if [ "$num" -eq "$input" ]; then
            echo "Viga: Oled selle numbri juba valinud! Proovi uuesti." >&2
            return 1
        fi
    done

    return 0
}

# Küsib mängijalt 5 valideeritud numbrit
get_player_numbers() {
    local player_file="$1"
    local chosen=()
    local input_num

    while [ ${#chosen[@]} -lt 5 ]; do
        read -p "Sisesta number $(( ${#chosen[@]} + 1 )) (1-50): " input_num

        if validate_number "$input_num" "${chosen[@]}"; then
            chosen+=("$input_num")
            append_to_file "$player_file" "$input_num"
        fi
    done

    # Tagastame numbrid tühikuga eraldatult
    echo "${chosen[*]}"
}
