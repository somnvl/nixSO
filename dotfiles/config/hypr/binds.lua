local programs = require("programs")

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(programs.editor))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + left",  hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + right", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.layout("swapcol r"))

hl.bind("CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

for i = 1, 10 do
    local code = i + 9  -- X11 keycode = evdev + 8 : KEY_1=10 ... KEY_9=18, KEY_0=19
    hl.bind(mainMod .. " + code:" .. code, hl.dsp.focus({ workspace = i }))

    hl.bind(mainMod .. " + SHIFT + code:" .. code, hl.dsp.layout("movecoltoworkspace " .. i))
end

hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + Page_Up",   hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + U", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "r-1" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "r-1" }))

hl.bind(mainMod .. " + S",       hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special:magic" }))

local colWidths = {0.333, 0.5, 0.667}
local colWidthIdx = 2
local isFullWidth = false

local function applyColWidth()
    hl.dispatch(hl.dsp.layout("colresize " .. colWidths[colWidthIdx]))
end

hl.bind(mainMod .. " + R", function()
    isFullWidth = false
    colWidthIdx = (colWidthIdx % #colWidths) + 1
    applyColWidth()
end)

hl.bind(mainMod .. " + SHIFT + R", function()
    isFullWidth = false
    colWidthIdx = colWidthIdx - 1
    if colWidthIdx < 1 then colWidthIdx = #colWidths end
    applyColWidth()
end)

hl.bind(mainMod .. " + F", function()
    if isFullWidth then
        applyColWidth()
    else
        hl.dispatch(hl.dsp.layout("colresize 1.0"))
    end
    isFullWidth = not isFullWidth
end)

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ layout_aware = false }))
hl.bind(mainMod .. " + CTRL + F",  hl.dsp.layout("fit expand"))

hl.bind(mainMod .. " + CTRL + C", hl.dsp.layout("fit visible"))

hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -0.1"))
hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +0.1"))

local screenshotDir = os.getenv("HOME") .. "/Pictures/screenshots"

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region -o " .. screenshotDir))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output -o " .. screenshotDir))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

if hl.plugin and hl.plugin.scrolloverview then
    hl.bind(mainMod .. " + Tab", function()
        hl.plugin.scrolloverview.overview("toggle")
    end, { submap_universal = true })
end

hl.bind(mainMod .. " + SHIFT + P", function()
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    end, { timeout = 100, type = "oneshot" })
end)

hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("pkill orca || exec orca"), { locked = true })

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })