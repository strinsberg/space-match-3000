Class = require'src.Class'
AppState = require'src.states.AppState'

local HighScoreState = Class(AppState)

function HighScoreState:init(app)
    AppState.init(self, app)
    self.titleArea = ScreenArea(0, 120, app.width)
    self.scoreArea = ScreenArea(0, 160, app.width)
    self.menuArea = ScreenArea(0, 500, app.width)
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
    if key == 'c' then
        self.app:changeState(MainMenuState(self.app))
    elseif key == 'd' then
        self.app.currentMode:changeDifficulty()
    elseif key == 'm' then
        self.app.currentMode:changeGameType()
    end
end

-- Draw everything for the state
function HighScoreState:draw()
    -- Super draw
    AppState.draw(self)
    
    self.titleArea:printCenter(string.format("%s %s %s",
            self.app.currentMode:gameTypeString(),
            self.app.currentMode:limitToString(),
            self.app.currentMode:difficultyString()), 0)
    
    -- This is essentially the easiest way to work with high scores
    -- but it seems pretty resource intensive to just display scores
    -- with all the modes when there are 10 entries that is a lot of looping
    -- each cycle just to show a few lines
    local line = 0 -- line to display entries on
    for i, score in ipairs(self.app.highScores) do
        -- If the score is from the current mode and difficulty display it
        if score.gameType == self.app.currentMode:gameTypeString()
                and tonumber(score.limit) == self.app.currentMode.limit
                and score.difficulty ==
                self.app.currentMode:difficultyString() then
            -- Display the scores on consecutive lines
            self.scoreArea:printCenter(string.format("%s %s", score.score,
                    score.name), line * assets.fontSize)
            line = line + 1 -- Increment line
        end
    end
        
    self.menuArea:printCenter("(d)ifficulty  (m)ode  (c)ontinue", 0)
    
end

return HighScoreState