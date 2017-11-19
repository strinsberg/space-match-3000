-- Base Class and SubClasses for game limits
local limitClasses = {}


-- Limit Base class and interface
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


-- Helper functions -----------------------------
local function isLimitReached(limit)
    if limit.amount >= limit.limit then
        limit.game.isOver = true
    end
end

-- Converts seconds to minute:seconds string
local function secToMin(seconds)
    local sec = math.floor(seconds % 60)
    local minutes = math.floor(seconds / 60)
    if sec < 10 then
        return string.format("%s:0%s", minutes, sec)
    else
        return string.format("%s:%s", minutes, sec)
    end
end

-- No Limit ------------------------------------------------------------
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

-- Move Limit subclass ------------------------------------------------------
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

-- Time Limit subclass ---------------------------------------------
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

-- Static reference to a current limit and constructor to return instance based on current limit
local limitNames = {"No Limit", "50 Moves", "100 Moves", "2 Min", "5 Min"}

local currentLimit = 1

function limitClasses.cycle()
    if currentLimit == #limitNames then
        currentLimit = 1
    else
        currentLimit = currentLimit + 1
    end
end

function limitClasses.new(game)
    local limit = limitNames[currentLimit] -- Name of the limit type
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

function limitClasses.getName()
    return limitNames[currentLimit]
end

-- Set module elements
limitClasses.NoLimit = NoLimit
limitClasses.MoveLimit = MoveLimit
limitClasses.TimeLimit = TimeLimit

return limitClasses