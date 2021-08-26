require 'utils/color'
require 'utils/table'
require 'utils/palette'

Object = require 'libs/classic/classic'
Timer = require 'libs/hump/timer'
Input = require 'libs/boipushy/Input'

function love.load()
    input = Input()

    local room_files = {}
    recursiveEnumerate('rooms', room_files)
    requireFiles(room_files)

    font_main = love.graphics.newFont('assets/fonts/main.ttf')
    font_title = love.graphics.newFont('assets/fonts/main.ttf', 200)
    font_subtitle = love.graphics.newFont('assets/fonts/main.ttf', 36)
    love.graphics.setFont(font_main)

    current_room = nil
    goToRoom('StartRoom')
end

function love.update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

function love.keypressed(key, scancode, isrepeat)
    if current_room and current_room.keypressed then current_room.keypressed(key, scancode, isrepeat) end
end

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