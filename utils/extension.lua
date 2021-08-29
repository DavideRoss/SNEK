-- TODO: maybe memoize the width and height for the sake of performance?
function love.graphics.printCentered(text, orig_x, orig_y, r, sx, sy, ox, oy, kx, ky)
    local font = love.graphics.getFont()
    
    local width = font:getWidth(text)
    local height = font:getHeight()

    local x = orig_x
    if x == nil then x = math.round(512 - width / 2) end

    local y = orig_y
    if y == nil then y = math.round(512 - height / 2) end

    love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
end

function love.graphics.printRight(text, orig_x, y, r, sx, sy, ox, oy, kx, ky)
    local font = love.graphics.getFont()
    local width = font:getWidth(text)
    local x = 1024 - orig_x - width

    love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
end

function math.round(n)
    return math.floor(n + .5)
end