local shape = {}
shape.__index = shape

local gameController = require("src/gameController")

local activeShapes = {}
local activeShadows = {}

local function shuffle(list)
    math.randomseed(os.time())

    shuffled = {}
    for i, v in ipairs(list) do
        local pos = math.random(1, #shuffled+1)
        table.insert(shuffled, pos, v)
    end
    return shuffled
end

local function createShapes(shapes, shapeSize)
    ScreenWidth = love.graphics:getWidth()
    ScreenHeight = love.graphics:getHeight()

    local margin = 100
    local spacing = (ScreenWidth - (2 * margin) - (#shapes * shapeSize))/(#shapes - 1)

    local shapes = shuffle(shapes)
    local shadows = shuffle(shapes)
    for i=1, #shapes do
        local x = margin + (i - 1)*spacing + (i - 1)*shapeSize
        local y = margin
        shape.new(x , margin, shapes[i])

        y = ScreenHeight - margin - shapeSize
        shape.new(x , y, shadows[i], true)
    end
end

local function intersects(table)
    if table.rectA ~= nil and table.rectA ~= nil then
        local a, b = table.rectA, table.rectB

        return a.x1 < b.x2 and a.x2 > b.x1 and a.y1 < b.y2 and a.y2 > b.y1

    elseif table.rect ~= nil and table.point ~= nil then 
        local rect = table.rect
        local x, y = table.point.x, table.point.y

        return x > rect.x and x < rect.x + rect.width and y > rect.y and y < rect.y + rect.height
    end
end

local function shadowMatch(instance)
    for i, shadow in ipairs(activeShadows) do
        if shadow.matched == false 
            and intersects{
                rectA = { x1 = shadow.x, x2 = shadow.x + shadow.width, y1 = shadow.y, y2 = shadow.y + shadow.height},
                rectB = { x1 = instance.x, x2 = instance.x + instance.width, y1 = instance.y, y2 = instance.y + instance.height}
            }
            and shadow.shapeName == instance.shapeName then 
                return shadow 
        end
    end
end

function shape.init(shapes, shapeSize)
    createShapes(shapes, shapeSize)
end

function shape.reset()
    activeShapes = {}
    activeShadows = {}
end

function shape.new(x, y, shapeName, shadow)
    local instance = setmetatable({}, shape)
    instance.startX = x
    instance.startY = y
    instance.x = x
    instance.y = y
    instance.shapeName = shapeName

    instance.image = love.graphics.newImage("assets/" .. shapeName .. ".png")
    instance.width = instance.image:getWidth()
    instance.height = instance.image:getHeight()

    instance.matched = false

    if shadow then
        table.insert(activeShadows, instance)
    else
        instance.dragging = {
            active = false,
            distX = 0,
            distY = 0
        }

        table.insert(activeShapes, instance)
    end
end

function shape.updateAll(dt)
    for i, instance in ipairs(activeShapes) do 
        instance:update(dt)
    end
end

function shape:update(dt)
    if self.dragging.active then
        self.x = love.mouse.getX() - self.dragging.distX
        self.y = love.mouse.getY() - self.dragging.distY
    end
end

function shape.drawAll()
    love.graphics.setColor(72/255, 48/255, 53/255, 1)
    for i, instance in ipairs(activeShadows) do 
        instance:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)
    for i, instance in ipairs(activeShapes) do 
        instance:draw()
    end
end

function shape:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 1, 1)
end

function shape.mousepressed(x, y)
    for i, instance in ipairs(activeShapes) do 
        if instance.matched == false and intersects{ rect = instance, point = { x = x, y = y} }  then
            instance.dragging.active = true
            instance.dragging.distX = x - instance.x
            instance.dragging.distY = y - instance.y
            return
        end
    end
end

function shape.mousereleased(x, y)
    for i, instance in ipairs(activeShapes) do 
        if instance.dragging.active then

            instance.dragging.active = false
            local shadow = shadowMatch(instance)

            if shadow ~= nil then
                shadow.matched = true
                instance.matched = true
                instance.x = shadow.x
                instance.y = shadow.y

                gameController:addMatch()
            else
                instance.x = instance.startX
                instance.y = instance.startY
            end
            return
        end
    end
end

return shape