function rgb(hex)
    local r = tonumber(hex:sub(2, 3), 16) / 255
    local g = tonumber(hex:sub(4, 5), 16) / 255
    local b = tonumber(hex:sub(6, 7), 16) / 255

    local a = 1
    if hex:len() > 7 then
        a = tonumber(string.sub(hex, 8, 9), 16) / 255
    end
    
    return { r, g, b, a }
end

function lerpRGB(t, hex1, hex2)
    local r1, g1, b1, a1 = RGB(hex1)
    local r2, g2, b2, a2 = RGB(hex2)
    local u = 1 - t

    return {
        u * r1 + t * r2,
        u * g1 + t * g2,
        u * b1 + t * b2,
        u * a1 + t * a2
    }
end

-- TODO: join with palette