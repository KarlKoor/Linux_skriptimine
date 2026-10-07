#!/bin/bash

# 1. Failide algseadistamine
# Tühjendame või loome failid player_numbers.txt ja lottery_numbers.txt
> player_numbers.txt
> lottery_numbers.txt

# 2. Mängija nime küsimine
read -p "Sisesta oma nimi: " player_name
if [ -z "$player_name" ]; then
    player_name="Unknown"
fi

echo "Tere, $player_name! Valime 5 erinevat numbrit vahemikust 1–50."

# 3. Mängija numbrite küsimine ja valideerimine
player_numbers=()

while [ ${#player_numbers[@]} -lt 5 ]; do
    read -p "Sisesta number $(( ${#player_numbers[@]} + 1 )) (1-50): " input_num

    # Kontroll 1: Kas midagi sisestati?
    if [ -z "$input_num" ]; then
        echo "Viga: Sisend ei tohi olla tühi! Proovi uuesti."
        continue
    fi

    # Kontroll 2: Kas on täisarv?
    if ! [[ "$input_num" =~ ^[0-9]+$ ]]; then
        echo "Viga: Sisestatud väärtus peab olema täisarv! Proovi uuesti."
        continue
    fi

    # Kontroll 3: Kas on vahemikus 1–50?
    if [ "$input_num" -lt 1 ] || [ "$input_num" -gt 50 ]; then
        echo "Viga: Number peab olema vahemikus 1–50! Proovi uuesti."
        continue
    fi

    # Kontroll 4: Kas same number on juba valitud?
    already_selected=0
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

    # Korrektse numbri lisamine massiivi ja faili
    player_numbers+=("$input_num")
    echo "$input_num" >> player_numbers.txt
done

echo ""
echo "Sinu valitud numbrid on:"
for num in "${player_numbers[@]}"; do
    echo "$num"
done
echo "----------------------------------------"

# 4. Loosimine
echo "Loosin 5 võidunumbrit..."
lottery_numbers=()

while [ ${#lottery_numbers[@]} -lt 5 ]; do
    # Genereerime numbri 1–50 kasutades $RANDOM muutujat
    rand_num=$(( ($RANDOM % 50) + 1 ))

    # Kontrollime duplikaate
    is_duplicate=0
    for num in "${lottery_numbers[@]}"; do
        if [ "$num" -eq "$rand_num" ]; then
            is_duplicate=1
            break
        fi
    done

    # Kui ei ole duplikaat, lisame numbri
    if [ "$is_duplicate" -eq 0 ]; then
        lottery_numbers+=("$rand_num")
        echo "$rand_num" >> lottery_numbers.txt
    fi
done

echo "Loositud võidunumbrid on:"
for num in "${lottery_numbers[@]}"; do
    echo "$num"
done
echo "----------------------------------------"

# 5. Tulemuse kontrollimine
matches=0

for p_num in "${player_numbers[@]}"; do
    echo "Kontrollin numbrit $p_num..."
    hit=0
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

# Hinnangu määramine vastavalt tabamustele
case $matches in
    5) result="JACKPOT!" ;;
    4) result="Väga hea tulemus!" ;;
    3) result="Hea tulemus." ;;
    2) result="Kaks tabamust." ;;
    1) result="Üks tabamus." ;;
    0) result="Seekord tabamusi ei olnud." ;;
esac

echo "Mängija: $player_name"
echo "Tabamusi: $matches / 5"
echo "Tulemus: $result"

# 6. Tulemuste salvestamine faili results.txt (lisatakse lõppu >>)
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
    echo "Result: $result"
} >> results.txt
