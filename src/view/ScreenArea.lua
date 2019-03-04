Class = require'src.Class'

---------------------------------------------------------------------
-- A section of the screen to draw images or text to. Does not
-- restrict drawing to be inside of it, But allows for offsets to
-- be calculated according to its position when drawing, rather than
-- the entire screen. Also means if the screen area is moved all
-- objects being drawn to it will move with it.
---------------------------------------------------------------------
local ScreenArea = Class()


---------------------------------------------------------------------
-- Initialize a ScreenArea.
-- x -> the x coord of the top left corner
-- y -> the y coord of the top left corner
-- width -> the distance to the top right corner
---------------------------------------------------------------------
function ScreenArea:init(x, y, width)
    self.x = x
    self.y = y
    self.width = width
end


---------------------------------------------------------------------
-- Draw an image in relation to the screen area
-- image -> a love2d image object
-- x -> the x offset from the left
-- y -> the y offset from the top
---------------------------------------------------------------------
function ScreenArea:draw(image, x, y)
    love.graphics.draw(image, self.x + x, self.y + y)
end


---------------------------------------------------------------------
-- Print text centered in relation to the width of the area.
-- text -> a string
-- y -> the y offset from the top
---------------------------------------------------------------------
function ScreenArea:printCenter(text, y)
    love.graphics.printf(text, self.x, self.y + y, self.width, 'center')
end


---------------------------------------------------------------------
-- Print text left justified in relation to the width of the area.
-- text -> a string
-- y -> the y offset from the top
---------------------------------------------------------------------
function ScreenArea:printLeft(text, y)
    love.graphics.printf(text, self.x, self.y + y, self.width, 'left')
end


-- Return the module
return ScreenArea