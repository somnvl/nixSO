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

    gestures = {
        workspace_swipe_distance = 400,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = false,
    },
})

-- 3 fingers up/down: change workspace. Discrete dispatcher instead of the
-- built-in "workspace" gesture action — that one drives Hyprland's live-swipe
-- follow renderer, hardcoded horizontal regardless of direction (see
-- hyprland-plugins#469, #562 — same limitation, unfixable for now). This
-- fires once on gesture completion instead, using the normal "workspaces"
-- animation (slidevert, see look.lua) for the transition.
--
-- e+1 / e-1 already jump to (and create, if needed) the next/previous empty
-- workspace natively, so no extra "create new" handling is needed here.
hl.gesture({
    fingers = 3,
    direction = "up",
    action = function() hl.dispatch(hl.dsp.focus({ workspace = "e+1" })) end,
})
hl.gesture({
    fingers = 3,
    direction = "down",
    action = function() hl.dispatch(hl.dsp.focus({ workspace = "e-1" })) end,
})

-- 3 fingers left/right: scroll/navigate between columns within the same
-- workspace (scrolling layout). "focus l/r" moves the view, unlike
-- "move ±col" which would relocate the focused window itself.
hl.gesture({
    fingers = 3,
    direction = "right",
    action = function() hl.dispatch(hl.dsp.layout("focus r")) end,
})
hl.gesture({
    fingers = 3,
    direction = "left",
    action = function() hl.dispatch(hl.dsp.layout("focus l")) end,
})

-- 4 fingers vertical: toggle the scrolloverview plugin's overview.
if hl.plugin and hl.plugin.scrolloverview then
    hl.config({
        plugin = {
            scrolloverview = {
                gesture_distance = 400, -- default 200 felt too sensitive
            },
        },
    })

    hl.plugin.scrolloverview.gesture({
        fingers = 4,
        direction = "vertical",
    })
end