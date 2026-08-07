if hl.plugin and hl.plugin.scrolloverview then
    hl.config({
        plugin = {
            scrolloverview = {
                gesture_distance = 400,
                scale = 0.5,
                workspace_gap = 100,
                layout = "vertical",
                wallpaper = 0,
                blur = true,

                shadow = {
                    enabled = false,
                },
            },
        },
    })

    hl.plugin.scrolloverview.gesture({
        fingers = 4,
        direction = "vertical",
    })

    hl.bind("SUPER + Tab", function()
        hl.plugin.scrolloverview.overview("toggle")
    end)
end