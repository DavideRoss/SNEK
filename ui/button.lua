Button = Object:extend()

local line_margin = 12
local line_width = 5

local blend_speed = .1

function Button:new(parent, x, y, width, height)
    self.parent = parent
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.color_normal = { .5, .2, .2 }
    self.color_selected = { .2, .5, .2 }
    self.color_text = { 1, 1, 1, 1 }

    self.label = 'Bla bla bla'
    self.object = nil
    self.on_click = nil

    self.selection = {
        selected = false,
        clicked = false,
        panel_height = 0
    }

    self.timer = Timer()
end

function Button:update(dt)
    local x, y = love.mouse.getPosition()
    
    local prev_selected = self.selection.selected
    self.selection.selected = x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
   
    if not prev_selected and self.selection.selected then
        self.timer:clear()
        self.timer:tween(blend_speed, self.selection, { panel_height = self.height }, 'in-out-quad')
    end

    if prev_selected and not self.selection.selected then
        self.timer:clear()
        self.timer:tween(blend_speed, self.selection, { panel_height = 0 }, 'in-out-quad')
    end

    local prev_clicked = self.selection.clicked
    self.selection.clicked = love.mouse.isDown(1)

    if self.selection.selected and not prev_clicked and self.selection.clicked then
        if self.on_click then self.on_click(self.parent, self.object) end
    end

    self.timer:update(dt)
end

function Button:draw()
    local testStencil = function()
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end

    love.graphics.stencil(testStencil, 'replace', 1)
    love.graphics.setStencilTest('greater', 0)

    love.graphics.setColor(self.color_normal)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(self.color_selected)
    love.graphics.rectangle('fill', self.x, self.y + self.height - self.selection.panel_height, self.width, self.selection.panel_height) 

    love.graphics.setLineWidth(line_width)
    love.graphics.setColor({ 0, 0, 0, .05 })
    love.graphics.rectangle('line', self.x + line_margin, self.y + line_margin, self.width - line_margin * 2, self.height - line_margin * 2)
    
    love.graphics.setFont(font_main)
    love.graphics.setColor(self.color_text)
    
    local label_width = font_main:getWidth(self.label)
    local label_height = font_main:getHeight()
    local x = self.x + (self.width / 2) - (label_width / 2)
    local y = self.y + (self.height  / 2) - (label_height / 2)
    love.graphics.print(self.label, x, y - self.selection.panel_height)

    love.graphics.setStencilTest()
end
