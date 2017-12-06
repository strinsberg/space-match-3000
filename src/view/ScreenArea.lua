Class = require'src.Class'

local ScreenArea = Class()

function ScreenArea:init(x, y, width)
    self.x = x
    self.y = y
    self.width = width
end

function ScreenArea:draw(image, x, y)
    love.graphics.draw(image, self.x + x, self.y + y)
end

function ScreenArea:printCenter(text, y)
    love.graphics.printf(text, self.x, self.y + y, self.width, 'center')
end

function ScreenArea:printLeft(text, y)
    love.graphics.printf(text, self.x, self.y + y, self.width, 'left')
end

return ScreenArea