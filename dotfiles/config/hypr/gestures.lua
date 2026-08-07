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
        workspace_swipe_distance = 200,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = false,
    },
})

-- Discrete dispatcher gestures instead of the built-in "workspace" action:
-- the built-in one drives Hyprland's live-swipe follow renderer, which is
-- hardcoded horizontal regardless of direction (see hyprland-plugins#469,
-- #562 — same limitation, unfixable for now). These fire once on gesture
-- completion instead, using the normal "workspaces" animation (slidevert,
-- see look.lua) for the transition.
--
-- e+1 / e-1 only cycle among already-open workspaces and silently do
-- nothing when there's just one — r+1 / r-1 creates a new one dynamically
-- when there's no empty workspace to land on.
--
-- Guarded against the scrolloverview submap: while the overview is open,
-- its own 2-finger scroll already handles navigation live — firing this
-- discrete jump on top of that felt jarring and inconsistent.
hl.gesture({
    fingers = 3,
    direction = "up",
    action = function()
        if hl.get_current_submap() == "scrolloverview" then return end
        hl.dispatch(hl.dsp.focus({ workspace = "r+1" }))
    end,
})
hl.gesture({
    fingers = 3,
    direction = "down",
    action = function()
        if hl.get_current_submap() == "scrolloverview" then return end
        hl.dispatch(hl.dsp.focus({ workspace = "r-1" }))
    end,
})

hl.gesture({
    fingers = 3,
    direction = "right",
    action = function()
        if hl.get_current_submap() == "scrolloverview" then return end
        hl.dispatch(hl.dsp.layout("focus l"))
    end,
})
hl.gesture({
    fingers = 3,
    direction = "left",
    action = function()
        if hl.get_current_submap() == "scrolloverview" then return end
        hl.dispatch(hl.dsp.layout("focus r"))
    end,
})

-- scrolloverview plugin's own gesture + its sensitivity tuning (the rest of
-- the plugin's config — scale, layout, wallpaper, blur, shadow — is visual/
-- behavioral, not touchpad-related, so it stays in scrolloverview.lua).
if hl.plugin and hl.plugin.scrolloverview then
    hl.config({
        plugin = {
            scrolloverview = {
                gesture_distance = 200, -- default 200 felt too sensitive
            },
        },
    })

    hl.plugin.scrolloverview.gesture({
        fingers = 4,
        direction = "vertical",
    })
end