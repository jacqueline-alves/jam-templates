local gameController = {}
GameState = { playing = "playing", win = "win" }

function gameController:init(shapeCount)
    self.shapeCount = shapeCount
    self.matchedShapes = 0
    self.state = GameState.playing
end

function gameController:reset()
    self.shapeCount = 0
    self.matchedShapes = 0
end

function gameController:addMatch()
    self.matchedShapes = self.matchedShapes + 1
    if self.matchedShapes >= self.shapeCount then
        self.state = GameState.win
    end
end

return gameController
