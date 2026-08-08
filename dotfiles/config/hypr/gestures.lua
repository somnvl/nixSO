hl.config({
    input = {
        touchpad = {
            tap_to_click            = true,
            disable_while_typing    = false,
            natural_scroll          = true,
            drag_lock                = 1,
            clickfinger_behavior     = true,
            middle_button_emulation  = false,
            scroll_factor            = 1.0,
        },
    },

    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 20,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = true,
    },
})


hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
    scale = 0.9,
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
    scale = 0.8,
})

if hl.plugin and hl.plugin.scrolloverview then
    hl.config({
        plugin = {
            scrolloverview = {
                gesture_distance = 300,
            },
        },
    })

    hl.plugin.scrolloverview.gesture({
        fingers = 4,
        direction = "vertical",
    })
end

if hl.plugin and hl.plugin.scrolloverview then
    hl.define_submap("scrolloverview", function()
        hl.bind("left",   hl.plugin.scrolloverview.navigate("left"))
        hl.bind("right",  hl.plugin.scrolloverview.navigate("right"))
        hl.bind("up",     hl.plugin.scrolloverview.navigate("up"))
        hl.bind("down",   hl.plugin.scrolloverview.navigate("down"))
        hl.bind("return", hl.plugin.scrolloverview.overview("select"))
        hl.bind("escape", hl.plugin.scrolloverview.overview("off"))
        hl.bind("mouse:272", function()
            hl.plugin.scrolloverview.overview("select")
            hl.plugin.scrolloverview.window("select")
            hl.plugin.scrolloverview.overview("off")
        end, { mouse = true })
        hl.bind("mouse:274", hl.plugin.scrolloverview.window("close"), { mouse = true })
    end)
end

hl.on("keybinds.submap", function(submapName)
    if submapName == "scrolloverview" then
        hl.gesture({ fingers = 3, direction = "vertical", action = "unset", scale = 0.9 })
    else
        hl.gesture({ fingers = 3, direction = "vertical", action = "workspace", scale = 0.9 })
    end
end)