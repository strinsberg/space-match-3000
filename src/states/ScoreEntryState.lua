Class = require'src.Class'
AppState = require'src.states.AppState'
HighScoreState = require'src.states.HighScoreState'


local ScoreEntryState = Class(AppState)

function ScoreEntryState:init(app, currentHighScores, otherHighScores)
    AppState.init(self, app)
    self.currentHighScores = currentHighScores
    self.otherHighScores = otherHighScores
    self.name = {}
    self.validChars = "abcdefghijklmnopqrstuvwxyz"
end


function ScoreEntryState:update(dt)
    AppState.update(self, dt)
end


function ScoreEntryState:mousePressed(x, y, button)
    AppState.mousePressed(self, x, y, button)
end


function ScoreEntryState:keyPressed(key)
    AppState.keyPressed(self, key)
    if string.find(self.validChars, key) then
        self.name[#self.name + 1] = key:upper()
    elseif key == 'backspace' and #self.name > 0 then
        self.name[#self.name] = nil
    elseif key == 'return' then
        -- Add the new score to the high scores for the mode
        self.currentHighScores[#self.currentHighScores + 1] = HighScore(
                self.app.currentMode:gameTypeString(),
                self.app.currentMode.limit,
                self.app.currentMode:difficultyString(),
                table.concat(self.name, ""), self.app.game.score)
        -- Sort the scores from highest to lowest
        table.sort(self.currentHighScores, function(a,b) return a.score>b.score end)
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
        self.app:changeState(HighScoreState(self.app))
    end
end


function ScoreEntryState:draw()
    AppState.draw(self)
    self.titleArea:printCenter("-- New High Score --", 0)
    self.scoreArea:printCenter(string.format("Final Score: %s",
        self.app.game.score), assets.blockSize)
    self.scoreArea:printCenter("Enter your name:", assets.blockSize * 2)
    self.scoreArea:printCenter(table.concat(self.name, ""), assets.blockSize * 3)
    self.menuArea:printCenter("continue (enter)", 0)
end

return ScoreEntryState