-- Start writing your LÖVE code here
virtual_joystick = require("src.virtual_joystick")
width = 0
height = 0
center = {
    x = 0,
    y = 0
}

player = {
    x = 0,
    y = 0,
    velocity = 0,
    radius = 50,
    speed = 300
}

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    center.x = width / 2
    center.y = height / 2
    player.x = center.x
    player.y = center.y
	virtual_joystick.create_joystick(
        "move",
        center.x,
        center.y+300,
        60,
        {0.7, 0.7, 0.7, 0.5},
        30,
        {0.9, 0.9, 0.9, 0.5}
    )
end

function love.touchpressed(id, x, y, _dx, _dy, _pressure)
    virtual_joystick.pressed(id, x, y)
end

function love.touchmoved(id, x, y, _dx, _dy, _pressure)
    virtual_joystick.moved(id, x, y)
end

function love.touchreleased(id, _x, _y, _dx, _dy, _pressure)
    virtual_joystick.released(id)
end

function love.update(dt)
	local dx, dy, _magnitude = virtual_joystick.read_input("move")
    player.x = player.x + (player.speed * dx * dt)
    player.y = player.y + (player.speed * dy * dt)
    
    if player.x >= width - player.radius then
        player.x = width - player.radius
    end
    if player.x <= player.radius then
        player.x = player.radius
    end
    
    if player.y >= height - player.radius then
        player.y = height - player.radius
    end
    if player.y <= player.radius then
        player.y = player.radius
    end
end

function love.draw()
    love.graphics.setColor(0.8, 0.4, 0, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
    virtual_joystick.draw()
end