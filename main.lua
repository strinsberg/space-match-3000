-- Imports
assets = require'assets.assets'
App = require'src.App'
Area = require'src.view.ScreenArea'
serialize = require'src.serialize'

-- Get new random number set
math.randomseed( os.time() )

-- Create app
app = App()


-- Load all game assets
function love.load()
    -- Load assets and set font
    assets.load()
    love.graphics.setFont(assets.font)
    
    -- Load the high scores from the scores.dat file
    app.highScores = serialize.readHighScores()
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
