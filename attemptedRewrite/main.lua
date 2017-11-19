App = require'src.App'

TITLE = "Space Match 3000"
VERSION = "V2.5"
COMPANY = "Plimpton Productions"

app = App(TITLE, VERSION, COMPANY)

-- All image loading etc
function love.load(arg)
        -- Backgorund image
    background = love.graphics.newImage('assets/background.png')
    
    -- Load all the item images and save them in a table
    itemImages = {
    love.graphics.newImage('assets/blue.png'),
    love.graphics.newImage('assets/green.png'),
    love.graphics.newImage('assets/yellow.png'),
    love.graphics.newImage('assets/red.png'),
    love.graphics.newImage('assets/purple.png'),
    love.graphics.newImage('assets/silver.png')
    }
    itemSize = itemImages[1]:getWidth()
    
    -- Load selction image
    selectionImg = love.graphics.newImage('assets/selection.png')
    hintImg = love.graphics.newImage('assets/hint.png')
    
    -- Fonts
    fontSize = 35
    font = love.graphics.newFont('assets/YandereFont.ttf', fontSize)
    largerFont = love.graphics.newFont('assets/YandereFont.ttf', 60)
    love.graphics.setFont(font)
end


-- All update code and input handling
function love.update(dt)
    app.state:update(dt)
    
    function love.keypressed(key)
        if key == 'escape' then
            love.event.quit()
        end
        
        app.state:keyPressed(key)
    end
end

-- All rendering
function love.draw(dt)
    love.graphics.draw(background,0,0)
    love.graphics.printf(TITLE, 0, 0, app.windowWidth, "center")
    app.state:draw(dt)
end