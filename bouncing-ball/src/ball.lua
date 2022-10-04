local ball = {}

function ball:load()
  self.x = 168
  self.y = 0
  self.velx = love.math.random(-2, 2)
  self.vely = 0
  self.width = 16
  self.height = 16
  self.gravity = 0.1
end

function ball:update()
  self.vely = self.vely + self.gravity

  self.x = self.x + self.velx
  self.y = self.y + self.vely

  if self.x < 0 or self.x + self.width > game.width then
    self.velx = self.velx * -1
  end

  if self.y + self.height > game.height then
    game:finish()
  end
end

function ball:collide(x, y, r)
  return checkCircularCollision(self.x, self.y, x, y, self.width / 2, r)
end

function ball:bounce()
  self.velx = love.math.random(-2, 2)
  self.vely = -6
end

function ball:draw()
  love.graphics.push()
    love.graphics.translate(self.width / 2, self.height / 2)
    love.graphics.setColor(60 / 255, 60 / 255, 60 / 255)
    love.graphics.circle("fill", self.x, self.y, self.width / 2)
  love.graphics.pop()
end

return ball
