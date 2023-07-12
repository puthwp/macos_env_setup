PaperWM = hs.loadSpoon("PaperWM")
PaperWM:bindHotkeys({
    -- switch to a new focused window in tiled grid
    focus_left  = {{"alt", "shift"}, "left"},
    focus_right = {{"alt", "shift"}, "right"},
    focus_up    = {{"alt", "shift"}, "up"},
    focus_down  = {{"alt", "shift"}, "down"},

    -- move windows around in tiled grid
    swap_left  = {{"cmd", "alt", "shift"}, "left"},
    swap_right = {{"cmd", "alt", "shift"}, "right"},
    swap_up    = {{"cmd", "alt", "shift"}, "up"},
    swap_down  = {{"cmd", "alt", "shift"}, "down"},

    -- position and resize focused window
    center_window = {{"alt", "shift"}, "c"},
    full_width    = {{"alt", "shift"}, "f"},
    cycle_width   = {{"alt", "shift"}, "r"},
    cycle_height  = {{"cmd", "alt", "shift"}, "r"},

    -- move focused window into / out of a column
    slurp_in = {{"alt", "shift"}, "i"},
    barf_out = {{"alt", "shift"}, "o"},

    -- switch to a new Mission Control space
    switch_space_1 = {{"alt", "shift"}, "1"},
    switch_space_2 = {{"alt", "shift"}, "2"},
    switch_space_3 = {{"alt", "shift"}, "3"},
    switch_space_4 = {{"alt", "shift"}, "4"},
    switch_space_5 = {{"alt", "shift"}, "5"},
    switch_space_6 = {{"alt", "shift"}, "6"},
    switch_space_7 = {{"alt", "shift"}, "7"},
    switch_space_8 = {{"alt", "shift"}, "8"},
    switch_space_9 = {{"alt", "shift"}, "9"},

    -- move focused window to a new space and tile
    move_window_1 = {{"alt", "cmd", "shift"}, "1"},
    move_window_2 = {{"alt", "cmd", "shift"}, "2"},
    move_window_3 = {{"alt", "cmd", "shift"}, "3"},
    move_window_4 = {{"alt", "cmd", "shift"}, "4"},
    move_window_5 = {{"alt", "cmd", "shift"}, "5"},
    move_window_6 = {{"alt", "cmd", "shift"}, "6"},
    move_window_7 = {{"alt", "cmd", "shift"}, "7"},
    move_window_9 = {{"alt", "cmd", "shift"}, "9"}
    move_window_8 = {{"alt", "cmd", "shift"}, "8"},
})
PaperWM:start()

hs.hotkey.bind({"cmd", "shift",},"return", function()
    local terminal = "warp"
    hsonscreenNotify(terminal + "Launching...")

    local terminal = hs.appfinder.appFormName(terminal)
    
    hs.application.launchOrFocus(terminal)
    if hs.appplication:isRunning() then
        appObject:selectMenuItem({"File","New Tab"})
        hs.window.switcher
    else
        hs.application.launchOrFocus(terminal)
    end
end)

function notify(text)
    hs.notify.show(text)
end

function onscreenNotify(text)
    hs.alert.show(text)
end

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()