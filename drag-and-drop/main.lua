local gameController = require("src/gameController")
local shape = require("src/shape")

local function init()
    local shapes = { "square", "circle", "triangle", "pentagon" }
    gameController:init(#shapes)
    shape.init(shapes, 100)
end

local function reset() 
    shape.reset()
    gameController:reset()
    init()
end

function love.load()
    ScreenWidth = love.graphics:getWidth()
    ScreenHeight = love.graphics:getHeight()
    init()
end

function love.update(dt)
    shape.updateAll()
end

function love.draw()
    love.graphics.setBackgroundColor( 1, 1, 1, 1 )

    if gameController.state == GameState.win then
        local text = "you won!!!\n\n\npress space to play again"
        local x = ScreenWidth/2- love.graphics.getFont():getWidth(text) / 2
        local y = ScreenHeight/2 - love.graphics.getFont():getHeight(text)*3
    
        love.graphics.setColor(34/255, 34/255, 34/255, 1)
        love.graphics.print(text, x, y) 
    else
        shape.drawAll()
    end
end

function love.keypressed(key)
    if gameController.state == GameState.win then 
        reset()
    end
end

function love.mousepressed(x, y, button, istouch)
    shape.mousepressed(x, y)
end

function love.mousereleased(x, y, button)
    shape.mousereleased(x, y)
end