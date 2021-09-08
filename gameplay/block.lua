Block = Object:extend()


function Block:new(color, x, y, opts)
    self.color = color
    self.x = x
    self.y = y

    self.real_pos = { x = x, y = y }

    self.clock = 0

    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    if not self.size then self.size = 16 end
    if self.appear_on_start then self:appear() end
end

function Block:update(dt)
    self.clock = self.clock + dt

    if self.next_pos then
        local t = clamp01(self.clock / (self.duration or .1))
        self.real_pos = {
            x = (1 - t) * self.x + t * self.next_pos.x,
            y = (1 - t) * self.y + t * self.next_pos.y,
        }

        if t == 1 then 
            self.x = self.next_pos.x
            self.y = self.next_pos.y
            self.next_pos = nil
        end
    else self.real_pos = { x = self.x, y = self.y } end
end

function Block:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle(
        'fill',
        (self.real_pos.x + BaseSnek.limits.left) * 32 + (16 - self.size),
        (self.real_pos.y + BaseSnek.limits.top) * 32 + (16 - self.size),
        self.size * 2,
        self.size * 2
    )
end

function Block:getPosition()
    return { x = self.x, y = self.y }
end

function Block:appear(after)
    self.timer:tween(self.duration or .1, self, { size = 16 }, self.easing or 'linear', after)
end

function Block:disappear()
    self.timer:tween(self.duration or .1, self, { size = 0 }, self.easing or 'linear')
end

function Block:lerpColor(new_color)
    self.timer:tween(self.duration or .1, self, { color = new_color }, self.easing or 'linear')
end
