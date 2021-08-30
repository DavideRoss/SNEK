Object = require 'libs/classic/classic'
Timer = require 'libs/hump/timer'
Input = require 'libs/boipushy/Input'
M = require 'libs/Moses/moses'

require 'utils/color'
require 'utils/table'
require 'utils/palette'
require 'utils/extension'
require 'utils/serial'
require 'utils/fonts'
require 'utils/misc'

require 'gameplay/base'
require 'gameplay/block'

-- TODO: rename functions and variables as Lua style standards

function love.load()
    input = Input()

    FontLoader.initialize()

    local room_files = {}
    recursiveEnumerate('rooms', room_files)
    requireFiles(room_files)

    local ui_files = {}
    recursiveEnumerate('ui', ui_files)
    requireFiles(ui_files)

    -- TODO: check if file exists
    serial = Serial('./snek.sav')
    serial:load()

    current_room = nil
    -- TODO: replace with StartRoom in production
    goToRoom('ModeClassic')
end

function love.update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

--- EVENTS ---

function love.keypressed(key, scancode, isrepeat)
    if current_room and current_room.keypressed then current_room.keypressed(key, scancode, isrepeat) end
end

function love.mousemoved(x, y, dx, dy)
    if current_room and current_room.mousemoved then current_room.mousemoved(x, y, dx, dy) end
end

-- TODO: add fade transition to black?
function goToRoom(room_type, ...)
    current_room = _G[room_type](...)
end

--- LOADING ---

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.getInfo(file, 'file') then
            table.insert(file_list, file)
        elseif love.filesystem.getInfo(file, 'directory') then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end