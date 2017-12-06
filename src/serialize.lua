HighScore = require'src.HighScore'
local M = {}

-- Writes high scores into a file
function M.writeHighScores(scores)
    -- Create or erase the scores file in your game
    love.filesystem.write('scores.dat', "")
    -- Print all the score entries and their difficulty and mode on one line in a text file
    for i, highScore in pairs(scores) do
        love.filesystem.append('scores.dat', highScore:toString())
    end
end


-- Reads lines from the score.dat file. Returns a table of highScore objects
function M.readHighScores()
    local highScores = {}
    -- Read lines from the scores.dat file
    for line in love.filesystem.lines('scores.dat') do
        highScores[#highScores + 1] = M.scoreFromString(line)
    end
    return highScores
end


-- Creates a score object from a line of test in high score file
function M.scoreFromString(scoreString)
    local words = {}
    for word in string.gmatch(scoreString, "%S+") do
        words[#words + 1] = word
    end
    return HighScore(words[1], words[2], words[3], words[4],
            tonumber(words[5]))
end

return M