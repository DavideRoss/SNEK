GridRoom = Object:extend()

local modes = {
    { label = 'Classic', room = 'ModeClassic', handle = 'classic' },
    { label = 'Walled', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Hunger', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Battlefield', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Hydra', room = 'TestRoom', handle = 'testhandle' },
    { label = 'The Hunt', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Confusion', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Lawnmower', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 1', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 2', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 3', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 4', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 5', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 6', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 7', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 8', room = 'TestRoom', handle = 'testhandle' },
    { label = 'Test 9', room = 'TestRoom', handle = 'testhandle' }
}

function GridRoom:new()
    love.graphics.setBackgroundColor({ .3, .3, .3, 1})

    self.controls = {}

    local count = 4
    local margin = 32
    local total_margin = (count + 1) * margin
    local cell_width = math.round((1024 - total_margin) / count)
    local initial_offset = 128

    local rows = math.ceil(#modes / 4)
    for row = 0, rows - 1 do
        for i = 0, count - 1 do
            if modes[row * 4 + i + 1] then
                local newButton = Button(self, margin * (i + 1) + cell_width * i, initial_offset + row * 128 + (margin * row), cell_width, 128)
                newButton.label = modes[row * 4 + i + 1].label
                newButton.object = modes[row * 4 + i + 1]
                newButton.on_click = self.on_click

                table.insert(self.controls, newButton)
            end
        end
    end
end

function GridRoom:update(dt)
    for i, v in ipairs(self.controls) do v:update(dt) end
end

function GridRoom:draw()
    self:drawRect({ 0, 0, 0, .5 }, 0, 0, 32, 3)
    self:drawRect({ 0, 0, 0, .5 }, 0, 31, 32, 1)

    for i, v in ipairs(self.controls) do v:draw() end

    -- love.graphics.setColor({ 0, 0, 0, .05})
    -- love.graphics.setLineWidth(1)

    -- for i = 0, 32 do
    --     love.graphics.line(i * 32, 0, i * 32, 1024)
    -- end

    -- for i = 0, 32 do
    --     love.graphics.line(0, i * 32, 1024, i * 32)
    -- end
end

function GridRoom:drawRect(col, x, y, w, h)
    love.graphics.setColor(col)
    love.graphics.rectangle('fill', x * 32, y * 32, w * 32, h * 32)
end

function GridRoom:on_click(object)
    goToRoom(object.room)
end