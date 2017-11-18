game = require('src/game')
anims = require('src/animations')
menu = require('src/menu')
serial = require('src/serialize')

-- Get new random number set
math.randomseed( os.time() )

-- Other variables
gameTitle = "Space Match 3000"
version = "v2.0"
creator = "Plimpton Productions 2017"
rowClick = 0
columnClick = 0
switchBack = false
gameMode = game.mode.endless
gameDifficulty = game.difficulty.easy
highScores = {{mode = "Endless", name = "jon", score = 1000}}
gName = {}
checkForMatches = false
hintPosition = nil
helpString = "Menu items can be activated with the key in brackets.\nEx. (q)uit - press \"q\" to quit.\n\nIn game the \"left-mouse-button\" selects an item. If the next \"left\" click is on an adjacent item the selected item will be switched with that item.\nThe \"right-mouse-button\" removes the selection.\n\nPressing \"h\" during the game will highlight an item that can be matched, \"p\" will pause and return to the main menu, and \"q\" will end the game prematurely."
validChars = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q",
        "r", "s", "t", "u", "v", "w", "x", "y", "z"}

-- Change the difficulty
function cycleDifficulty()
    if gameDifficulty == game.difficulty.hard then
        gameDifficulty = game.difficulty.easy
    else
        gameDifficulty = gameDifficulty + 1
    end
end

-- Change the game mode
function cycleMode()
    if gameMode == game.mode.timed300 then
        gameMode= game.mode.endless
    else
        gameMode = gameMode + 1
    end
end

-- Drawing areas
gameArea = {x = 240, y = 160, x2 = 560, y2 = 480}
scoreArea = {x = 560, y = 160}
infoArea = {x = 0, y = 160}

function clickInBounds (x, y, bounds)
    if x > bounds.x and x < bounds.x2 and
            y > bounds.y and y < bounds.y2 then
        return true
    else
        return false
    end
end

-- State Constants
MENU = 1
UPDATE = 2
GAME = 3
END = 4
NAME = 5
SCORE = 6
HELP = 7

state = MENU

-- Tables to hold animations
animations = {} -- Non blocking animations
blockingAnims = {} -- Animations that block all action
scoreAnims = {} -- Animations for scores of individual matches


-- Create new board and random setup and start the game
function newGame ()
    board = game.board:new{difficulty = gameDifficulty, mode = gameMode}
    board:set()
    board:setLimits()
    state = GAME
    gameOver = false
end

function scoreScreen()
    state = SCORE
end

function helpScreen()
    state = HELP
end

-- Create some menus
mainMenu = menu.menu:new{title = "Main Menu"}
mainMenu:addItem("n", "(n)ew Game", newGame)
mainMenu:addItem("d", "Change (d)ifficulty", cycleDifficulty)
mainMenu:addItem("m", "Change (m)ode", cycleMode)
mainMenu:addItem("s", "High (s)cores", scoreScreen)
mainMenu:addItem("h", "(h)elp", helpScreen)
mainMenu:addItem("q", "(q)uit", love.event.quit)

currentMenu = mainMenu


-- set state to GAME
function resumeGame()
    state = GAME
end

-- get corrds from row or column
function columnX (column)
    return ((column - 1) * itemSize) + gameArea.x
end

function rowY (row)
    return ((row - 1) * itemSize) + gameArea.y
end

-- display seconds as minute:seconds
function secToMin (seconds)
    local t = nil
    local sec = math.floor(seconds % 60)
    local minutes = math.floor(seconds / 60)
    if sec < 10 then
        t = string.format("%s:0%s", minutes, sec)
    else
        t = string.format("%s:%s", minutes, sec)
    end
    return t
end

-- Allows for a high score screen

--image loading-------------------------------------------
function love.load(arg)
    
    -- Backgorund image
    background = love.graphics.newImage('assets/background.png')
    
    -- Load all the item images and save them in a table
    itemImages = {
    love.graphics.newImage('assets/blue.png'),
    love.graphics.newImage('assets/green.png'),
    love.graphics.newImage('assets/yellow.png'),
    love.graphics.newImage('assets/red.png'),
    love.graphics.newImage('assets/purple.png'),
    love.graphics.newImage('assets/silver.png')
    }
    itemSize = itemImages[1]:getWidth()
    
    -- Load selction image
    selectionImg = love.graphics.newImage('assets/selection.png')
    hintImg = love.graphics.newImage('assets/hint.png')
    
    -- Fonts
    fontSize = 35
    font = love.graphics.newFont('assets/YandereFont.ttf', fontSize)
    largerFont = love.graphics.newFont('assets/YandereFont.ttf', 60)
    love.graphics.setFont(font)
    
    -- Load the high scores
    highScores = serial.readHighScores()
    
end


