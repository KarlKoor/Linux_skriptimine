#!/bin/bash

# Generib 5 juhuslikku ja erinevat numbrit vahemikus 1–50
draw_lottery_numbers() {
    local lottery_file="$1"
    local drawn=()
    local rand_num
    local is_duplicate

    while [ ${#drawn[@]} -lt 5 ]; do
        rand_num=$(( ($RANDOM % 50) + 1 ))
        is_duplicate=0

        local num
        for num in "${drawn[@]}"; do
            if [ "$num" -eq "$rand_num" ]; then
                is_duplicate=1
                break
            fi
        done

        if [ "$is_duplicate" -eq 0 ]; then
            drawn+=("$rand_num")
            append_to_file "$lottery_file" "$rand_num"
        fi
    done

    echo "${drawn[*]}"
}

# Võrdleb mängija ja loositud numbreid, kuvab teated ja tagastab tabamuste arvu
check_matches() {
    local -a player_nums=($1)
    local -a lottery_nums=($2)
    local matches=0
    local p_num l_num hit

    for p_num in "${player_nums[@]}"; do
        echo "Kontrollin numbrit $p_num..."
        hit=0

        for l_num in "${lottery_nums[@]}"; do
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

    return "$matches"
}
