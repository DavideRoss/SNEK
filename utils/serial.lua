Serial = Object:extend()

local binser = require '../libs/binser/binser'

function Serial:new(filename)
    self.filename = filename

    self.object = {
        records = {
            classic = nil
        }
    }
end

function Serial:save()
    -- local data = binser.serialize(self.object)
    binser.writeFile(self.filename, self.object)
end

function Serial:load()
    local data, len = binser.readFile(self.filename)
    self.object = data[1]
end

function Serial:getRecord(handle)
    return self.object.records[handle]
end

function Serial:setRecord(handle, points)
    self.object.records[handle] = points
end