Class = require'src.Class'
AppState = require'src.appState.AppState'

local NameEntryState = Class(AppState)

function NameEntryState:init()
    -- Initialize the state
end

function NameEntryState:update(dt)
    -- All game updates for the state
end

function NameEntryState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function NameEntryState:keyPressed(key)
    -- Handle key press events for the state
    if key == 'backspace' and #gName > 0 then
        gName[#gName] = nil
    elseif key == 'return' then
        local diff = game.diffToString(gameDifficulty)
        local gmode = game.modeSaveString(gameMode)
        highScores[diff][gmode][#highScores[diff][gmode] + 1] = {mode = gmode,
                difficulty = diff, name = table.concat(gName, ""), score = board.score}
        state = SCORE
        -- sorts the table by score from highest to lowest
        table.sort(highScores[diff][gmode], function(a,b) return a.score>b.score end)
        -- If there are more than 10 scores remove the lowest score
        if #highScores[diff][gmode] > 10 then
            highScores[diff][gmode][#highScores[diff][gmode]] = nil
        end
        serial.writeHighScores(highScores)
    else
        for _, c in ipairs(validChars) do
            if key == c then
                gName[#gName + 1] = key:upper()
            end
        end
    end
end

function NameEntryState:draw()
    -- Draw everything for the state to the screen
    love.graphics.printf("You got a high score!", gameArea.x, gameArea.y, 320, 'center')
    love.graphics.printf("Enter your name", gameArea.x, gameArea.y + 80, 320, 'center')
    love.graphics.printf(table.concat(gName, ""), gameArea.x, gameArea.y + 120, 320, 'center')
    love.graphics.printf("(enter) to continue", gameArea.x,
        gameArea.y + 380, 320, 'center')
end


return NameEntryState