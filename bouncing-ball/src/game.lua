game = {}

GAMESTATE = {
  START = 'start',
  DONE = 'done'
}

function game:load()
  self.width = 352
  self.height = 256
  self.scale = 3
  self.state = GAMESTATE.DONE
end

function game:finish()
  self.state = GAMESTATE.DONE
end

function game:isDone()
  return self.state == GAMESTATE.DONE
end

function game:start()
  self.state = GAMESTATE.START
end
