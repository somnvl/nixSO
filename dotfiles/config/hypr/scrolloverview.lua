if hl.plugin and hl.plugin.scrolloverview then
    hl.config({
        plugin = {
            scrolloverview = {
                scale = 0.5,
                workspace_gap = 20,
                layout = "vertical",      -- matches your workspace stack
                wallpaper = 0,            -- 0 = global only, matches swaybg setup
                blur = true,              -- matches decoration.blur.enabled in look.lua

                shadow = {
                    enabled = false,
                },
            },
        },
    })
end