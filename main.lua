game = require('src/game')
anims = require('src/animations')
menu = require('src/menu')
serial = require('src/serialize')
-- States
AppState = require('src/appState/AppState')
MainMenuState = require('src/appState/MainMenuState')
HelpState = require('src/appState/HelpState')
HighScoreState = require('src/appState/HighScoreState')
GameState = require('src/appState/GameState')
GameUpdateState = require('src/appState/GameUpdateState')
GameOverState = require('src/appState/GameOverState')
NameEntryState = require('src/appState/NameEntryState')
GameRunState = require('src/appState/GameRunState')
GamePauseState = require('src/appState/GamePauseState')

-- Get new random number set
math.randomseed( os.time() )

-- !!!! Most of this global logic should be stored somewhere else
--      so it can easily be passed to other parts of the program like states

-- Other variables
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
    
ratioX = 1
ratioY = 1
screenW = 800
screenH = 640

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
blockingAnims = {} -- Animations that block all action
scoreAnims = {} -- Animations for scores of individual matches


-- Create new board and random setup and start the game
function newGame ()
    board = game.board:new{difficulty = gameDifficulty, mode = gameMode}
    board:set()
    board:setLimits()
    app.changeState(GameRunState(app))
    gameOver = false
end

function scoreScreen()
    app.changeState(HighScoreState(app))
end

function helpScreen()
    app.changeState(HelpState(app))
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


-- get corrds from row or column
function columnX (column)
    return ((column - 1) * itemSize)
end

function rowY (row)
    return ((row - 1) * itemSize)
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

function timeLeft()
    return secToMin(board.timeLimit - board.timeTaken)
end

function movesMade()
    return board.movesTaken
end

app = {
    state = nil,
    changeState = function(newState)
        app.state = newState
    end,
    screenW = 800,
    screenH = 640,
    gameTitle = "Space Match 3000",
    version = "v2.5",
    company = "Plimpton Productions 2017"
}
app.state = MainMenuState(app)


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
    
    function love.resize(w, h)
        ratioX = w / screenW
        ratioY = h / screenH
    end
    
    app.state:update(dt)
    
    -- Input events------------------------------------------------
    
    -- Events for clicking the mouse
    function love.mousepressed(x, y, button, istouch)
        app.state:mousePressed(x, y, button)
    end
    
    -- Key Presses
    function love.keypressed(key)
        app.state:keyPressed(key)
    end
end


-- All output --------------------------------------------
function love.draw(dt)
    app.state:draw()
end
