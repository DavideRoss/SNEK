ModeClassic = Object:extend()

function ModeClassic:new()
end

function ModeClassic:update(dt)
end

function ModeClassic:draw()
    love.graphics.setBackgroundColor({ 0, 0, 0, 1 })
    love.graphics.setColor({ 1, 1, 1, 1 })

    love.graphics.print('ModeClassic mode', 10, 10)
end