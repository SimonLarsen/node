local MapCover = class("MapCover", Entity)

function MapCover:initialize(front_batch)
	Entity.initialize(self, 0, 10000, -100000)
	self:setName("mapcover")

	self.front_batch = front_batch
end

function MapCover:draw()
	love.graphics.draw(self.front_batch, 0, 0)
end

return MapCover
