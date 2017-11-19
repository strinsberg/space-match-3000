local M = {}

-- moving animation with static image --
-- needs an item to animate
-- this item needs a start x and y
-- it needs an end x and y
-- it needs a speed

-- Class for an animation that moves from startx,starty to endx,endy with a static image
local movStatAnim = {x = 0, y = 0, startx = 0, starty = 0, endx = 0, endy = 0, speed = 150,
    image = nil, finished = false}

function movStatAnim:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    o.x = o.startx
    o.y = o.starty
    return o
end

-- Constructor for movStatAnim with row, column and item reference instead of image
function constructMSA (column, row, newColumn, newRow, itemNum)
    return movStatAnim:new{
        startx = (column - 1) * itemSize,
        starty = (row - 1) * itemSize,
        endx = (newColumn - 1) * itemSize,
        endy = (newRow - 1) * itemSize,
        image = itemNum
    }
end

function movStatAnim:update (dt)
    -- Update x coordinate
    if self.startx < self.endx then
        if self.x + (self.speed*dt) > self.endx then
            self.x = self.endx
        else
            self.x = self.x + (self.speed*dt)
        end
    else
        if self.x - (self.speed*dt) < self.endx then
            self.x = self.endx
        else
            self.x = self.x - (self.speed*dt)
        end
    end
    -- Update y coordinate
    if self.starty < self.endy then
        if self.y + (self.speed*dt) > self.endy then
            self.y = self.endy
       else
            self.y = self.y + (self.speed*dt)
        end
    else
        if self.y - (self.speed*dt) < self.endy then
            self.y = self.endy
       else
            self.y = self.y - (self.speed*dt)
        end
    end
    -- If animation is at the desired position end
    if self.y == self.endy and self.x == self.endx then
        self.finished = true
    else
        self.finished = false
    end
end


-- Static animation to be drawn on the screen for a certain amount of time only
statAnim = {duration = 1, x = 0, y = 0, image = nil, finished = false}

function statAnim:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function statAnim:update (dt)
    self.duration = self.duration - dt
    if self.duration < 0 then
        self.finished = true
    else
        self.finished = false
    end
end

-- Add classes to module
M.movStatAnim = movStatAnim
M.constructMSA = constructMSA
M.statAnim = statAnim

return M