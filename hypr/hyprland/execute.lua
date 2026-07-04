-----------------
--- AUTOSTART ---
-----------------

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
hl.on("hyprland.start", function ()
    hl.exec_cmd("uwsm app -- dunst")
    hl.exec_cmd("uwsm app -- fcitx5")
    hl.exec_cmd("uwsm app -- wl-paste --type text --watch cliphist store")
    hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
    hl.exec_cmd("uwsm app -- udiskie &")
    hl.exec_cmd("uwsm app -- pcmanfm-qt -d &")

    -- hl.exec_cmd("uwsm app -- bash -c ~/.config/hypr/scripts/paper.sh")
    hl.exec_cmd("systemctl --user start hypridle.service hyprpaper.service hyprpolkitagent.service waybar.service")
end)
