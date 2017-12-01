Class = require'src.Class'
Panel = require'src.view.panel.Panel'

local BoardPanel = Class(Panel)

function BoardPanel:init(app, x, y)
    Panel.init(self, app, x, y)
    self.width = 320
    self.height = 320
end

function BoardPanel:render()
    Panel.render(self)
    -- Draw the board
    local row, column
    for row = 1, board.rows do
        for column = 1, board.columns do
            if board.items[row][column].item > 0 and -- If the item is not empty
                    board.items[row][column].visible then -- If the item is visible
                Panel.draw(self, itemImages[ board.items[row][column].item ],
                        columnX(column), rowY(row))
            end
        end
    end
    
    -- Draw the hint item if exists
    if hintPosition then
        Panel.draw(self, hintImg, columnX(hintPosition.column), rowY(hintPosition.row))
    end
    
    -- Draw the selected item if there is one
    if board.selection and board.selection.visible then
        Panel.draw(self, selectionImg, columnX(board.selection.column),
                rowY(board.selection.row))
    end

    -- Draw any block animations
    for i, animation in ipairs(blockingAnims) do
        if animation.y > -itemSize then
            Panel.draw(self, itemImages[animation.image], animation.x, animation.y)
        end
    end
end


return BoardPanel