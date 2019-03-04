HighScore = require'src.HighScore'

---------------------------------------------------------------------
-- A collection of functions to serialize high score data
---------------------------------------------------------------------
local M = {}

-- path to high score file
local fname = 'scores.dat'

---------------------------------------------------------------------
-- Write high scores into a file.
-- scores -> a table of high scores
---------------------------------------------------------------------
function M.writeHighScores(scores)
    -- Create or erase the games high score data file
    love.filesystem.write(fname, "")
    
    -- Write all the high scores to the score data file
    for i, highScore in pairs(scores) do
        love.filesystem.append(fname,
                string.format("%s\n", highScore:toString()))
    end
end


---------------------------------------------------------------------
-- Reads high score data from score file.
-- return -> an array of HighScore objects
---------------------------------------------------------------------
function M.readHighScores()
    local highScores = {}

    -- Create and add a high score object from each line
    for line in love.filesystem.lines(fname) do
        highScores[#highScores + 1] = M.scoreFromString(line)
    end

    return highScores
end

---------------------------------------------------------------------
-- Create a HighScoreTable from a high score string.
-- scoreString -> a string representation of a high score
-- return -> a HighScore object
---------------------------------------------------------------------
function M.scoreFromString(scoreString)
    local words = {}
    
    -- Split the line up into words
    for word in string.gmatch(scoreString, "%S+") do
        words[#words + 1] = word
    end
    
    -- Create and return a high score object with the line contents
    return HighScore(words[1], words[2], words[3], words[4],
            tonumber(words[5]))
end

-- Return module
return M