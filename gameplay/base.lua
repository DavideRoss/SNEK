-- PARAMETERS
-- starting_fruits
-- step_initial
-- step
-- palette

-- EVENTS
-- on_step
-- on_fruit
-- on_death

-- FUNCTIONS
-- add_fruit (TODO: make it plural)
-- decrease_step TODO:

-- TODO: add walls support
-- TODO: animate tiles
-- TODO: dynamic start positions
-- TODO: add arrows on controls
-- TODO: add settings object on new

BaseSnek = Object:extend()

BaseSnek.limits = {
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

    self.head = Block(self.palette.head, 14, 15)
    self.tail = {
        Block(self.palette.tail, 15, 15),
        Block(self.palette.tail, 16, 15)
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
    for i = 1, #self.fruits do self.fruits[i]:draw() end

    -- Tail
    for i = 1, #self.tail do self.tail[i]:draw() end

    -- Head
    self.head:draw()

    -- Grid
    love.graphics.setColor(self.palette.grid)
    for i = 0, 32 do love.graphics.line(i * 32, 0, i * 32, 1024) end
    for i = 0, 32 do love.graphics.line(0, i * 32, 1024, i * 32) end

    -- Frame
    love.graphics.setColor(self.palette.frame)
    love.graphics.rectangle('fill', 0, 0, 1024, 32 * BaseSnek.limits.top)
    love.graphics.rectangle('fill', 0, 32 * BaseSnek.limits.top, 32 * BaseSnek.limits.left, 32 * (32 - BaseSnek.limits.top))
    love.graphics.rectangle('fill', 992, 32 * BaseSnek.limits.top, 32 * BaseSnek.limits.right, 32 * (32 - BaseSnek.limits.top))
    love.graphics.rectangle('fill', 32 * BaseSnek.limits.right, 1024 - (32 * BaseSnek.limits.bottom), 1024 - (32 * (BaseSnek.limits.right + BaseSnek.limits.left)), 32 * BaseSnek.limits.bottom)

    -- Frame text
    love.graphics.setColor(self.palette.text)

    love.graphics.setFont(fonts.big)
    love.graphics.printCentered(self.points, nil, 0)
    love.graphics.setFont(fonts.medium_mono)
    love.graphics.printCentered(format_timer(self.total_timer), nil, 65)

    love.graphics.setFont(fonts.medium)
    love.graphics.print('Mode', 32, 22)
    love.graphics.setFont(fonts.medium_bold)
    love.graphics.print(self.parent.name, 32, 48)

    love.graphics.setFont(fonts.medium)
    love.graphics.printRight('Record', 32, 22)
    love.graphics.setFont(fonts.medium_bold)
    love.graphics.printRight(tostring(self.record.score or '???'), 32, 48)
end

function BaseSnek:draw_tile(pos)
    love.graphics.rectangle('fill', pos.x * 32, pos.y * 32, 32, 32)
end

function BaseSnek:do_step()
    if self.on_step then self.on_step(self.parent) end

    -- Tail following
    self.last_tail = {
        x = self.tail[#self.tail].x,
        y = self.tail[#self.tail].y
    }

    for i = #self.tail, 2, -1 do
        self.tail[i].x = self.tail[i - 1].x
        self.tail[i].y = self.tail[i - 1].y
    end

    self.tail[1].x = self.head.x
    self.tail[1].y = self.head.y

    -- Head movement
    if self.next_mov then
        self.mov.x = self.next_mov.x
        self.mov.y = self.next_mov.y

        self.next_mov = nil
    end

    self.head.x = self.head.x + self.mov.x
    self.head.y = self.head.y + self.mov.y

    -- Self collision
    local head_pos = self.head:getPosition()
    for i, tail in ipairs(self.tail) do
        if head_pos.x == tail.x and head_pos.y == tail.y then self:on_collision() end
    end

    -- Fruit catching
    -- local fruit_index = M.find(self.fruits, self.head:getPosition())
    local fruit_index = nil
    for i, fruit in ipairs(self.fruits) do
        if head_pos.x == fruit.x and head_pos.y == fruit.y then fruit_index = i end
    end

    if fruit_index then
        self.points = self.points + 1
        table.insert(self.tail, Block(self.palette.tail, self.last_tail.x, self.last_tail.y))

        self.fruits[fruit_index] = nil
        self.fruits = M.compact(self.fruits)

        if self.on_fruit then self.on_fruit(self.parent) end
    end

    -- Warping
    local arena_width = 31 - BaseSnek.limits.left - BaseSnek.limits.right
    local arena_height = 31 - BaseSnek.limits.top - BaseSnek.limits.bottom
    if self.head.x < 0 then self.head.x = arena_width end
    if self.head.x > arena_width then self.head.x = 0 end

    if self.head.y < 0 then self.head.y = arena_height end
    if self.head.y > arena_height then self.head.y = 0 end
end

-- TODO: make sure the fruit doesn't spawn on head, tail, walls or other fruits
function BaseSnek:add_fruit()
    local x = love.math.random(BaseSnek.limits.left, 31 - BaseSnek.limits.right)
    local y = love.math.random(BaseSnek.limits.top, 31 - BaseSnek.limits.bottom)
    table.insert(self.fruits, Block(self.palette.fruit, x, y))
end

function BaseSnek:on_collision()
    self.alive = false

    if self.record.score == nil or self.points > self.record.score then
        self.record.score = self.points
        self.record.time = self.total_timer

        serial:setRecord(self.parent.handle, self.points, self.total_timer)
        serial:save()
    end

    if self.on_death then self.on_death(self.parent) end
end
