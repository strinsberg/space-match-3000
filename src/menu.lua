local M = {}

-- Class for menus
local menu = {title = "Menu Title", items = {}}

function menu:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end


-- Class for menu items
local menuItem = {id = "1", text = "Menu Item", action = nil}

function menuItem:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end


-- Adds a menu item to the menu
function menu:addItem (id, text, action)
    local menuItem = menuItem:new{id = id, text = text, action = action}
    for i, item in ipairs(self.items) do
        if item.id == id then
            return
        end
    end
    self.items[#self.items + 1] = menuItem
end


-- Remove a menu item
function menu:removeItem (itemId)
    for i, item in ipairs(self.items) do
        if item.id == itemId then
            table.remove(self.items, i)
        end
    end
end


-- Do the action of a menu item if there is one
function menu:action (itemId)
    for i, item in ipairs(self.items) do
        if item.id == itemId then
            item.action()
        end
    end
end

-- Add objects
M.menu = menu
M.menuItem = menuItem

return M