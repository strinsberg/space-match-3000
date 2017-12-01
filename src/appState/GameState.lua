Class = require'src.Class'
AppState = require'src.appState.AppState'
Screen = require'src.view.Screen'
GameSettingsPanel = require'src.view.panel.GameSettingsPanel'
ScorePanel = require'src.view.panel.ScorePanel'
BoardPanel = require'src.view.panel.BoardPanel'
MessagePanel = require'src.view.panel.MessagePanel'

local GameState = Class(AppState)

function GameState:init(app)
    -- Initialize the state
    AppState.init(self, app)
    self.limit = "" -- The variable for the current limit to display if there is one
    self.screen = Screen()
    self.screen:addPanel(GameSettingsPanel(app, 0, 160))
    self.screen:addPanel(ScorePanel(app, 560, 160))
    self.screen:addPanel(BoardPanel(app, 240, 160))
    self.screen:addPanel(MessagePanel(app, 240, 570, "(q)uit", 320))
end

function GameState:update(dt)
    -- Update limits
    if board.timeLimit then -- Update the time taken in the game
        board.timeTaken = board.timeTaken + dt
    end

    -- Update match score animations
    for i, animation in ipairs(scoreAnims) do
        animation:update(dt)
        if animation.finished then
            table.remove(scoreAnims, i)
        end
    end
end

function GameState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function GameState:keyPressed(key)
    -- Handle key press events for the state
    AppState.keyPressed(self, key)
end

function GameState:draw()
    -- Draw everything for the state to the screen
    -- Draw all items
    AppState.draw(self)
    self.screen:render()
    
    -- render the limit if there is one
    -- had trouble getting it to work properly with a panel class
    if board.moveLimit then
        love.graphics.printf(string.format("Moves Left: %s", (board.moveLimit - board.movesTaken)),
                0, 230, 240, 'center')
    elseif board.timeLimit then
        love.graphics.printf(string.format("Time Left: %s", secToMin(board.timeLimit - board.timeTaken)),
                0, 230, 240, 'center')
    end
end


return GameState
