--Configuration
function love.conf(t)
    t.title = "Space Match 3000"
    t.identity = "space_match_v2.0"
    t.version = "0.10.2"
    t.window.height = 640
    t.window.width = 800
    t.window.resizable = true
    t.window.minwidth = 800
    t.window.minheight = 640
    t.window.vsync = false
    -- Disable unused elements
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false
end
