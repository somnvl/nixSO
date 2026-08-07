local mainMod = "SUPER"

if hl.plugin and hl.plugin.scrolloverview then
    hl.plugin.scrolloverview.configure({
        scale = 0.5,
        layout = "vertical",
        workspace_gap = 50,
        wallpaper = 0,
        blur = true,

        shadow = {
            enabled = false,
        },
    })

    hl.plugin.scrolloverview.gesture({
        fingers = 4,
        direction = "vertical",
    })

    hl.bind(mainMod .. " + Tab", function()
        hl.plugin.scrolloverview.overview("toggle")
    end)
end