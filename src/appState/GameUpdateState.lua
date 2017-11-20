Class = require'src.Class'
AppState = require'src.appState.AppState'

-- Needs to inherit from the gamestate so that it can share those methods.
-- this way anything that needs to be in both can be. mostly the draw function
-- same goes for the pause state

local GameUpdateState = Class(AppState)

function GameUpdateState:init()
    -- Initialize the state
end

function GameUpdateState:update(dt)
    -- All game updates for the state
    -- Update the animations that are not finished
    for i, animation in ipairs(blockingAnims) do
        if not animation.finished then
            animation:update(dt)
        end
    end
    -- Remove all finished animations
    -- Had to put in another loop because the removeal of objects from the table mid loop
    -- seems to skip updating some of the animations. Though the max animations is 64 so it
    -- should not be a performance drain
    for i, animation in ipairs(blockingAnims) do
        if animation.finished then
            table.remove(blockingAnims, i)
            board.items[(animation.y / itemSize) + 1][(animation.x / itemSize) + 1].visible = true
        end
    end
    if #blockingAnims == 0 then
        state = GAME
    end
end

function GameUpdateState:mousePressed(x, y, button)
    -- Handle mouse events for the state
end

function GameUpdateState:keyPressed(key)
    -- Handle key press events for the state
end

function GameUpdateState:draw()
    -- Draw everything for the state to the screen
    -- Draw all items
    local row, column
    for row = 1, board.rows do
        for column = 1, board.columns do
            if board.items[row][column].item > 0 and -- If the item is not empty
                    board.items[row][column].visible then -- If the item is visible
                love.graphics.draw(itemImages[ board.items[row][column].item ],
                        columnX(column), rowY(row))
            end
        end
    end
    
    -- Draw the hint item if exists
    if hintPosition then
        love.graphics.draw(hintImg, columnX(hintPosition.column), rowY(hintPosition.row))
    end
    
    -- Draw the selected item if there is one
    if board.selection and board.selection.visible then
        love.graphics.draw(selectionImg, columnX(board.selection.column),
                rowY(board.selection.row))
    end

    -- Draw any blocking animations
    for i, animation in ipairs(blockingAnims) do
        if animation.y > -itemSize then
            love.graphics.draw(itemImages[animation.image], animation.x + gameArea.x,
                    animation.y + gameArea.y)
        end
    end
    
    -- Draw non blocking animations
    for i, animation in ipairs(animations) do
        love.graphics.print(animation.image, animation.x, animation.y)
    end
    
    -- Draw score animations
    love.graphics.printf("Match Scores", scoreArea.x, scoreArea.y + 80, 240, 'center')
    for i, animation in ipairs(scoreAnims) do
        love.graphics.printf(animation.image, animation.x,
                animation.y + 90 + (i * fontSize), 240, 'center')
    end
    
    -- Draw the score etc
    love.graphics.printf(string.format("Score: %s", board.score),  scoreArea.x,
            scoreArea.y, 240, 'center')
    love.graphics.printf(string.format("Mode: %s", game.modeToString(gameMode)),
            infoArea.x, infoArea.y + 40, 240, 'center')
    love.graphics.printf(string.format("Difficulty: %s", game.diffToString(board.difficulty)),
            infoArea.x, infoArea.y, 240, 'center')
    if board.modifier > 3 then
        love.graphics.setColor(0, 255, 0, 255)
    elseif board.modifier > 5 then
        love.graphics.setColor(255, 0, 0, 255)
    end
    love.graphics.printf(string.format("Mod: %s", board.modifier), scoreArea.x,
            scoreArea.y + 40, 240, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    
    -- For the mode constraints if they exist
    if board.moveLimit then
        love.graphics.printf(string.format("Moves: %s", board.movesTaken), infoArea.x,
                infoArea.y + 80, 240, 'center')
    elseif board.timeLimit then
        love.graphics.printf(string.format("Time: %s", secToMin(board.timeLimit - board.timeTaken)),
                infoArea.x, infoArea.y + 80, 240, 'center')
    end
    
    -- Some info
    love.graphics.printf("(h)int", gameArea.x, gameArea.y + 380,
            320, 'left')
    love.graphics.printf("(p)ause", gameArea.x, gameArea.y + 380,
            320, 'center')
    love.graphics.printf("(q)uit", gameArea.x, gameArea.y + 380,
            320, 'right')
end

return GameUpdateState