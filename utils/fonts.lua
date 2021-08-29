FontLoader = {}

fonts = {}

function FontLoader.initialize()
    FontLoader.load('main', 'nokiafc22.ttf', 16)
    FontLoader.load('title', 'main.ttf', 200)

    -- https://www.dafont.com/it/pixel-operator.font?text=Ye+Olde+Classic+SNEK
    FontLoader.load('big', 'pixel_operator/PixelOperator-Bold.ttf', 72)
    FontLoader.load('medium', 'pixel_operator/PixelOperator.ttf', 24)
    FontLoader.load('medium_bold', 'pixel_operator/PixelOperator-Bold.ttf', 24)
    FontLoader.load('medium_mono', 'pixel_operator/PixelOperatorMono.ttf', 24)

    love.graphics.setFont(fonts.main)
end

function FontLoader.load(label, filename, size)
    local newFont = love.graphics.newFont('assets/fonts/' .. filename, size)
    newFont:setFilter('nearest', 'nearest')
    fonts[label] = newFont
end
