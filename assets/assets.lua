-- A colection of game assets and associated information
local assets = {
    fontSize = 35,
    largerFontSize = 60,
}

-- The file for the game font
local fontFile = "assets/YandereFont.ttf"

-- The files for the game images
local imageFiles = {
    blueBlock = "assets/blue.png",
    greenBlock = "assets/green.png",
    purpleBlock = "assets/purple.png",
    redBlock = "assets/red.png",
    yellowBlock = "assets/yellow.png",
    silverBlock = "assets/silver.png",
    orangeBlock = "assets/orange.png",
    pinkBlock = "assets/pink.png",
    background = "assets/background.png",
    selection = "assets/selection.png",
    hint = "assets/hint.png"
}

-- Loads the games images and fonts and stores them to assets
function assets.load()
    -- Load all images and save them by name to assets
    for key, image in pairs(imageFiles) do
        assets[key] = love.graphics.newImage(image)
    end
    
    -- Load the image size from one of the item images
    assets.blockSize = assets.blueBlock:getWidth()
    
    -- Load a normal and large font
    assets.font = love.graphics.newFont(fontFile, assets.fontSize)
    assets.largerFont = love.graphics.newFont(fontFile, assets.largerFontSize)
end


-- Get the image based on a block color
-- Add local color constants instead of hardcoded numbers
function assets.getBlockImage(color)
    if color == 1 then
        return assets.blueBlock
    elseif color == 2 then
        return assets.greenBlock
    elseif color == 3 then
        return assets.yellowBlock
    elseif color == 4 then
        return assets.redBlock
    elseif color == 5 then
        return assets.purpleBlock
    elseif color == 6 then
        return assets.pinkBlock
    elseif color == 7 then
        return assets.silverBlock -- change to the last color
    else
        -- should never be called so if you see orange ERROR
        return assets.orangeBlock
    end
end


-- Convert row or colum to an x or y value based on Block size
function assets.toPixel(index)
    return (index - 1) * assets.blockSize
end

-- Convert x or y to row or column index based on block size
function assets.toIndex(pixel)
    return math.floor(pixel / assets.blockSize) + 1
end

-- Set the color using a string parameter. nil will set white.
function assets.setColor(color)
    if color == "green" then
        love.graphics.setColor(0, 255, 0, 255)
    elseif color == "red" then
        love.graphics.setColor(255, 0, 0, 255)
    else
        love.graphics.setColor(255, 255, 255, 255)
    end
end
-- Return the assets object
return assets