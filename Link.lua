local Link = class("Link", Entity)

function Link:initialize()
	Entity.initialize(self, 0, 0, -10)

	self.links = {}
end

function Link:update(dt)

end

function Link:gui()
	for i=1, #self.links-1 do
		love.graphics.line(self.links[i].x, self.links[i].y, self.links[i+1].x, self.links[i+1].y)
	end
end

return Link
