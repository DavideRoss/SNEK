StartRoom = Object:extend()

local blend_speed = .25
local blend_interval = 3

function StartRoom:new()
    self.timer = Timer()

    love.graphics.setFont(font_title)

    self.title_width = font_title:getWidth('SNEK')
    self.subtitle_height = font_subtitle:getWidth('Press any key')

    self.dtotal = 0

    self.text_color = rgb(palette.yellow)
    self.bg_color = rgb(palette.darkBlue)

    self.text_color_index = 4
    self.bg_color_index = 11

    self:colorBlend()
end

function StartRoom:update(dt)
    self.dtotal = self.dtotal + dt
    self.timer:update(dt)
end

function StartRoom:draw()
    love.graphics.setBackgroundColor(self.bg_color)

    love.graphics.setColor(self.text_color)
    love.graphics.setFont(font_title)
    love.graphics.print('SNEK', 512, 100, 0, 1, 1, self.title_width / 2, 0)

    love.graphics.setColor(self.text_color)
    love.graphics.setFont(font_subtitle)
    love.graphics.print('Press any key', 512, 600, 0, 1, 1, self.subtitle_height / 2, math.sin(math.rad(self.dtotal * 200)) * 20)
end

function StartRoom:colorBlend()
    self.timer:after(blend_interval, function()
        self.text_color_index = self.text_color_index + 1
        if self.text_color_index > #palette_names then self.text_color_index = self.text_color_index - #palette_names end
        local target = rgb(palette[palette_names[self.text_color_index]])
        self.timer:tween(blend_speed, self.text_color, target, 'linear', StartRoom.colorBlend(self))

        self.bg_color_index = self.bg_color_index + 1
        if self.bg_color_index > #palette_names then self.bg_color_index = self.bg_color_index - #palette_names end
        local target = rgb(palette[palette_names[self.bg_color_index]])
        self.timer:tween(blend_speed, self.bg_color, target, 'linear')
    end)
end

function StartRoom:keypressed(key, scancode, isrepeat)
    -- TODO: replace with the correct room
    goToRoom('ModeClassic')
end
