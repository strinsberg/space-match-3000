Class = require'src.Class'
AppState = require'src.states.AppState'
HighScoreState = require'src.states.HighScoreState'


local ScoreEntryState = Class(AppState)


---------------------------------------------------------------------
-- Initialize the state
-- app -> the app the state is part of
---------------------------------------------------------------------
function ScoreEntryState:init(app, currentHighScores, otherHighScores)
    AppState.init(self, app)
    self.currentHighScores = currentHighScores
    self.otherHighScores = otherHighScores
    if self.app.name then
        self.name = self.app.name
    else
        self.name = {}
    end
    self.validChars = "abcdefghijklmnopqrstuvwxyz"
end


---------------------------------------------------------------------
-- Update the state
-- dt -> delta time
---------------------------------------------------------------------
function ScoreEntryState:update(dt)
    AppState.update(self, dt)
end


---------------------------------------------------------------------
-- Handler for mouse events
-- x -> the x coord of the event
-- y -> the y coord of the event
-- button -> the mouse button pressed
---------------------------------------------------------------------
function ScoreEntryState:mousePressed(x, y, button)
    AppState.mousePressed(self, x, y, button)
end


---------------------------------------------------------------------
-- Handler for key press events
-- key -> the key pressed
---------------------------------------------------------------------
function ScoreEntryState:keyPressed(key)
    AppState.keyPressed(self, key)
    if string.find(self.validChars, key) then
        self.name[#self.name + 1] = key:upper()
    elseif key == 'backspace' and #self.name > 0 then
        self.name[#self.name] = nil
    elseif key == 'return' then
        if table.concat(self.name) == "" then
            self.name = {"?","?","?"}
        end
        self.app.name = self.name
        -- Create a score object for the new score
        local playerScore = HighScore(
                self.app.currentMode:gameTypeString(),
                self.app.currentMode:limitToString(),
                self.app.currentMode:difficultyString(),
                table.concat(self.name, ""), self.app.game.score)
        -- Add the player score to the high scores for the mode
        self.currentHighScores[#self.currentHighScores + 1] = playerScore
        -- Sort the scores from highest to lowest
        table.sort(self.currentHighScores,
                function(a,b) return a.score>b.score end)
        -- If adding the new score put the number of scores over 10
        -- Set the last and lowest score to nil
        if #self.currentHighScores > 10 then
            self.currentHighScores[#self.currentHighScores] = nil
        end
        -- Add all the current scores back together
        -- with the rest of the high scores for other modes etc.
        for i, score in ipairs(self.currentHighScores) do
            self.otherHighScores[#self.otherHighScores + 1] = score
        end
        -- Set the apps high scores to the new full high score list
        self.app.highScores = self.otherHighScores
        -- Serialize the new high scores
        serialize.writeHighScores(self.app.highScores)
        -- Change state to the high score screen
        self.app:changeState(HighScoreState(self.app, playerScore))
    end
end


---------------------------------------------------------------------
-- Draw the state information
---------------------------------------------------------------------
function ScoreEntryState:draw()
    AppState.draw(self)
    assets.setColor('green')
    self.titleArea:printCenter("-- NEW HIGH SCORE --", 0)
    assets.setColor()
    self.scoreArea:printCenter("Final Score: "..self.app.game.score,
            assets.fontSize)
    self.scoreArea:printCenter("Enter Your Name: "..table.concat(self.name, ""),
            assets.fontSize * 3)
    self.menuArea:printCenter("(enter) Continue", 0)
end


-- Return the module
return ScoreEntryState