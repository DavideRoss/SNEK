-- PARAMETERS
-- starting_fruits
-- step_decrease TODO:
-- min_step TODO:
-- palette TODO:

-- EVENTS
-- on_step
-- on_fruit
-- on_death TODO:

-- FUNCTIONS
-- add_fruit (TODO: make it plural)
-- decrease_step TODO:

-- TODO: add walls support
-- TODO: animate tiles

BaseSnek = Object:extend()

local limits = {
    top = 3,
    left = 1,
    right = 1,
    bottom = 2
}

function BaseSnek:new(parent)
    self.parent = parent

    input:bind('escape', 'pause')
    input:bind('p', 'pause')

    input:bind('r', 'restart')

    input:bind('w', 'up')
    input:bind('a', 'left')
    input:bind('s', 'down')
    input:bind('d', 'right')
end

function BaseSnek:init()
    self.running = true
    self.alive = true
    self.points = 0

    self.timer = 0
    self.step = .1

    self.mov = { x = -1, y = 0 }
    self.next_mov = nil

    self.head_pos = { x = 14, y = 15}
    self.tail_pos = {
        { x = 15, y = 15},
        { x = 16, y = 15},
        -- { x = 17, y = 15},
        -- { x = 18, y = 15},
        -- { x = 19, y = 15},
        -- { x = 20, y = 15},
        -- { x = 21, y = 15},
        -- { x = 22, y = 15}
    }

    self.fruits = {}
    if not self.starting_fruits then self.starting_fruits = 1 end
    for i = 1, self.starting_fruits do
        self:add_fruit()
    end
end

function BaseSnek:update(dt)
    if input:pressed('pause') then self.running = not self.running end
    if input:pressed('restart') then self:init() end

    if self.running and self.alive then
        if input:pressed('up') and self.mov.y == 0 then self.next_mov = { x = 0, y = -1 } end
        if input:pressed('down') and self.mov.y == 0 then self.next_mov = { x = 0, y = 1 } end
        if input:pressed('left') and self.mov.x == 0 then self.next_mov = { x = -1, y = 0 } end
        if input:pressed('right') and self.mov.x == 0 then self.next_mov = { x = 1, y = 0 } end

        self.timer = self.timer + dt

        if self.timer > self.step then
            self.timer = self.timer - self.step
            self:do_step()
        end
    end
end

function BaseSnek:draw()
    -- Grid
    love.graphics.setColor({ .3, .3, .3, 1 })

    for i = 0, 32 do
        love.graphics.line(i * 32, 0, i * 32, 1024)
    end

    for i = 0, 32 do
        love.graphics.line(0, i * 32, 1024, i * 32)
    end

    -- Fruits
    love.graphics.setColor({ .1, .9, .1, 1})
    for i = 1, #self.fruits do
        self:draw_tile(self.fruits[i])
    end

    -- Tail
    love.graphics.setColor({ .9, .64, .2, 1 })
    for i = 1, #self.tail_pos do
        self:draw_tile(self.tail_pos[i])
    end

    -- Head
    love.graphics.setColor({ 1, 0, 0, 1 })
    self:draw_tile(self.head_pos)

    -- Frame
    love.graphics.setColor({ .5, .5, .5, 1})
    love.graphics.rectangle('fill', 0, 0, 1024, 32 * limits.top)
    love.graphics.rectangle('fill', 0, 32 * limits.top, 32 * limits.left, 32 * (32 - limits.top))
    love.graphics.rectangle('fill', 992, 32 * limits.top, 32 * limits.right, 32 * (32 - limits.top))
    love.graphics.rectangle('fill', 32 * limits.right, 1024 - (32 * limits.bottom), 1024 - (32 * (limits.right + limits.left)), 32 * limits.bottom)

    -- Frame test
    love.graphics.setColor({ 1, 1, 1 })
    love.graphics.setFont(font_big)
    love.graphics.printCentered(self.points, nil, 10)

    love.graphics.setFont(font_medium)
    love.graphics.print('Mode', 32, 25)
    love.graphics.setFont(font_mediumbold)
    love.graphics.print(self.parent.name, 32, 45)

    love.graphics.setFont(font_medium)
    love.graphics.printRight('Record', 32, 25)
    love.graphics.setFont(font_mediumbold)
    love.graphics.printRight('999', 32, 45)
end

function BaseSnek:draw_tile(pos)
    love.graphics.rectangle('fill', pos.x * 32 + 1, pos.y * 32 + 1, 30, 30)
end

function BaseSnek:do_step()
    if self.on_step then self.on_step(self.parent) end

    -- Tail following
    self.last_tail = {
        x = self.tail_pos[#self.tail_pos].x,
        y = self.tail_pos[#self.tail_pos].y
    }

    for i = #self.tail_pos, 2, -1 do
        self.tail_pos[i].x = self.tail_pos[i - 1].x
        self.tail_pos[i].y = self.tail_pos[i - 1].y
    end
    self.tail_pos[1].x = self.head_pos.x
    self.tail_pos[1].y = self.head_pos.y

    -- Head movement
    if self.next_mov then
        self.mov.x = self.next_mov.x
        self.mov.y = self.next_mov.y

        self.next_mov = nil
    end

    self.head_pos.x = self.head_pos.x + self.mov.x
    self.head_pos.y = self.head_pos.y + self.mov.y

    -- Self collision
    if M.find(self.tail_pos, self.head_pos) then self.alive = false end

    -- Fruit catching
    local fruit_index = M.find(self.fruits, self.head_pos)
    if fruit_index then
        self.points = self.points + 1
        table.insert(self.tail_pos, self.last_tail)

        self.fruits[fruit_index] = nil
        self.fruits = M.compact(self.fruits)

        if self.on_fruit then self.on_fruit(self.parent) end
    end

    -- Warping
    if self.head_pos.x < limits.left then self.head_pos.x = 31 - limits.right end
    if self.head_pos.x > 31 - limits.right then self.head_pos.x = limits.left end

    if self.head_pos.y < limits.top then self.head_pos.y = 31 - limits.bottom end
    if self.head_pos.y > 31 - limits.bottom then self.head_pos.y = limits.top end
end

-- TODO: make sure the fruit doesn't spawn on head, tail, walls or other fruits
function BaseSnek:add_fruit()
    table.insert(self.fruits, {
        x = love.math.random(limits.left, 31 - limits.right),
        y = love.math.random(limits.top, 31 - limits.bottom)
    })
end