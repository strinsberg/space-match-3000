---------------------------------------------------------------------
-- Creates a class table.
-- Usage: local MyClass = Class(parents...)
-- New class must declare an init method to use to create objects.
-- Objects of the class can be created MyClass(args...)
-- ... -> 0+ parent classes
-- return -> a class table
---------------------------------------------------------------------
local Class = function (...)
    -- Create the class table and a table with all its parent classes
    cls = {}
    parents = {...}
    
    -- Copy parents contents into the class
    for i, parent in ipairs(parents) do
        for k, v in pairs(parent) do
            cls[k] = v
        end
    end
    
    -- set class and default empty constructor
    cls.__index = cls
    cls.init = function(...) end
    
    -- Set metatable call to constructor when cls is typed cls()
    setmetatable(cls, {__call = function(c, ...)
        local o = setmetatable({}, c)
        o:init(...)
        return o
    end
    })

    -- Return the new class
    return cls
end

return Class

