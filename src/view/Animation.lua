Class = require'src.Class'


---------------------------------------------------------------------
-- A simple animation for a moving object
---------------------------------------------------------------------
local Animation = Class()

-- Constants
local NONE = 0
local UP = 1
local RIGHT = 2
local DOWN = 3
local LEFT = 4


---------------------------------------------------------------------
-- Initialize an Animation.
-- x -> the x coord of the top left corner
-- y -> the y coord of the top left corner
-- endx -> the destination for the x coord
-- endy -> the destination for the y coord
-- image -> the love2d image for the animation
-- speed -> the number of pixels to move each (second?)
---------------------------------------------------------------------
function Animation:init(x, y, endX, endY, image, speed)
    self.x = x
    self.y = y
    self.endX = endX
    self.endY = endY
    self.image = image
    self.speed = speed or 150
    self.direction = self:setDirection(x, y, endX, endY)
    self.finished = false
end


---------------------------------------------------------------------
-- Set the direction based on the starting and ending coordinates
---------------------------------------------------------------------
function Animation:setDirection()
    local xD = NONE
    local yD = NONE
    if self.x < self.endX then
        xD = RIGHT
    elseif self.x > self.endX then
         xD = LEFT
    end
    if self.y < self.endY then
        yD = DOWN
    elseif self.y > self.endY then
        yD = UP
    end
    return {x = xD, y = yD}
end


---------------------------------------------------------------------
-- Update the position of the animation. Set finished if the destination
-- has been reached
-- dt -> the delta time
---------------------------------------------------------------------
function Animation:update(dt)
    -- Update x coordinate
    -- Object is moving right and has not reached the end of its x journey
    if self.direction.x == RIGHT and self.x ~= self.endX then
        -- X is past final position make it = final position
        if self.x + (self.speed*dt) > self.endX then
            self.x = self.endX
        else
            -- Move it by the appropriate amount
            self.x = self.x + (self.speed*dt)
        end
    elseif self.direction.x == LEFT and self.x ~= self.endX then
        if self.x - (self.speed*dt) < self.endX then
            self.x = self.endX
        else
            self.x = self.x - (self.speed*dt)
        end
    end
    -- Update y coordinate
    if self.direction.y == DOWN and self.y ~= self.endY then
        if self.y + (self.speed*dt) > self.endY then
            self.y = self.endY
       else
            self.y = self.y + (self.speed*dt)
        end
    elseif self.direction.y == UP and self.y ~= self.endY then
        if self.y - (self.speed*dt) < self.endY then
            self.y = self.endY
       else
            self.y = self.y - (self.speed*dt)
        end
    end
    -- If animation is at the desired position end
    if self.y == self.endY and self.x == self.endX then
        self.finished = true
    end
end


-- Return the module
return Animation