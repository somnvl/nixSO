hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
})

hl.gesture({
    fingers = 3,
    direction = "left",
    action = function()
        hl.dispatch(hl.dsp.layout("focus r"))
    end,
})

hl.gesture({
    fingers = 3,
    direction = "right",
    action = function()
        hl.dispatch(hl.dsp.layout("focus l"))
    end,
})