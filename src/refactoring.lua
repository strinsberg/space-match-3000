Class = require('src.Class')

-- this class is for visualizing and testing some ideas for the game without
-- doing anything permenantly yet

local M = {}


---------------------------------------------
-- No Longer a full class untill it is more than just a data object
local difficulties = {
    {name = "Easy", numColors = 4},
    {name = "Hard", numColors = 5},
    {name = "Rough", numColors = 6}
}

local currentDifficulty = 1

function cycleNumColors()
    if currentDifficulty == len(difficulties) then
        currentDifficulty = 1
    else
        currentDifficulty = currentDifficulty + 1
    end
end

function getCurrentDifficulty()
    return difficulties[currentDifficulty]
end

-----------------------------------
local modes = {
    {name = "Normal", refill = true},
    {name = "No Refill", refill = true}
}

local currentMode = 1

function cycleMode()
    if currentMode == len(modeNames) then
        currentMode = 1
    else
        currentMode = currentMode + 1
    end
end

function getMode()
    return modes[currentMode]
end

-----------------------------------------
local Limit = Class()

function Limit:init(game, name, limit)
    self.game = game
    self.name = name
    self.limit = limit
    self.amount = 0
end

function Limit:update(dt)
    -- What happens to the current state of the limit each game step
end

function Limit:amountLeft()
    -- Return the amount left as a string
end

-- Helper functions
local function isLimitReached(limit)
    if limit.amount >= limit.limit then
        limit.game.isOver = true
    end
end

-- display seconds as minute:seconds
local function secToMin (seconds)
    local sec = math.floor(seconds % 60)
    local minutes = math.floor(seconds / 60)
    if sec < 10 then
        return string.format("%s:0%s", minutes, sec)
    else
        return string.format("%s:%s", minutes, sec)
    end
end

-- No Limit
-- obviously if there is absolutley no limit then eventually the program will crash
-- Consider making it just a really high move limit or at least building in a saftey
local NoLimit = Class(Limit)

function NoLimit:init(game, name)
    Limit.init(self, game, name, 0)
end

function NoLimit:update(dt)
    if self.game.moveMade then
        self.amount = self.amount + 1
        self.game.moveMade = false
    end
end

function NoLimit:amountLeft()
    return string.format("Moves: %s")
end

-- Move Limit
local MoveLimit = Class(Limit)

function MoveLimit:init(game, name, moveLimit)
    Limit.inti(self, game, name, moveLimit)
end

function MoveLimit:update(dt)
    if self.game.moveMade then
        self.amount = self.amount + 1
        self.game.moveMade = false
        isLimitReached(self)
    end
end

function NoLimit:amountLeft()
    local movesLeft = self.limit - self.amount
    return string.format("Moves Left: %s", movesLeft)
end

-- Time Limit
local TimeLimit = Class(Limit)

function TimeLimit:init(game, name, timeLimit)
    Limit.init(self, game, name, timeLimit)
end

function TimeLimit:update(dt)
    self.amount = self.amount + dt
    isLimitReached(self)
end

function NoLimit:amountLeft()
    local secondsLeft = self.limit - self.amount
    return string.format("Time Left: %s", secToMin(secondsLeft))
end

-- Limit factory of sorts
local limits = {"No Limit", "50 Moves", "100 Moves", "2 Min", "5 Min"}

local currentLimit = 1

function cycleLimit()
    if currentLimit == len(limits) then
        currentLimit = 1
    else
        currentLimit = currentLimit + 1
    end
end

function new(game)
    local limit = limits[currentLimit] -- Name of the limit type
    if limit == "50 Moves" then
        return MoveLimit(game, limit, 50)
    elseif limit == "100 Moves" then
        return MoveLimit(game, limit, 100)
    elseif limit == "2 Min" then
        return TimedLimit(game, limit, 120)
    elseif limit == "5 Min" then
        return TimedLimit(game, limit, 300)
    else
        return NoLimit(game, "No Limit")
    end
