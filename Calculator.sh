#!/bin/bash

echo "=== Calcul position chevalet guitare ==="

# Entrées
read -p "Distance sillet -> frette 1 (mm): " d1
read -p "Distance frette 1 -> frette 2 (mm): " d2
read -p "Nombre de cordes: " strings
read -p "Type de tirant (souple / medium / dur): " tension

# Constante
k=$(echo "scale=10; 2^(1/12)" | bc -l)

# Calcul diapason
L1=$(echo "scale=5; $d1 / (1 - 1/$k)" | bc -l)
L2=$(echo "scale=5; $d2 / (1/$k - 1/($k*$k))" | bc -l)
L=$(echo "scale=5; ($L1 + $L2) / 2" | bc -l)

# Compensation selon tirant
case $tension in
  souple)
    comp_treble=1.5
    comp_bass=3
    ;;
  medium)
    comp_treble=2
    comp_bass=5
    ;;
  dur)
    comp_treble=2.5
    comp_bass=7
    ;;
  *)
    echo "Type inconnu, utilisation medium par défaut"
    comp_treble=2
    comp_bass=5
    ;;
esac

# Position centre
bridge_center=$L

# Positions extrêmes
bridge_treble=$(echo "scale=5; $bridge_center + $comp_treble" | bc)
bridge_bass=$(echo "scale=5; $bridge_center + $comp_bass" | bc)

# Zone globale (avec marge ±5 mm)
zone_min=$(echo "scale=5; $bridge_center - 5" | bc)
zone_max=$(echo "scale=5; $bridge_center + $comp_bass + 5" | bc)

# Output
echo ""
echo "=== RESULTATS ==="
echo "Diapason estimé : $L mm"
echo ""
echo "Position théorique (centre) : $bridge_center mm"
echo "Position corde aiguë :        $bridge_treble mm"
echo "Position corde grave :        $bridge_bass mm"
echo ""
echo "Zone de placement recommandée :"
echo "  min : $zone_min mm"
echo "  max : $zone_max mm"
