local virtual_joystick = {}
local joystick_registry = {}

function virtual_joystick.create_joystick(name, x, y, outer_radius, outer_color, inner_radius, inner_color)
	local joystick = {
        name = name or "joystick",
        outer_x = x,
        outer_y = y,
        outer_radius = outer_radius or 60,
        outer_color = outer_color or {0.7, 0.7, 0.7, 0.5},
        inner_x = x,
        inner_y = y,
        inner_radius = inner_radius or 20,
        inner_color = inner_color or {0.9, 0.9, 0.9, 0.5},
        dx = 0,
        dy = 0,
        magnitude = 0,
        active = false,
        visible = true,
        touch_id = nil
    }
    table.insert(joystick_registry, joystick)
end

function virtual_joystick.set_visibility(name, visibility)
    for i=1, #joystick_registry do
        local joystick = joystick_registry[i]
        if joystick.name == name then
        	joystick.visible = visibility
            if not joystick.visible and joystick.active then
                joystick.touch_id = nil
                joystick.inner_x = joystick.outer_x
                joystick.inner_y = joystick.outer_y
                joystick.dx = 0
                joystick.dy = 0
                joystick.magnitude = 0
                joystick.active = false
            end
            break
        end
    end
end

function virtual_joystick.pressed(id, x, y)
	for i=1, #joystick_registry do
        local joystick = joystick_registry[i]
        local dx = x - joystick.outer_x
        local dy = y - joystick.outer_y
        local distance = math.sqrt((dx * dx) + (dy * dy))
        if joystick.visible and distance <= joystick.outer_radius then
            joystick.touch_id = id
            joystick.inner_x = x
            joystick.inner_y = y
            joystick.dx = dx / joystick.outer_radius
            joystick.dy = dy / joystick.outer_radius
            joystick.magnitude = distance / joystick.outer_radius
            joystick.active = true
            break
        end
	end
end

function virtual_joystick.moved(id, x, y)
	for i=1, #joystick_registry do
		local joystick = joystick_registry[i]
        
        if joystick.active and joystick.visible and joystick.touch_id == id then
            local dx = x - joystick.outer_x
            local dy = y - joystick.outer_y
            local distance = math.sqrt((dx * dx) + (dy * dy))
            local scale = joystick.outer_radius / distance
            
            if distance <= joystick.outer_radius then
                joystick.inner_x = x
                joystick.inner_y = y
                joystick.dx = dx / joystick.outer_radius
                joystick.dy = dy / joystick.outer_radius
                joystick.magnitude = distance / joystick.outer_radius
            else
                joystick.inner_x = joystick.outer_x + (scale * (dx))
                joystick.inner_y = joystick.outer_y + (scale * (dy))
                joystick.dx = dx / distance
                joystick.dy = dy / distance
                -- joystick.dx = (joystick.inner_x - joystick.outer_x) / joystick.outer_radius
                -- joystick.dy = (joystick.inner_y - joystick.outer_y) / joystick.outer_radius
                joystick.magnitude = 1
            end
            break
        end
	end
end

function virtual_joystick.released(id)
	for i=1, #joystick_registry do
		local joystick = joystick_registry[i]
        if joystick.active and joystick.visible and joystick.touch_id == id then
            joystick.touch_id = nil
            joystick.inner_x = joystick.outer_x
            joystick.inner_y = joystick.outer_y
            joystick.dx = 0
            joystick.dy = 0
            joystick.magnitude = 0
            joystick.active = false
            break
        end
	end
end

function virtual_joystick.read_input(name)
    for i=1, #joystick_registry do
        local joystick = joystick_registry[i]
        if joystick.name == name then
        	return joystick.dx, joystick.dy, joystick.magnitude
        end
    end
    return 0, 0, 0
end

function virtual_joystick.draw()
	for i=1, #joystick_registry do
		local joystick = joystick_registry[i]
        if joystick.visible then
            love.graphics.setColor(joystick.outer_color)
            love.graphics.circle(
                "fill", 
                joystick.outer_x, 
                joystick.outer_y, 
                joystick.outer_radius
            )
            love.graphics.setColor(joystick.inner_color)
            love.graphics.circle(
                "fill", 
                joystick.inner_x, 
                joystick.inner_y, 
                joystick.inner_radius
            )
        end
	end
end

return virtual_joystick