end

-------------------------------------------------
local DEFAULT_ROWS = 8
local DEAFULT_COLUMNS = 8

local Game = Class()

function Game:init(difficulty, mode, limit)
    self.difficulty = difficulty
    self.mode = mode
    self.limit = limit
    self.gameBoard = Match3(DEFAULT_ROWS, DEFAULT_COLUMNS, self.difficulty.numColors)
    self.moveMade = false -- necessary to allow different mode updates all happening in the same place
    self.checkForMatches = false -- necessary to keep the game from checking the board every loop cycle
end

-------------------------------------------------
local MIN_MATCH_LENGTH = 3

-- Match3 class
local GameBoard = Class()

function Match3:init(rows, columns, numColors)
    self.rows = rows
    self.columns = columns
    self.numColors = numColors
    self.board = self:newBoard()
end
    
function GameBoard:newBoard()
    self.board = {}
    for row = 1, self.rows do
        self.board[row] = {}
        for column = 1, self.columns do
            local color = math.random(1, self.numColors)
            self.board[row][column] = Block(color)
        end
    end
end

return M


--[[


The Game is the cohesive class for everything that you do after you press the new game button
- its main arguments should be difficulty, and mode. These will determine the games constraints,
    the number of block colors, and perhaps in the future the board size or scoring specifics.
    these two arguments can be passed to the game from outside at its creation. however, wether
    these arguments create states inside the game or are full objects constructed and passed
    to the game i am not sure about yet
- variables
    - selection and hint - boardPosition objects
    - mode, difficulty
    - score and modifier - determined from matches made
    
The main portion of the game involves the board.
- The big question is wether or not this part of the game should have one unit that understands
    everything about itself or if it should be broken into smaller classes that can be used
    together to create the functionality needed. Should there be a generic board and a match3
    board or just a board that does all of these things?
- the goings on of the board include allowing selection and movement of its elements. It involves
    finding matches and removing and replacing them.
- to check if an item is matched just run a check on the row and column that the item moved
    to rather than having a seperate function. for the hint this could mean checking the
    rows and columns that the items would move to. still not sure if the best way to do it
    is to actually move the items and check for the hint. or to do the checks with a
    dummy item in the place of the one that would move.
- variables
    X rows, columns - the size of the board
    X number of colors - the difficulty
    X minMatchLength - went with a constant instead of a feild. this shouldn't change.
    - refill, refillDirection - governs the updating - moved to mode
- methods
    - reset - would reinitialize the board with random blocks
            - needs to check other blocks to make sure that a match isn't created
    - getMatches - get all the matches on the board and return them
    - updateBoard - remove all the matched blocks and replace them with other blocks
            - might it be possible to give this a direction so that the game could be
                made to allow blocks to move in from the bottom or the sides as well
                as the top
    - getHint - find a block that could be moved to make a match and return its position
    - switchBlocks - switch 2 blocks with eachother. could even be used for dropping
    
The animations should change a bit
- instead of static animations there should be a message animation that displays a message
    for a duration of time.
- blocking animations should take an image instead of using a number to decide wich image
    to display
    
The mode
- this is a tough one. should there be various mode classes or one base class and some that
    inherit like a timed mode and a move limit etc.
eg mode {name, refill, refill_direction}
    timeLimit {limit, addTime(), checkTime(), timePassed}
    moveLimit {limit, moves, addMove(), isLimitReached()}
    - could put it all in mode and go with an isTimed arg to distinguish from
        timed and not timed. of course this would make it very hard later
    - perhaps an interface could be used or just inheritance. probably i will
        have to define them in different classes. The necessary thing for being
        able to add new modes later. though I suppose they do need an interface
        of some kind to be able to work interchangably. I think this can be
        accomplished by declaring all the methods in the baseclass and then
        making sure to overide them all if need be.

small classes
- boardPosition {row, column} - for hint, selection, or even for working with moving things
- block {color, visible}


--]]