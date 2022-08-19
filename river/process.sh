killall mako
mako &

killall waybar
waybar &

killall nm-applet
nm-applet --indicator &

[ ! -s ~/.config/mpd/pid ] && mpd

brightnessctl set 40%

# River will send the process group of the init executable SIGTERM on exit
riverctl default-layout rivertile &
exec rivertile -main-ratio 0.5 -view-padding 5 -outer-padding 4 &

for pad in $(riverctl list-inputs | grep -i touchpad)
do
  riverctl input $pad events enabled
  riverctl input $pad tap enabled
  riverctl input $pad natural-scroll disabled
  riverctl input $pad accel-profile adaptive
  riverctl input $pad pointer-accel 0.4
  riverctl input $pad disable-while-typing enabled
  riverctl input $pad scroll-method two-finger
  riverctl input $pad tap-button-map left-right-middle
done

# for screen sharing
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

killall swaybg
swaybg -i ~/wallpapers/wall.jpg
