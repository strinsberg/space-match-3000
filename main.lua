-- Imports
assets = require'assets.assets'
Board = require'src.Match3Board'
Game = require'src.Game'

game = Game(Game.HARD, 0)

-- Load all game assets
function love.load()
    -- Get new random number set
    math.randomseed( os.time() )
    -- Load assets and set font
    assets.load()
    love.graphics.setFont(assets.font)
end

-- Update all game elements
function love.update(dt)
    -- test for mouse clicks in game
    function love.mousepressed(x, y, button, istouch)
        row = math.floor(y / assets.blockSize) + 1
        column = math.floor(x / assets.blockSize) + 1
        if button == 1 then
            game:setSelection(row, column)
        end
    end
end

-- Draw all game elements
function love.draw(dt)
    -- test for board
    for i = 1, game.board.rows do
        for j = 1, game.board.columns do
            local block = game.board.board[i][j]
            if  block ~= 0 then
                if block.isVisible then
                    love.graphics.draw(assets.getBlockImage(block.color),
                            (j - 1) * assets.blockSize,
                            (i - 1) * assets.blockSize)
                    
                end
            end
        end
    end
    
    -- test for selection
    if game.selection then
        love.graphics.draw(assets.selection,
            (game.selection.column - 1) * assets.blockSize,
            (game.selection.row - 1) * assets.blockSize)
    end
    
end
