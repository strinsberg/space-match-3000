local M = {}

-- Class for menus
local Menu = Class()

-- Create an instance of class Menu
function Menu:init(title)
    self.title = title
    self.items = {}
end

-- Add an item to the menu
function Menu:add(menuItem)
    self.items[menuItem.id] = menuItem
end

-- Perform the action of a menu item
function Menu:action(id)
    if self.items[id] then
        self.items[id].action()
    end
end

-- Remove an item from the menu
function Menu:remove(menuItem)
    if self.items[id] then
        self.items[id] = nil
    end
end


-- Class for items in a menu
local MenuItem = Class()

-- Creates an instance of class menu item
function MenuItem:init(id, text, action)
    self.id = id
    self.text = text
    self.action = action
end


-- Add objects
M.Menu = Menu
M.MenuItem = MenuItem

return M