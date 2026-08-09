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
})


hl.gesture({ fingers = 3, direction = "up",   action = function() hl.dispatch(hl.dsp.focus({ workspace = "r+1" })) end })
hl.gesture({ fingers = 3, direction = "down", action = function() hl.dispatch(hl.dsp.focus({ workspace = "r-1" })) end })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
    scale = 1.0,
})

if hl.plugin and hl.plugin.scrolloverview then
    hl.config({
        plugin = {
            scrolloverview = {
                gesture_distance = 300,
            },
        },
    })

    hl.gesture({
        fingers = 4,
        direction = "vertical",
        action = function() hl.dispatch(hl.plugin.scrolloverview.overview("toggle")) end,
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
        hl.gesture({ fingers = 3, direction = "up",   action = "unset" })
        hl.gesture({ fingers = 3, direction = "down", action = "unset" })
    else
        hl.gesture({ fingers = 3, direction = "up",   action = function() hl.dispatch(hl.dsp.focus({ workspace = "r+1" })) end })
        hl.gesture({ fingers = 3, direction = "down", action = function() hl.dispatch(hl.dsp.focus({ workspace = "r-1" })) end })
    end
end)