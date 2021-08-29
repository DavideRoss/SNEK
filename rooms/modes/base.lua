-- PARAMETERS
-- starting_fruits
-- step_initial
-- step
-- palette

-- EVENTS
-- on_step
-- on_fruit
-- on_death TODO:

-- FUNCTIONS
-- add_fruit (TODO: make it plural)
-- decrease_step TODO:

-- TODO: add walls support
-- TODO: animate tiles
-- TODO: dynamic start positions
-- TODO: add arrows on controls

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

    -- Load record
    self.record = serial:getRecord(self.parent.handle)

    self.palette = palettes.classic

    love.graphics.setBackgroundColor(self.palette.background)
end

function BaseSnek:init()
    self.running = true
    self.alive = true
    self.points = 0

    self.timer = 0
    self.total_timer = 0
    self.step = self.step_initial or .25

    self.mov = { x = -1, y = 0 }
    self.next_mov = nil

    self.head_pos = { x = 14, y = 15}
    self.tail_pos = {
        { x = 15, y = 15},
        { x = 16, y = 15}
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
        self.total_timer = self.total_timer + dt

        if self.timer > self.step then
            self.timer = self.timer - self.step
            self:do_step()
        end
    end
end

function BaseSnek:draw()
    -- Fruits
    love.graphics.setColor(self.palette.fruit)
    for i = 1, #self.fruits do
        self:draw_tile(self.fruits[i])
    end

    -- Tail
    love.graphics.setColor(self.palette.tail)
    for i = 1, #self.tail_pos do
        self:draw_tile(self.tail_pos[i])
    end

    -- Head
    love.graphics.setColor(self.palette.head)
    self:draw_tile(self.head_pos)

    -- Grid
    love.graphics.setColor(self.palette.grid)

    for i = 0, 32 do
        love.graphics.line(i * 32, 0, i * 32, 1024)
    end

    for i = 0, 32 do
        love.graphics.line(0, i * 32, 1024, i * 32)
    end

    -- Frame
    love.graphics.setColor(self.palette.frame)
    love.graphics.rectangle('fill', 0, 0, 1024, 32 * limits.top)
    love.graphics.rectangle('fill', 0, 32 * limits.top, 32 * limits.left, 32 * (32 - limits.top))
    love.graphics.rectangle('fill', 992, 32 * limits.top, 32 * limits.right, 32 * (32 - limits.top))
    love.graphics.rectangle('fill', 32 * limits.right, 1024 - (32 * limits.bottom), 1024 - (32 * (limits.right + limits.left)), 32 * limits.bottom)

    -- Frame text
    love.graphics.setColor(self.palette.text)

    love.graphics.setFont(fonts.big)
    love.graphics.printCentered(self.points, nil, 0)
    love.graphics.setFont(fonts.medium_mono)
    love.graphics.printCentered(self:format_timer(), nil, 65)

    love.graphics.setFont(fonts.medium)
    love.graphics.print('Mode', 32, 22)
    love.graphics.setFont(fonts.medium_bold)
    love.graphics.print(self.parent.name, 32, 48)

    love.graphics.setFont(fonts.medium)
    love.graphics.printRight('Record', 32, 22)
    love.graphics.setFont(fonts.medium_bold)
    love.graphics.printRight(tostring(self.record or '???'), 32, 48)
end

function BaseSnek:draw_tile(pos)
    love.graphics.rectangle('fill', pos.x * 32, pos.y * 32, 32, 32)
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
    if M.find(self.tail_pos, self.head_pos) then self:on_death() end

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

function BaseSnek:format_timer()
    local decimals = math.min(99, (self.total_timer - math.floor(self.total_timer)) * 100)
    local seconds = math.floor(self.total_timer)
    local minutes = math.floor(self.total_timer / 60)

    return string.format('%.2d:%.2d.%.2d', minutes, seconds, decimals)
end

function BaseSnek:on_death()
    self.alive = false

    if self.record == nil or self.points > self.record then
        self.record = self.points
        serial:setRecord(self.parent.handle, self.points)
        serial:save()
    end
end