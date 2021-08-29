ModeClassic = Object:extend()

function ModeClassic:new()
    self.name = 'Ye Olde Classic'
    self.base = BaseSnek(self)

    self.base.starting_fruits = 30
    
    self.base.on_fruit = self.on_fruit

    self.base:init()
end

function ModeClassic:update(dt)
    self.base:update(dt)
end

function ModeClassic:draw()
    self.base:draw(dt)
end

function ModeClassic:on_step()
    print(self.test)
end

function ModeClassic:on_fruit()
    self.base:add_fruit()
end
