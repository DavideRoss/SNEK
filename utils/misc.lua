function format_timer(timer)
    local decimals = math.min(99, (timer - math.floor(timer)) * 100)
    local seconds = math.floor(math.fmod(timer, 60))
    local minutes = math.floor(timer / 60)

    return string.format('%.2d:%.2d.%.2d', minutes, seconds, decimals)
end