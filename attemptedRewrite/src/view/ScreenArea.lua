

-- Class to create isolated drawing areas on the screen
-- To make drawing things like the board or score info at a precise location easier
-- Also if all the actual drawing is in this class it is possible to use all other code
-- in with any display method. It may not make a difference for my lua games since they
-- will all probably be with love2d and this game is probably not very modular, but it
-- should be good practice for setting things up in a way that they can be reused or so
-- that the code for drawing things can be changed with only one class change
local ScreenArea = Class()

function ScreenArea:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function ScreenArea:draw(image, x, y)
    love.graphics.draw(image, self.x + x, self.y + y)
end

function ScreenArea:print(text, x, y)
    love.graphics.print(text, self.x + x, self.y + y)
end

function ScreenArea:printf(text, y, align)
    love.graphics.printf(text, self.x, self.y + y, self.width, align)
end

return ScreenArea