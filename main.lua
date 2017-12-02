-- Imports
assets = require'assets.assets'


-- Load all game assets
function love.load()
    assets.load()
    love.graphics.setFont(assets.font)
end

-- Update all game elements
function love.update(dt)

end

-- Draw all game elements
function love.draw(dt)
    -- Testing for assets
    love.graphics.draw(assets.blueBlock, 0, 0)
    love.graphics.print("It Works", 100, 200)
end
