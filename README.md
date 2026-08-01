# 🕹️ LÖVE2D Virtual Joystick

A lightweight, modular, and touch-responsive virtual joystick library for **LÖVE2D**. Built to handle multi-touch mobile inputs seamlessly with automatic vector normalization, clamping, and zero external dependencies.

---

## ✨ Features

* **Multi-Touch ID Locking:** Binds specific `touch_id` events to each joystick instance so multiple fingers (e.g., joystick + buttons) don't interfere with each other.
* **Vector Normalization & Clamping:** Automatically calculates direction vectors (`dx`, `dy`) and clamps handle movement cleanly within the outer boundary radius.
* **State Hygiene:** Automatically resets touch inputs and direction vectors when joysticks are hidden or released.
* **Decoupled Architecture:** Easy to integrate into existing game loops with minimal boilerplate.

---

## 📁 Repository Structure

```text
love2d-virtual-joystick/
├── src/
│   └── virtual_joystick.lua  # Core Library Module
├── main.lua                  # Runnable Demo Application
├── conf.lua
└── README.md
```

---

## 🚀 Quick Start

### 1. Import the Module
Place `virtual_joystick.lua` in your project's source directory (e.g., `src/`).

### 2. Basic Example (`main.lua`)

```lua
local virtual_joystick = require("src.virtual_joystick")

local player = { x = 400, y = 300, speed = 300, radius = 50 }
local center = { x = 0, y = 0 }
local width, height = 0, 0

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    center.x = width / 2
    center.y = height / 2

    player.x = center.x
    player.y = center.y

    -- Create a joystick named "move" near the bottom center
    virtual_joystick.create_joystick(
        "move",
        center.x,
        center.y + 300,
        60,
        {0.7, 0.7, 0.7, 0.5},
        30,
        {0.9, 0.9, 0.9, 0.5}
    )
end

-- Route LÖVE touch events to the module
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
    -- Read normalized direction (dx, dy)
    local dx, dy, _magnitude = virtual_joystick.read_input("move")
    
    -- Framerate-independent movement
    player.x = player.x + (player.speed * dx * dt)
    player.y = player.y + (player.speed * dy * dt)

    -- Screen boundary clamping
    if player.x >= width - player.radius then player.x = width - player.radius end
    if player.x <= player.radius then player.x = player.radius end
    if player.y >= height - player.radius then player.y = height - player.radius end
    if player.y <= player.radius then player.y = player.radius end
end

function love.draw()
    -- Draw Player
    love.graphics.setColor(0.8, 0.4, 0, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
    
    -- Draw Joysticks
    virtual_joystick.draw()
end
```

---

## 📖 API Reference

### `virtual_joystick.create_joystick(name, x, y, [outer_radius], [outer_color], [inner_radius], [inner_color])`
Registers a new virtual joystick instance.
* **`name`** *(string)*: Unique identifier for reading input later.
* **`x, y`** *(numbers)*: Screen position for the center of the joystick.
* **`outer_radius`** *(number, optional)*: Boundary radius (default: `60`).
* **`outer_color`** *(table, optional)*: RGBA color array `{r, g, b, a}`.
* **`inner_radius`** *(number, optional)*: Handle knob radius (default: `20`).
* **`inner_color`** *(table, optional)*: RGBA color array `{r, g, b, a}`.

---

### `virtual_joystick.read_input(name)`
Returns current movement data for a registered joystick.
* **Returns:** `dx` *(number)*, `dy` *(number)*, `magnitude` *(number)*
  * `dx` and `dy` range from `-1.0` to `1.0`.
  * `magnitude` ranges from `0.0` to `1.0`.

---

### `virtual_joystick.set_visibility(name, visibility)`
Shows or hides a specific joystick by name.
* Automatically resets input state (`dx = 0, dy = 0`) if hidden while active.

---

### Event Handlers
Pass native LÖVE callbacks directly into these functions:
* `virtual_joystick.pressed(id, x, y)`
* `virtual_joystick.moved(id, x, y)`
* `virtual_joystick.released(id)`

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
