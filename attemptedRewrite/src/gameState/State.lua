Class = require'src.Class'

-- Probably so that some of this stuff can have update and key handling split into better method
-- Inidividual states should be in their own files
-- a package can be created for state


-- The Inteface for all states----------------------------------------
local State = Class()

function State:init(app)
    -- The code needed to construct the state
    self.app = app
end

function State:update(dt)
    -- All code to run during the update phase
end

function State:mousePressed(x, y, button)
    -- All code to handle a mouse press event
end

function State:keyPressed(key)
    -- All code to handle a key press event
end

function State:draw(dt)
    -- Some connection to the code that will do the view for the state
    -- Do not write render code in here, instead call veiw functions for
    -- -- the state. That way all the drawing code can be replaced without
    -- -- having to change the state code.
end

return State