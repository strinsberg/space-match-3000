Class = require'src.Class'

local Panel = Class()

function Panel:init(app, x, y)
    self.app = app
    self.x = x
    self.y = y
    -- Should be set manually in subclass
    self.width = 0
    self.height = 0
    self.background = nil
end

function Panel:render()
    -- All common rendering should go here and this function should be called
    -- in all subclasses render() that want to use it
    if self.background then
        self:draw(self.background, 0, 0)
    end
end

-- These functions are wrappers for love2d functions and should not be overridden
-- they should be called in the panels render method instead of love2d graphics functions
function Panel:draw(image, x, y)
    love.graphics.draw(image, self.x + x, self.y + y)
end

function Panel:print(text, x, y)
    love.graphics.print(text, self.x + x, self.y + y)
end

function Panel:printf(text, y, align)
    love.graphics.printf(text, self.x, self.y + y, self.width, align)
end

return Panel