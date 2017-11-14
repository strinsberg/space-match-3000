--[[
-- This function allows a quicker creation of a class.
-- To use it import the module to Class or createClass or whatever you prefer
-- -- and call it like so MyClass = createClass(parent1, parent2, ...)
-- Now MyClass is a proper class with all the fields and methods inherited
-- -- from its parent classes. In the module for MyClass you can now define
-- -- its :init function and add whatever arguments and fields you want.
-- Now MyClass(..) will return an instance of MyClass with the arguments
-- -- being passed into the :init method
--
-- example
--
-- createClass = require('pathToClass.Class')
--
-- local Car = createClass() -- car is a base class
--
-- Car:init(model, year) -- Cars constructor called Car(model, year)
--   self.model = model
--   self.year = year
-- end
--
-- -- here can go any other methods following above ... Car:method()
--
-- return Car
--
-- end example
--
-- Now when you want to use the car class you can import its module to the name
-- -- Car and call its constructor like so...
-- newCar = Car("corvette", 2008)
--
-- This will make newCar an instance of car class with 
-- -- newCar.make -> "corvette" and newCar.year -> 2008
--
-- Any other methods that were added to Car could be called on newCar
-- -- as newCar:method()
--
-- It is important to note that when a super constructor is to be called
-- -- you must use the variable name that you imported that class into for
-- -- its init method and use . instead of : and pass self as the first arg
-- -- and it should be the same variable that you passed when creating the
-- -- class with newClass = class(parentClass)
--
-- function newClass:init(arg1, arg2)
--   parentClass.init(self, arg1)
--   self.arg2 = arg2
-- end
--
-- This way each class constructor is still available to use even though the
-- -- method init is defined for your new class. All the class methods are
-- -- public and since you have imported the module you could call all of them
-- -- from that module, though most of these it would be pointless to call
-- -- in this fashion because they are now a part of the newClass
--]]

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

