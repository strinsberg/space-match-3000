-- Imports
assets = require'assets.assets'
App = require'src.App'
Area = require'src.view.ScreenArea'

-- Get new random number set
math.randomseed( os.time() )

-- Create app
app = App()
gArea = Area(240, 160, 320)

-- Load all game assets
function love.load()
    -- Load assets and set font
    assets.load()
    love.graphics.setFont(assets.font)
end

-- Update all game elements
function love.update(dt)
    -- Update for state
    app.state:update(dt)
    
    -- Mouse press events
    function love.mousepressed(x, y, button, istouch)
        app.state:mousePressed(x, y, button)
    end
    
    -- Key press events
    function love.keypressed(key)
        app.state:keyPressed(key)
    end
end

-- Draw all game elements
function love.draw(dt)
    app.state:draw()
end
