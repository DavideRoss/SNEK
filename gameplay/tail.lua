Tail = Object:extend()

function Tail:new(color, x, y, opts)
    self.color = color
    self.timer = 0
    self.position = Vector(x, y)
    self._position = Vector(x, y)

    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    if self.appear_on_start then self:appear() end
end

function Tail:update(dt)
    if self.block then self.block:update(dt) end

    if self.next_pos and self.next_pos ~= self._position then
        self.timer = self.timer + dt

        local t = clamp01(self.timer / self.duration)
        self._position = Vector.lerp(self.position, self.next_pos, t)

        if self.timer > self.duration then
            self.timer = 0

            if self.warped_pos then
                self._position = self.warped_pos:copy()
                self.block = nil
            end

            self.position = self._position:copy()
            self.next_pos = nil
        end
    end

    if not self.next_pos then 
        self._position = self.position:copy()
    end
end

function Tail:step()
    if self.next_pos then
        local has_warped, warped_pos, warped_outside = BaseSnek.warp(self.next_pos)

        if has_warped then
            self.warped_pos = warped_pos
            self.prev_pos = self.next_pos:copy()
        else self.warped_pos = nil end

        if has_warped and self.block == nil then
            self.block = Block(self.color, warped_outside.x, warped_outside.y, {
                next_pos = warped_pos,
                duration = self.duration
            })
        end
    end
end

function Tail:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle(
        'fill',
        (self._position.x + BaseSnek.limits.left) * 32,
        (self._position.y + BaseSnek.limits.top) * 32,
        32, 32
    )

    if self.next_pos then
        love.graphics.rectangle(
            'fill',
            (self.next_pos.x + BaseSnek.limits.left) * 32,
            (self.next_pos.y + BaseSnek.limits.top) * 32,
            32, 32
        )
    end

    if self.block then self.block:draw() end
end
