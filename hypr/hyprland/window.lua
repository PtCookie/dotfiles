------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

-- Example windowrules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = {
        class = ".*"
    },
    suppress_event = "maximize"
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = {
        class = "hyprland-run"
    },
    move = "20 monitor_h-120",
    float = true
})

hl.window_rule({ match = { class = ".*" }, float = true })
hl.window_rule({ match = { class = "Alacritty" }, tile = true })
hl.window_rule({ match = { class = "pcmanfm-qt" }, tile = true })
hl.window_rule({ match = { class = ".*zathura" }, tile = true })
hl.window_rule({ match = { class = "imv" }, tile = true })
hl.window_rule({ match = { class = "mpv" }, tile = true })
hl.window_rule({ match = { class = "codium" }, tile = true })
hl.window_rule({ match = { class = ".*zen.*" }, tile = true })
hl.window_rule({ match = { class = ".*firefox.*" }, tile = true })
hl.window_rule({ match = { class = ".*chromium.*" }, tile = true })
hl.window_rule({ match = { class = "VirtualBox Machine" }, tile = true })

hl.window_rule({ match = { class = "waybar" }, move = "cursor_x+10 cursor_y+10" })
-- hl.window_rule({ match = { class = "jetbrains-toolbox" }, move = "onscreen 100%-380 44" })

hl.window_rule({ match = { class = "org.telegram.desktop" }, size = "800 720" })
hl.window_rule({ match = { class = "org.telegram.desktop" }, move = "monitor_w*0.1 monitor_h*0.05" })
hl.window_rule({ match = { class = "com.discordapp.Discord" }, size = "1280 720" })
hl.window_rule({ match = { class = "com.discordapp.Discord" }, move = "80 monitor_h*0.55" })
hl.window_rule({ match = { class = "org.mozilla.Thunderbird" }, size = "1760 1600" })
hl.window_rule({ match = { class = "org.mozilla.Thunderbird" }, move = "monitor_w*0.45 monitor_h*0.05" })
hl.window_rule({ match = { class = "Spotify" }, size = "1200 800" })
hl.window_rule({ match = { class = "Spotify" }, center = true })
hl.window_rule({ match = { class = "VirtualBox Manager" }, size = "1200 800" })
hl.window_rule({ match = { class = "VirtualBox Manager" }, center = true })
