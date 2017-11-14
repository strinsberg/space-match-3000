Class = require('src.Class')

-- this class is for visualizing and testing some ideas for the game without
-- doing anything permenantly yet

local M = {}


local Mode = Class()

function Mode:init(modeName)
    
end

local Game = Class()

function Game:init()
    self.mode = nil -- A game mode object with name etc. maybe a mode object with
                    -- the ability to hold all your modes and change between them?
    
end





return M