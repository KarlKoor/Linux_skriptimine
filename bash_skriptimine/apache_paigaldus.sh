#!/bin/bash
# ==============================================================================
# Skript: apache_paigaldus.sh
# Kirjeldus: Kontrollib Apache2 veebiserveri olemasolu süsteemis.
#            Kui teenust pole, paigaldab selle ja käivitab.
#            Kui teenus on olemas, kuvab teate ja näitab selle staatust.
# ==============================================================================

TEENUS="apache2"

# Kontrollime dpkg-query abil paketiseisu ("ok installed")
# grep -c tagastab 1, kui leiti vaste (paigaldatud), või 0, kui ei leitud.
APACHE_KONTROLL=$(dpkg-query -W -f='${Status}' $TEENUS 2>/dev/null | grep -c "ok installed")

if [ "$APACHE_KONTROLL" -eq 1 ]; then
    echo "Teavitus: Teenus $TEENUS on juba süsteemi paigaldatud."
    echo "--------------------------------------------------"
    echo "Teenuse $TEENUS olek:"
    systemctl status $TEENUS --no-pager
else
    echo "Teavitus: Teenust $TEENUS ei leitud süsteemist."
    echo "Alustatakse teenuse $TEENUS paigaldamist..."
    echo "--------------------------------------------------"
    
    # Uuendame paketinimekirja ja paigaldame teenuse automaatselt (-y)
    apt-get update -y
    apt-get install -y $TEENUS
    
    # Veendume, et teenus töötab ja käivitub süsteemiga
    systemctl start $TEENUS
    systemctl enable $TEENUS
    
    echo "--------------------------------------------------"
    echo "Teenus $TEENUS paigaldati edukalt!"
    echo "Teenuse olek:"
    systemctl status $TEENUS --no-pager
fi
