Vector = Object:extend()

function Vector:new(x, y)
    self.x = x
    self.y = y
end

function Vector:__tostring()
    return '(' .. self.x .. ', ' .. self.y .. ')'
end

function Vector:__add(v1)
    return Vector(self.x + v1.x, self.y + v1.y)
end

function Vector:__sub(v1)
    return Vector(self.x - v1.x, self.y - v1.y)
end