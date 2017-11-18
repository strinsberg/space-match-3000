Class = require'src.class'
view = require'src.view'

-- Probably so that some of this stuff can have update and key handling split into better method
-- Inidividual states should be in their own files
-- a package can be created for state

local M = {}


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


-- The main menu state------------------------------------------
local MainMenuState = Class(State)

function MainMenuState:init(app)
    State.init(self, app)
end

function MainMenuState:update(dt)
    -- Nothing
end

function MainMenu:mousePressed(x, y, button)
    -- Nothing
end

function MainMenuState:mousePressed(key)
    app.menu:action(key)
end

function MainMenuState:draw(dt)
    view.drawMainMenu(dt)
end


-- Game state ----------------------------------------------
local GameState = Class(State)

function GameState:init(app)
    State.init(self, app)
end

function GameState:update(dt)
    -- If the game is over
    if app.game.isOver then
        app.chagneState(GameOverState(app))
    end
    
    -- If a move has been made then check for matches
    -- may also be the answer for the mode update if it is a state.
    -- just check if a move has been made when you do mode update for the moves modes
    
    -- Here we have the creation of animations if the blocks need to be moved back
    -- also actually switch the items back
    -- set state to update
    
    -- Here is where mode constraints are updated
    -- game.mode.update() -- should both update moves/time and check if it is over and set game over if it is
        
end
-- a lot of these code chuncks should probably be in functions in another place. maybe game?
function GameState:mousePressed(x, y, button)
    -- get the row that was clicked on the board
    
    -- If the click is inbounds
        -- If button 2
            -- erase the selection
            
        -- elseif there is a selection and the attempted move is a valid one
            -- switch the iems
            -- create animations for the switch
            -- state change to update
            -- change the block that is the selection to invisible?? not sure what this does
            
            -- if there was a match created by either moved block
                -- switchBack is false
                -- selection and hint are nil
                -- check for matches is true
                
            -- else
                -- hint is nil -- duplicate code in the above part of the conditional
                -- switch back is true
                
        -- else
            -- set the selection to the clicked block
    
end

function GameState:keyPressed(key)
    app.menu:action(key)
end

function GameState:draw(dt)
    view.drawGame(dt)
end


return M