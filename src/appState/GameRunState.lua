Class = require'src.Class'
GameState = require'src.appState.GameState'
GameOverState = require'src.appState.GameOverState'
GamePauseState = require'src.appState.GamePauseState'
GameUpdateState = require'src.appState.GameUpdateState'

local GameRunState = Class(GameState)

function GameRunState:init(app)
    GameState.init(self, app)
end

function GameRunState:update(dt)
    -- All game updates for the state
    GameState.update(self, dt)
    -- all the code that is not shared with update should go here
    if gameOver then
        self.app.changeState(GameOverState(self.app))
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
            self.app.changeState(GameUpdateState(self.app))
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

function GameRunState:mousePressed(x, y, button)
    -- Handle mouse events for the state
    rowClick = math.floor( ((y - gameArea.y) / itemSize) + 1)
    columnClick = math.floor( ((x - gameArea.x) / itemSize) + 1 )
    if clickInBounds(x, y, gameArea) then
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
            self.app.changeState(GameUpdateState(self.app))
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

function GameRunState:keyPressed(key)
    -- Handle key press events for the state
    GameState.keyPressed(self, key)
    if key == "p" then
        self.app.changeState(GamePauseState(self.app))
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

function GameRunState:draw()
    -- Draw everything for the state to the screen
    GameState.draw(self)
    -- all of the code that draws the menu should go here since that is
    -- the only thing that is unique to this state
        -- Some info
    love.graphics.printf("(h)int" , gameArea.x, gameArea.y + 380,
            320, 'left')
    love.graphics.printf("(p)ause", gameArea.x, gameArea.y + 380,
            320, 'right')
end

return GameRunState
