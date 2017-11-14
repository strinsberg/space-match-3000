local M = {}

-- Takes a table with high score objects in it and writes it to the scores.dat file
-- High score objects must be of the format
-- {mode = "validGameMode", name = "playerName", score = highScoreNum}
function M.writeHighScores (scores)
    -- Create or erase the scores file in your game
    love.filesystem.write('scores.dat', "")
    -- Print all the score entries and their difficulty and mode on one line in a text file
    for diff, _ in pairs(scores) do
        for mode, _  in pairs(scores[diff]) do
            for _, scr in ipairs(scores[diff][mode]) do
                love.filesystem.append('scores.dat', string.format("%s %s %s %s\n", scr.mode,
                        scr.difficulty, scr.name, scr.score))
            end
        end
    end
end


-- Helper function to create a score object from a line of text in the high score file
-- Again this is only compatable if the text follows the format "mode name score"
local scoreFromString = function (scoreString)
    local words = {}
    for word in string.gmatch(scoreString, "%S+") do
        words[#words + 1] = word
    end
    return {mode = words[1], difficulty = words[2], name = words[3], score = tonumber(words[4])}
end

-- Reads from the file saved by love filesystem by default, but when that does not exits it
-- will read from the one in the archive. so you can set a default scores file to save
-- scores for there to be in the game on the first run there to ship with game.
-- Reads lines from the score.dat file and returns a table with score objects in it
function M.readHighScores()
    local scores = {}
    -- Read lines from the scores.dat file
    for line in love.filesystem.lines('scores.dat') do
        local score = scoreFromString(line)
        if not scores[score.difficulty] then
            scores[score.difficulty] = {}
        end
        if not scores[score.difficulty][score.mode] then
            scores[score.difficulty][score.mode] = {}
        end
        scores[score.difficulty][score.mode][#scores[score.difficulty][score.mode] + 1] = score
    end
    return scores
end

return M