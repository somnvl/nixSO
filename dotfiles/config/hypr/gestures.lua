-- Everything touchpad-related lives here: hardware behavior, the legacy
-- swipe tuning knobs, custom 1:1 gestures, and the scrolloverview plugin's
-- own gesture. hl.config() calls merge, so splitting input.touchpad out of
-- input.lua into this file doesn't change what it configures.

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

    -- Legacy touchpad tuning knobs (workspace_swipe_* family). The
    -- workspace_swipe on/off toggle itself was removed in Hyprland 0.51,
    -- superseded by the hl.gesture() system below — these sub-fields may
    -- now be dead weight, worth revisiting.
    gestures = {
        workspace_swipe_distance = 400,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = true,
    },
})


hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
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