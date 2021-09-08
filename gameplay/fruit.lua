Fruit = Object:extend()

function Fruit:new(color, x, y, opts)
    self.color = color
    self.position = Vector(x, y)
    self.timer = Timer()

    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    if not self.size then self.size = 16 end
    if self.appear_on_start then self:appear() end
end

function Fruit:update(dt) self.timer:update(dt) end

function Fruit:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle(
        'fill',
        (self.position.x + BaseSnek.limits.left) * 32 + (16 - self.size),
        (self.position.y + BaseSnek.limits.top) * 32 + (16 - self.size),
        self.size * 2,
        self.size * 2
    )
end

function Fruit:appear(after)
    self.timer:tween(self.duration or .1, self, { size = 16 }, self.easing or 'linear', after)
end

function Fruit:disappear()
    self.timer:tween(self.duration or .1, self, { size = 0 }, self.easing or 'linear')
end