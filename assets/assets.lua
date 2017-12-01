-- A colection of game assets and associated information
local assets = {
    fontSize = 35,
    largerFontSize = 60,
}

-- The file for the game font
local fontFile = "assets/YandereFont.ttf"

-- The files for the game images
local imageFiles = {
    blue = "assets/blue.png",
    green = "assets/green.png",
    purple = "assets/purple.png",
    red = "assets/red.png",
    yellow = "assets/yellow.png",
    silver = "assets/silver.png",
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
    assets.itemSize = assets.blue:getWidth()
    
    -- Load a normal and large font
    assets.font = love.graphics.newFont(fontFile, assets.fontSize)
    assets.largerFont = love.graphics.newFont(fontFile, assets.largerFontSize)
end

-- Return the assets object
return assets