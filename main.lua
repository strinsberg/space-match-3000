-- Imports
assets = require'assets.assets'


-- Load all game assets
function love.load()
    assets.load()
    love.graphics.setFont(assets.largerFont)
end

-- Update all game elements
function love.update(dt)

end

-- Draw all game elements
function love.draw(dt)
    love.graphics.draw(assets.background, 0, 0)
    love.graphics.print("It Works", 100, 200)
end
