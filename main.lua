game = require('src/game')
anims = require('src/animations')
menu = require('src/menu')
serial = require('src/serialize')
MainMenuState = require('src/appState/MainMenuState')
HelpState = require('src/appState/HelpState')
HighScoreState = require('src/appState/HighScoreState')
GameState = require('src/appState/GameState')
GameUpdateState = require('src/appState/GameUpdateState')

-- Get new random number set
math.randomseed( os.time() )

-- !!!! Most of this global logic should be stored somewhere else
--      so it can easily be passed to other parts of the program like states

-- Other variables
gameTitle = "Space Match 3000"
version = "v2.0"
creator = "Plimpton Productions 2017"
rowClick = 0
columnClick = 0
switchBack = false
gameMode = game.mode.endless
gameDifficulty = game.difficulty.easy
highScores = {}
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

-- Declare states before a change state function is introduced
mmState = MainMenuState()
hState = HelpState()
sState = HighScoreState()
gState = GameState()
guState = GameUpdateState()

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
        guState:update(dt)
    
    -- The game is running and no animations are being updated
    elseif state == GAME then
        gState:update(dt)
    
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
        gState:mousePressed(x, y, button)
    end
    
    -- Key Presses
    function love.keypressed(key)
        if key == 'escape' then
            love.event.quit()
        end
        
        if state == MENU then
            mmState:keyPressed(key)
        
        elseif state == GAME then
            gState:keyPressed(key)

        elseif state == END then
            if key == 'return' then
                -- get all high scores for this mode
                local scores = {}
                local diff = game.diffToString(gameDifficulty)
                local mode = game.modeSaveString(gameMode)
                -- if the players score is a high score go to name entry screen
                for _, score in ipairs(highScores[diff][mode]) do
                    if board.score > score.score or
                            (#highScores[diff][mode] < 10 and board.score > 0) then
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
            sState:keyPressed(key)
        
        elseif state == HELP then
            hState:keyPressed(key)
        end
        
    
    end
end


-- All output --------------------------------------------
function love.draw(dt)
    
    love.graphics.draw(background, 0, 0)
    love.graphics.setFont(largerFont)
    love.graphics.printf(gameTitle, 0, 40, 800, 'center')
    love.graphics.setFont(font)
    
    if state == GAME then
        gState:draw()
        
    elseif state == UPDATE then
        guState:draw()
    
    elseif state == MENU then
        mmState:draw()
        
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
        sState:draw()
    
    elseif state == HELP then
        hState:draw()
    end
end
