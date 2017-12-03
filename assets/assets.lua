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
        return assets.silverBlock
    else
        return assets.redBlock -- change to the last color
    end
end

-- Return the assets object
return assets