function len(tab)
    local count = 0
    for _ in pairs(tab) do count = count + 1 end
    return count
end

function tableAt(tab, i)
    local count = 1
    for k, v in pairs(tab) do
        print(count, i, k, v)
        if count == i then return v end
        count = count + 1
    end
    return nil
end

function register(evt, func)
    -- local empty_function = function() end
    local old_functions = love[evt] or function() end
    love[evt] = function(...)
        old_functions(...)
        func(...)
    end
end