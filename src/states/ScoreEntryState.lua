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
        self.currentHighScores[#self.currentHighScores + 1] = HighScore(
                self.app.currentMode:gameTypeString(),
                self.app.currentMode.limit,
                self.app.currentMode:difficultyString(),
                table.concat(self.name, ""), self.app.game.score)
        table.sort(self.currentHighScores, function(a,b) return a.score>b.score end)
        if #self.currentHighScores > 10 then
            self.currentHighScores[#self.currentHighScores] = nil
        end
        
        for i, score in ipairs(self.currentHighScores) do
            self.otherHighScores[#self.otherHighScores + 1] = score
        end
        
        self.app.highScores = self.otherHighScores
        serialize.writeHighScores(self.app.highScores)
        
        self.app:changeState(HighScoreState(self.app))
    end
end


function ScoreEntryState:draw()
    AppState.draw(self)
    self.titleArea:printCenter("You got a high score!", 0)
    self.scoreArea:printCenter("Enter your name:", assets.blockSize)
    self.scoreArea:printCenter(table.concat(self.name, ""), assets.blockSize * 2)
    self.menuArea:printCenter("continue (enter)", 0)
end

return ScoreEntryState