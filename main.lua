push = require 'push'
Class = require 'class'
require "XO"
require "PlayState"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- one square with sides of 72 pixels


function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('linear', 'linear')

    love.window.setTitle('X/O')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.mouse.buttonsPressed = {}

    playstate = PlayState()
end

function love.mousepressed(x, y, button)
    -- Chuyển tọa độ chuột từ thực sang ảo
    local virtualX, virtualY = push:toGame(x, y)

    if virtualX and virtualY then  
        love.mouse.buttonsPressed[button] = {pressed = true, x = virtualX, y = virtualY}
    end
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button] and love.mouse.buttonsPressed[button]["pressed"]
end

function love.update(dt)

    playstate:update(dt)

    if playstate.reset == true then
        playstate = PlayState()
    end
end

function love.draw()
    push:start()

    -- draw chessboard
    love.graphics.clear(1,1,1)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(1)

    a = 25 -- a là số đường kẻ dọc
    -- số ô tương ứng là (a-1)*(a-1)
    for i = (0-(a/2-1)),(a/2) do
        love.graphics.line(VIRTUAL_WIDTH/2 - 144/(a-1) + i * 288/(a-1), 0, VIRTUAL_WIDTH/2 - 144/(a-1) + i * 288/(a-1), VIRTUAL_HEIGHT - 0)

        love.graphics.line(VIRTUAL_WIDTH/2 - 144/(a-1) + (-a/2 + 1) * 288/(a-1), VIRTUAL_HEIGHT / 2 - 144/(a-1) + i * 288/(a-1), VIRTUAL_WIDTH - (VIRTUAL_WIDTH/2 - 144/(a-1) + (-a/2 + 1) * 288/(a-1)), VIRTUAL_HEIGHT / 2 - 144/(a-1) + i * 288/(a-1))
    end


    playstate:render()

    -- draw reset button
    love.graphics.setColor(0,0,1)
    
    love.graphics.rectangle("fill", 422, 144-12, 60, 32)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print("reset", 422, 144-12)

    push:finish()
end



