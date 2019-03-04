Class = require'src.Class'
AppState = require'src.states.AppState'

---------------------------------------------------------------------
-- The state of the app for the high score screen
-- AppState -> The base state for app states
---------------------------------------------------------------------
local HighScoreState = Class(AppState)


---------------------------------------------------------------------
-- Initialize the state
-- app -> the app the state is part of
-- newScore -> a new high score
---------------------------------------------------------------------
function HighScoreState:init(app, newScore)
    AppState.init(self, app)
    self.currentScores = {}
    self:setCurrentScores()
    self.newScore = newScore or {score = 0, name = ""}
end

---------------------------------------------------------------------
-- Update the state
-- dt -> delta time
---------------------------------------------------------------------
function HighScoreState:update(dt)
    -- Super update
    AppState.update(self, dt)
end

---------------------------------------------------------------------
-- Handler for mouse events
-- x -> the x coord of the event
-- y -> the y coord of the event
-- button -> the mouse button pressed
---------------------------------------------------------------------
function HighScoreState:mousePressed(x, y, button)
    -- Super mouse pressed
    AppState.mousePressed(app, x, y, button)
end

---------------------------------------------------------------------
-- Handler for key press events
-- key -> the key pressed
---------------------------------------------------------------------
function HighScoreState:keyPressed(key)
    -- Super key pressed
    AppState.keyPressed(self, key)
    if key == 'return' then
        self.app:changeState(MainMenuState(self.app))
    elseif key == 'd' then
        self.app.currentMode:changeDifficulty()
        self:setCurrentScores()
    elseif key == 'm' then
        self.app.currentMode:changeGameType()
        self:setCurrentScores()
    end
end

---------------------------------------------------------------------
-- Draw the state information
---------------------------------------------------------------------
function HighScoreState:draw()
    -- Super draw
    AppState.draw(self)
    
    -- Print out the Mode, limit, and difficulty for the set of high scores
    self.titleArea:printCenter("-- HIGH SCORES --", 0)
    self.titleArea:printCenter(string.format("- %s %s %s -",
            self.app.currentMode:gameTypeString(),
            self.app.currentMode:limitToString(),
            self.app.currentMode:difficultyString()), assets.blockSize)
    
    -- Print out the list of scores for the current mode, limit, and difficulty
    for i, score in ipairs(self.currentScores) do
        if score.score == self.newScore.score
                and score.name == self.newScore.name then
            assets.setColor("green")
        end
        self.scoreArea:printCenter(score.score.." : "..score.name,
                (i * assets.fontSize) + 5)
        assets.setColor()
    end
    
    -- Print out the menu
    self.menuArea:printCenter("(d)ifficulty  -  (m)ode  -  (enter) Main Menu", 0)
    --self.menuArea:printCenter("(enter) for Main Menu", assets.fontSize)
    
end

---------------------------------------------------------------------
-- Set the current scores
---------------------------------------------------------------------
function HighScoreState:setCurrentScores()
    self.currentScores = self:getCurrentScores()
end


---------------------------------------------------------------------
-- Get high scores for the current difficulty, mode and limit
-- return -> an array of scores
---------------------------------------------------------------------
function HighScoreState:getCurrentScores()
    local scores = {}
    for i, score in ipairs(self.app.highScores) do
        -- If the score is from the current mode, limit and difficulty
        if score.gameType == self.app.currentMode:gameTypeString()
                and score.limit == self.app.currentMode:limitToString()
                and score.difficulty ==
                    self.app.currentMode:difficultyString() then
            -- add it to the current scores list
            scores[#scores + 1] = score
        end
    end
    return scores
end


-- Return the module
return HighScoreState