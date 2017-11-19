local Screen = Class()

function Screen:init(state)
    self.state = state
    self.app = state.app
    self.main = ScreenArea(0, 0, self.app.windowWidth, self.app.windowHeight)
    -- Screen Specific code for screen Areas
end

function Screen:draw()
    -- Code to draw the screen
end

return Screen