-- Game updates --------------------------------------
function love.update(dt)
    --[[ Cap frame rate at something close to 30 fps
    if dt < 1/30 then
        love.timer.sleep((1/30) - dt)
    end--]]
    
    -- Game state specific updates--------------------------------
    if state == MENU then
        -- Nothing right now
        
    elseif state == UPDATE then
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
    
    -- The game is running and no animations are being updated------------------
    elseif state == GAME then
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
    
    -- Any other game state
    else
        -- Nothing for now
    end
    
    -- Other state combos
    if state == GAME or state == UPDATE then
        if board.timeLimit then -- Update the time taken in the game
            board.timeTaken = board.timeTaken + dt
        end
    end
    
    -- Stuff to happen always----------------------
    -- Update non blocking animations
    for i, animation in ipairs(animations) do
        animation:update(dt)
        if animation.finished then
            table.remove(animations, i)
        end
    end

    -- Update match score animations
    for i, animation in ipairs(scoreAnims) do
        animation:update(dt)
        if animation.finished then
            table.remove(scoreAnims, i)
        end
    end
    
    -- Input events------------------------------------------------
    
    -- Events for clicking the mouse
    function love.mousepressed(x, y, button, istouch)
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
    
    -- Key Presses
    function love.keypressed(key)
        if key == 'escape' then
            love.event.quit()
        end
        
        if state == MENU then
            currentMenu:action(key)
        
        elseif state == GAME then
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

        elseif state == END then
            if key == 'return' then
                -- get all high scores for this mode
                local scores = {}
                local diff = game.diffToString(gameDifficulty)
                local mode = game.modeSaveString(gameMode)
                -- All this will require that the high scores is properly set
                for _, score in ipairs(highScores[diff][mode]) do
                    if board.score > score.score or #highScores[diff][mode] < 10 then
                        state = NAME
                        return
                    end
                end
                -- if players score is not a high score just go straight to the score screen
                state = SCORE
            end
        
        -- Enter a name for a high score
        elseif state == NAME then
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
        
        elseif state == SCORE then
            if key == 'return' then
                state = MENU
            elseif key == 'm' then
                cycleMode()
            elseif key == 'd' then
                cycleDifficulty()
            end
        
        elseif state == HELP then
            if key == 'return' then
                state = MENU
            end
        end
        
    
    end
end


-- All output --------------------------------------------
function love.draw(dt)
    
    love.graphics.draw(background, 0, 0)
    love.graphics.setFont(largerFont)
    love.graphics.printf(gameTitle, 0, 40, 800, 'center')
    love.graphics.setFont(font)
    
    if state == GAME or state == UPDATE then
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
            love.graphics.printf(string.format("Time: %s", secToMin(board.timeTaken)),
                    infoArea.x, infoArea.y + 80, 240, 'center')
        end
        
        -- Some info
        love.graphics.printf("(h)int", gameArea.x, gameArea.y + 380,
                320, 'left')
        love.graphics.printf("(p)ause", gameArea.x, gameArea.y + 380,
                320, 'center')
        love.graphics.printf("(q)uit", gameArea.x, gameArea.y + 380,
                320, 'right')
    
    elseif state == MENU then
        love.graphics.printf(currentMenu.title, gameArea.x, gameArea.y, 320, "center")
        love.graphics.printf(string.format("Difficulty: %s", game.diffToString(gameDifficulty)),
                gameArea.x, gameArea.y + 320, 320, 'center')
        love.graphics.printf(string.format("Mode: %s", game.modeToString(gameMode)),
                gameArea.x, gameArea.y + 350, 320, 'center')
        for i, item in ipairs(currentMenu.items) do
            love.graphics.printf(item.text, gameArea.x, gameArea.y + 20 + (i * fontSize),
                    320, "center")
        end
        love.graphics.printf(version, 0, gameArea.y2 + 90, 800, 'center')
        love.graphics.printf(creator, 0, gameArea.y2 + 120, 800, 'center')
        
    elseif state == END then
        love.graphics.printf("Game Over", gameArea.x, gameArea.y, 320, 'center')
        love.graphics.printf(string.format("Final Score: %s", board.score),
                gameArea.x, gameArea.y + 80, 320, 'center')
        love.graphics.printf("(enter) to continue", gameArea.x,
            gameArea.y + 380, 320, 'center')
    
    elseif state == NAME then
        love.graphics.printf("You got a high score!", gameArea.x, gameArea.y, 320, 'center')
        love.graphics.printf("Enter your name", gameArea.x, gameArea.y + 80, 320, 'center')
        love.graphics.printf(table.concat(gName, ""), gameArea.x, gameArea.y + 120, 320, 'center')
        love.graphics.printf("(enter) to continue", gameArea.x,
            gameArea.y + 380, 320, 'center')
        
    elseif state == SCORE then
        local diff = game.diffToString(gameDifficulty)
        local mode = game.modeSaveString(gameMode)
        love.graphics.printf(string.format("%s %s High Scores", diff, game.modeToString(gameMode)),
                gameArea.x - 50, gameArea.y - 50, 400, 'center')
        for i, score in ipairs(highScores[diff][mode]) do
            love.graphics.printf(score.score,
                    gameArea.x - 100, gameArea.y + ((i - 1) * fontSize), 200, "right")
            love.graphics.printf(score.name,
                    gameArea.x + 130, gameArea.y + ((i - 1) * fontSize), 320, "left")
        end
        love.graphics.printf("(m)ode, (d)ifficulty", gameArea.x,
            gameArea.y + 380, 320, 'center')
        love.graphics.printf("(enter) for Main Menu", gameArea.x,
            gameArea.y + 420, 320, 'center')
    
    elseif state == HELP then
        love.graphics.printf("HELP", gameArea.x, gameArea.y - 40, 320, 'center')
        love.graphics.printf(helpString, 40, gameArea.y, 720, 'left')
        love.graphics.printf("(enter) to go Back", gameArea.x,
            gameArea.y + 420, 320, 'center')
    end
end
