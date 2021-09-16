ModeClassic = Object:extend()

function ModeClassic:new()
    self.name = 'Classic'
    self.handle = 'classic'
    self.base = BaseSnek(self, {
        starting_fruits = 30,
        step_initial = .25,

        on_fruit_collision = self.on_fruit_collision,
        on_self_collision = self.on_self_collision,
        on_block_collision = self.on_block_collision
    })

    self.palette = palettes.classic

    -- self.base:add_block_definition('wall', 'wall')

    -- for x = 0, 29 do
    --     self.base:add_block('wall', Vector(x, 0))
    --     self.base:add_block('wall', Vector(x, 26))
    -- end

    self.base:init()

    love.graphics.setLineWidth(1)
end

function ModeClassic:update(dt)
    self.base:update(dt)
end

function ModeClassic:draw()
    self.base:draw(dt)
end

function ModeClassic:on_fruit_collision(pos)
    
    self.base:add_fruits(1)
    if self.base.step > .05 then self.base.step = self.base.step - .0025 end
end

function ModeClassic:on_self_collision()
    self.base:die()
end

function ModeClassic:on_block_collision(id)
    if id == 'wall' then self.base:die() end
end
