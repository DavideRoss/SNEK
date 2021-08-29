Serial = Object:extend()

local binser = require '../libs/binser/binser'

function Serial:new(filename)
    self.filename = filename

    self.object = {
        records = {
        }
    }
end

function Serial:save()
    binser.writeFile(self.filename, self.object)
end

function Serial:load()
    local data, len = binser.readFile(self.filename)
    self.object = data[1]
end

function Serial:getRecord(handle)
    if self.object.records[handle] then
        return self.object.records[handle]
    else
        return {
            score = nil,
            time = nil
        }
    end
end

function Serial:setRecord(handle, points, time)
    self.object.records[handle] = {
        score = points,
        time = time
    }
end
