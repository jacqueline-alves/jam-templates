require("src/game")
require("src/utils")

local player = require("src/player")
local ball = require("src/ball")

function reset()
  game:start()
  player:load()
  ball:load()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if game:isDone() and key == "return" then
    reset()
  end
end

function love.load()
  game:load()
  player:load()
  ball:load()

  love.window.setTitle("bouncing ball")
  love.window.setMode(game.width * game.scale, game.height * game.scale)

  love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(delta)
  if game:isDone() then return end

  -- controle de frames entre dispositivos
  if 1 / 60 > delta then
    love.timer.sleep(1 / 60 - delta)
  end

  if love.keyboard.isDown("left") then
    player:moveLeft()
  end

  if love.keyboard.isDown("right") then
    player:moveRight()
  end

  if ball:collide(player.x, player.y, player.height / 3) then
    ball:bounce()
  end

  player:update()
  ball:update()
end

function love.draw()
  love.graphics.scale(game.scale, game.scale)
  love.graphics.clear(38 / 255, 201 / 255, 255 / 255)

  if game:isDone() then
    love.graphics.printf("pressione [enter] para jogar!", 0, game.height / 2, game.width, "center")
  else
    player:draw()
    ball:draw()
  end
end
