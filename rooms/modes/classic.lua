ModeClassic = Object:extend()

function ModeClassic:new()
    self.name = 'Classic'
    self.handle = 'classic'
    self.base = BaseSnek(self, {
        starting_fruits = 30,
        step_initial = .25,
        on_fruit = self.on_fruit,
        on_death = self.on_death
    })

    self.palette = palettes.classic
    -- self.base.starting_fruits = 30
    -- self.base.step_initial = .25
    
    -- self.base.on_fruit = self.on_fruit
    -- self.base.on_death = self.on_death

    self.base:add_block_definition('wall', 'wall', true)

    self.base:init()

    love.graphics.setLineWidth(1)
end

function ModeClassic:update(dt)
    self.base:update(dt)
end

function ModeClassic:draw()
    self.base:draw(dt)
end

function ModeClassic:on_step()
    -- print(self.test)
end

function ModeClassic:on_fruit()
    self.base:add_fruits(1)
    if self.base.step > .05 then self.base.step = self.base.step - .0025 end
end

function ModeClassic:on_death()
    print('on death trigger')
end