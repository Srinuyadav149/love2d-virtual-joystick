function love.conf(t)
    t.window.title = "prototypes"
    t.window.resizable = true
    t.highdpi = true
    t.window.fullscreen = true
    t.window.vsync = 1
    
    t.graphics.renderer = {"vulkan"}
end