Block = Object:extend()

function Block:new(color, x, y)
    self.color = color
    self.x = x
    self.y = y
end

function Block:update(dt)
end

function Block:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', (self.x + BaseSnek.limits.left) * 32, (self.y + BaseSnek.limits.top) * 32, 32, 32)
end

function Block:getPosition()
    return { x = self.x, y = self.y }
end