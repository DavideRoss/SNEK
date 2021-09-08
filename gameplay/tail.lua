Tail = Object:extend()

function Tail:new(color, x, y, opts)
    self.color = color
    self.x = x
    self.y = y

    self._x = self.x
    self._y = self.y

    self.timer = 0

    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    -- TODO: remove size
    if not self.size then self.size = 16 end
    if self.appear_on_start then self:appear() end
end

function Tail:update(dt)
    if self.block then self.block:update(dt) end

    if self.next_pos and (self.next_pos.x ~= self._x or self.next_pos.y ~= self._y) then
        self.timer = self.timer + dt

        local t = clamp01(self.timer / self.duration)
        self._x = (1 - t) * self.x + t * self.next_pos.x
        self._y = (1 - t) * self.y + t * self.next_pos.y

        if self.timer > self.duration then
            self.timer = 0

            if self.warped_pos then
                self._x = self.warped_pos.x
                self._y = self.warped_pos.y
                self.block = nil
            end

            self.x = self._x
            self.y = self._y
            self.next_pos = nil
        end
    end

    if not self.next_pos then 
        self._x = self.x
        self._y = self.y
    end
end

function Tail:step()
    if self.next_pos then
        local has_warped, warped_pos, warped_outside = BaseSnek.warp(self.next_pos)

        if has_warped then
            self.warped_pos = warped_pos
            self.prev_pos = { x = self.next_pos.x, y = self.next_pos.y }
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
        (self._x + BaseSnek.limits.left) * 32 + (16 - self.size),
        (self._y + BaseSnek.limits.top) * 32 + (16 - self.size),
        self.size * 2,
        self.size * 2
    )

    if self.next_pos then
        love.graphics.rectangle(
            'fill',
            (self.next_pos.x + BaseSnek.limits.left) * 32 + (16 - self.size),
            (self.next_pos.y + BaseSnek.limits.top) * 32 + (16 - self.size),
            self.size * 2,
            self.size * 2
        )
    end

    if self.block then self.block:draw() end
end
