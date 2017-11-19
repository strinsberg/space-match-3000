local M = {}

-- Class for menus ----------------------------------------
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
function Menu:action(id, state)
    if self.items[id] then
        self.items[id].action(state)
    end
end

-- Remove an item from the menu
function Menu:remove(id)
    if self.items[id] then
        self.items[id] = nil
    end
end

-- Get menu oredered by position
function Menu:getOrderedMenu()
    local orderedMenu = {}
    for _, item in pairs(self.items) do
        orderedMenu[#orderedMenu + 1] = item
    end
    table.sort(orderedMenu, function(a, b) return a.position < b.position end)
    return orderedMenu
end


-- Class for items in a menu ----------------------------------
local MenuItem = Class()

-- Creates an instance of class menu item
function MenuItem:init(position, id, text, action)
    self.position = position
    self.id = id
    self.text = text
    self.action = action
end


-- Add objects
M.Menu = Menu
M.MenuItem = MenuItem

return M