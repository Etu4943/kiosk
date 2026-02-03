#!/bin/bash

## Detection pour Wayland
#SCREENS=$(gdbus call --session \
 # --dest org.gnome.Mutter.DisplayConfig \
  #--object-path /org/gnome/Mutter/DisplayConfig \
  #--method org.gnome.Mutter.DisplayConfig.GetCurrentState \
  #| grep -o "Virtual-[0-9]" | sort -u | wc -l)

## Detection pour Xorg
SCREENS=$(xrandr --query | grep " connected" | wc -l)
echo "Écrans détectés: $SCREENS"


if [ "$SCREENS" -le 1 ]; then
    MOZ_ENABLE_WAYLAND=0 firefox --kiosk https://brabant-wallon.secourspompier
else
    # Lancer les deux profils
    MOZ_ENABLE_WAYLAND=0 firefox -P screen1  --no-remote --class KIOSK1 https://brabant-wallon.secourspompiers.be/ &
    sleep 2  # laisser le temps à la fenêtre de s'ouvrir
    WIN1=$(xdotool search --onlyvisible --class KIOSK1 | head -n1)
    
    MOZ_ENABLE_WAYLAND=0 firefox  -P screen2   --no-remote --class KIOSK2 https://theuselessweb.com &
    sleep 2
    WIN2=$(xdotool search --onlyvisible --class KIOSK2 | head -n1)
    # Récupérer la largeur d'un écran
    SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
    
    # Déplacer la première fenêtre sur l'écran 1
    xdotool windowmove $WIN1 0 0

    # Déplacer la deuxième fenêtre sur l'écran 2
    xdotool windowmove $WIN2 $SCREEN_WIDTH 0

xdotool key F11
sleep 10
xdotool key F11
fi
