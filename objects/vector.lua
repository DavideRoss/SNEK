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

function Vector:__eq(v1, v2)
    return self.x == v1.x and self.y == v1.y
end

function Vector:copy()
    return Vector(self.x, self.y)
end

function Vector.lerp(from, to, t)
    local x = (1 - t) * from.x + t * to.x
    local y = (1 - t) * from.y + t * to.y

    return Vector(x, y)
end