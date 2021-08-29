Button = Object:extend()

local line_margin = 12
local line_width = 5

local blend_speed = .2

function Button:new(parent, object, x, y, width, height)
    self.parent = parent
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.enabled = true

    self.color_normal = { .5, .2, .2 }
    self.color_selected = { .2, .5, .2 }
    self.color_text = { 1, 1, 1, 1 }
    self.color_disabled = { .25, .2, .2 }

    self.label = 'Bla bla bla'
    self.object = object
    self.on_click = nil

    self.selection = {
        selected = false,
        clicked = false,
        panel_height = 0
    }

    self.timer = Timer()
    self.record = serial:getRecord(self.object.handle)
end

function Button:update(dt)
    local x, y = love.mouse.getPosition()
    
    local prev_selected = self.selection.selected
    self.selection.selected = x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
   
    if not prev_selected and self.selection.selected and self.enabled then
        self.timer:clear()
        self.timer:tween(blend_speed, self.selection, { panel_height = self.height }, 'in-out-quad')
    end

    if prev_selected and not self.selection.selected and self.enabled then
        self.timer:clear()
        self.timer:tween(blend_speed, self.selection, { panel_height = 0 }, 'in-out-quad')
    end

    local prev_clicked = self.selection.clicked
    self.selection.clicked = love.mouse.isDown(1)

    if self.selection.selected and not prev_clicked and self.selection.clicked and self.enabled then
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

    love.graphics.setColor(self.enabled and self.color_normal or self.color_disabled)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(self.color_selected)
    love.graphics.rectangle('fill', self.x, self.y + self.height - self.selection.panel_height, self.width, self.selection.panel_height) 

    love.graphics.setLineWidth(line_width)
    love.graphics.setColor({ 0, 0, 0, .05 })
    love.graphics.rectangle('line', self.x + line_margin, self.y + line_margin, self.width - line_margin * 2, self.height - line_margin * 2)
    
    love.graphics.setFont(fonts.medium_bold)
    love.graphics.setColor(self.color_text)
    
    love.graphics.centered(self.label, self.x, self.y, self.width, self.height, 0, -self.selection.panel_height)

    local timer = 'No record'
    if self.record.score then timer = format_timer(self.record.time) end
    
    love.graphics.setFont(fonts.medium)
    love.graphics.centered(timer, self.x, self.y + self.height, self.width, self.height, 0, -self.selection.panel_height - 30)
    love.graphics.setFont(fonts.big)
    love.graphics.centered(tostring(self.record.score or '???'), self.x, self.y + self.height, self.width, self.height, 0, -self.selection.panel_height + 13)

    love.graphics.setStencilTest()
end
