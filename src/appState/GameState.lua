Class = require'src.Class'
AppState = require'src.appState.AppState'

local GameState = Class(AppState)

function GameState:init()
    -- Initialize the state
end

function GameState:update(dt)
    -- All game updates for the state
    -- The game is over change stuff
    if gameOver then
        state = END
        for i, menuItem in ipairs(mainMenu.items) do
            if menuItem.id == 'r' then
                table.remove(mainMenu.items, i)
            end
        end
    end
    
    -- this needs a way to only happen if it needs to like a variable check or something
    -- that sets to true and false so that these checks only happen once
    -- Check for matches and update the board if need be
    if checkForMatches then
        local matchScores = board:checkForMatches()
        for i = 1, #matchScores do
            table.insert(scoreAnims, anims.statAnim:new{x = scoreArea.x, y = scoreArea.y,
                image = matchScores[i]})
        end
        if board.matches == true then
            local movedItems = board:update(itemSize)
            for i, item in ipairs(movedItems) do
                local animation = anims.constructMSA(item.column, item.row, item.column,
                        item.newRow, item.item)
                table.insert(blockingAnims, animation)
            end
            state = UPDATE
            board.modifier = board.modifier + 1
        else
            -- update a variable for wether or not the board needs to be checked for matches again
            checkForMatches = false
            board.modifier = 1
            if not board:hasMoves() then
                board:set()
                table.insert(animations, anims.statAnim:new{x = gameArea.x + 50,
                        y = gameArea.y - 50, image = "Reset: No Moves!", duration = 2})
            end
        end
    end
            
    -- Create itemAnimations for switching back players move if it did not create a match
    if switchBack then
        board:switchItems(board.selection.row, board.selection.column, rowClick, columnClick)
        table.insert(blockingAnims, anims.constructMSA(columnClick, rowClick,
                board.selection.column, board.selection.row,
                board.items[board.selection.row][board.selection.column].item))
        table.insert(blockingAnims, anims.constructMSA(board.selection.column,
                board.selection.row, columnClick, rowClick,
                board.items[rowClick][columnClick].item))
        state = UPDATE
        board.selection = nil
        switchBack = false
    end

    -- End game if any of the game constraints are surpassed
    if board.timeLimit then
        if board.timeTaken > board.timeLimit then
            gameOver = true
        end
    elseif board.moveLimit then
        if board.movesTaken >= board.moveLimit then
            gameOver = true
        end
    end
end

function GameState:mousePressed(x, y, button)
    -- Handle mouse events for the state
    rowClick = math.floor( ((y - gameArea.y) / itemSize) + 1)
    columnClick = math.floor( ((x - gameArea.x) / itemSize) + 1 )
    if state == GAME and clickInBounds(x, y, gameArea) then
        if button == 2 then
            board.selection = nil
        -- If there is a selected item and the move would be valid
        elseif board.selection and
                board:validMove(board.selection.row, board.selection.column,
                    rowClick, columnClick) then
            -- Switch the items
            board:switchItems(board.selection.row, board.selection.column, rowClick, columnClick)
            -- Create animations for the switch
            table.insert(blockingAnims, anims.constructMSA(columnClick, rowClick,
                board.selection.column, board.selection.row,
                board.items[board.selection.row][board.selection.column].item))
            table.insert(blockingAnims, anims.constructMSA(board.selection.column,
                board.selection.row, columnClick, rowClick,
                board.items[rowClick][columnClick].item))
            state = UPDATE
            board.selection.visible = false
            -- If the move created a match
            if board:itemIsMatched(rowClick, columnClick) or
                    board:itemIsMatched(board.selection.row, board.selection.column) then
                -- Leave the items where they are
                switchBack = false
                board.selection = nil
                hintPosition = nil
                -- Update moves taken if appropriate
                if board.moveLimit or gameMode == game.mode.endless then
                    board.movesTaken = board.movesTaken + 1
                end
                -- add a variable to wether or not the board should be checked for matches
                checkForMatches = true
            else
                -- Switch the items back
                switchBack = true
                hintPosition = nil
            end
        else
            -- Select the item that was clicked
            board.selection = {row = rowClick, column = columnClick, visible = true}
        end
    end
end

function GameState:keyPressed(key)
    -- Handle key press events for the state
    if key == "p" then
        mainMenu:addItem('r', "(R)esume Game", resumeGame)
        state = MENU
    elseif key == 'q' then
        gameOver = true
    elseif key == 'h' then
        if hintPosition then
            hintPosition = nil
        else
            local itemWithMove = board:hasMoves()
            if itemWithMove then
                hintPosition = itemWithMove
            end
        end
    end
end

function GameState:draw()
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


return GameState