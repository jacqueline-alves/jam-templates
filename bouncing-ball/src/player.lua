local player = {}

function player:load()
  self.x = 165
  self.y = 222
  self.velx = 3
  self.width = 22
  self.height = 34
end

function player:update()
  if self.x < 0 then
    self.x = 0
  end

  if self.x + self.width > game.width then
    self.x = game.width - self.width
  end
end

function player:moveLeft()
  self.x = self.x - self.velx
end

function player:moveRight()
  self.x = self.x + self.velx
end

function player:draw()
  love.graphics.setColor(120 / 255, 120 / 255, 120 / 255)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return player
