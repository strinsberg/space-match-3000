Class = require'src.Class'
AppState = require'src.states.AppState'

local HighScoreState = Class(AppState)

function HighScoreState:init(app, newScore)
    AppState.init(self, app)
    self.currentScores = {}
    self:setCurrentScores()
    self.newScore = newScore or {score = 0, name = ""}
end

-- All updates for the state
function HighScoreState:update(dt)
    -- Super update
    AppState.update(self, dt)
end

-- Handle mouse events for the state
function HighScoreState:mousePressed(x, y, button)
    -- Super mouse pressed
    AppState.mousePressed(app, x, y, button)
end

-- Handle key press events for the state
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

-- Draw everything for the state
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


-- Helper Methods --

-- Set the current scores
function HighScoreState:setCurrentScores()
    self.currentScores = self:getCurrentScores()
end


-- Get high scores for the current difficulty, mode and limit
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

return HighScoreState