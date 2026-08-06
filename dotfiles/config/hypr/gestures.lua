hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.gesture({
    fingers = 2,
    direction = "left",
    action = function()
        hl.dispatch(hl.dsp.layout("focus r"))
    end,
})

hl.gesture({
    fingers = 2,
    direction = "right",
    action = function()
        hl.dispatch(hl.dsp.layout("focus l"))
    end,
})