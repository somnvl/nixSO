local ok, colors = pcall(require, "colors")
if not ok then
    colors = {
        background = "#000000",
        foreground = "#ffffff",
        cursor     = "#ffffff",
        color4     = "#888888",
        color8     = "#444444",
    }
end

local function hex(c, alpha)
    alpha = alpha or "ff"
    return tonumber(alpha .. c:sub(2), 16)
end

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = { top = 30, right = 5, bottom = 5, left = 5 },
        border_size = 0,
        resize_on_border = false,
        allow_tearing = false,
        layout = "scrolling",

        col = {
            active_border   = hex(colors.color4),
            inactive_border = hex(colors.color8),
        },
    },
    decoration = {
        rounding       = 18,
        rounding_power = 3,
        active_opacity   = 0.9,
        inactive_opacity = 0.9,
        shadow = {
            enabled      = false,
        },
        blur = {
            enabled           = true,
            size              = 5,
            passes            = 1,
            new_optimizations = true,
            xray              = true,
            vibrancy          = 0.1696,
        },
    },
})

hl.config({
    scrolling = { fullscreen_on_one_column = false, explicit_column_widths = "0.333, 0.5, 0.667", focus_fit_method = 1 },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
        background_color = hex(colors.background),
    },
})

hl.workspace_rule({ workspace = "2", monitor = "eDP-1", default = true })

for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end