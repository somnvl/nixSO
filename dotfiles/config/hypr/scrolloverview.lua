local mainMod = "SUPER"

if hl.plugin and hl.plugin.scrolloverview then
    hl.plugin.scrolloverview.configure({
        scale = 0.5,
        layout = "vertical",
        workspace_gap = 100,
        wallpaper = 0            -- 0 = global wallpaper only, matches swaybg setup
        blur = true,

        shadow = {
            enabled = false,
        },
    })

    hl.bind(mainMod .. " + Tab", function()
        hl.plugin.scrolloverview.overview("toggle")
    end)
end