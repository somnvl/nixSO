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