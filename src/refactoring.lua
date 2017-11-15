Class = require('src.Class')

-- this class is for visualizing and testing some ideas for the game without
-- doing anything permenantly yet

local M = {}

-----------------------------------
local REFILL_DOWN = 1
local REFILL_LEFT = 2
local REFILL_UP = 3
local REFILL_RIGHT = 4

local Mode = Class()

local function setRefill(mode)
    if mode.name == "No Refill" then
        mode.refill = false
    else
        mode.refill = true
    end
end

function Mode:init(modeName)
    self.name = modeName
    setRefill(self)
    self.refill_direction = REFILL_DOWN
    self.limit = nil -- Where to set this?
end


---------------------------------------------
local COLORS_EASY = 4
local COLORS_HARD = 5
local COLORS_ROUGH = 6

local Difficulty = Class()

function Difficulty:init(numColors)
    -- Could add exception if it is not in the right range?
    self.numColors = numColors
end

function Difficulty:toString()
    if self.numColors == COLORS_EASY then
        return "Easy"
    elseif self.difficulty == COLORS_HARD then
        return "Hard"
    else
        return "Rough"
    end
end

-------------------------------------------------
local DEFAULT_ROWS = 8
local DEAFULT_COLUMNS = 8

local Game = Class()

function Game:init(difficulty, mode)
    self.difficulty = difficulty
    self.mode = mode -- A game mode object with name etc. maybe a mode object with
                    -- the ability to hold all your modes and change between them?
    self.gameBoard = Match3(DEFAULT_ROWS, DEFAULT_COLUMNS, self.difficulty.numColors)
    
end

-------------------------------------------------
local MIN_MATCH_LENGTH = 3

-- Match3 class
local Match3 = Class()

function Match3:init(rows, columns, numColors)
    self.rows = rows
    self.columns = columns
    self.numColors = numColors
    self.board = self:newBoard()
end
    
function Match3:newBoard()
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