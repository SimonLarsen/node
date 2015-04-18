local Link = class("Link", Entity)

Link.static.STEP_TIME = 1/60

function Link:initialize()
	Entity.initialize(self, 0, 1000000, 0)

	self:setName("link")

	self.triggered = false
	self.timeacc = 0
	self.links = {}
end

function Link:update(dt)
	if self.triggered == false then
		if Mouse.wasPressed("r") then
			if #self.links >= 1 then
				self:trigger()
			end
		end
	else
		self.timeacc = self.timeacc + dt
		while self.timeacc > Link.static.STEP_TIME do
			self.timeacc = self.timeacc - Link.static.STEP_TIME
		end
	end
end

function Link:draw()
	for i=1, #self.links-1 do
		love.graphics.line(self.links[i].x, self.links[i].y-16, self.links[i+1].x, self.links[i+1].y-16)
	end
end

function Link:addLink(e)
	table.insert(self.links, e)
end

function Link:trigger()
	if #self.links == 1 then
		self.links = {}
		return
	end

	self.joints = {}
	for i = 1, #self.links-1 do
		local dist
	end
	self.timeacc = 0
end

return Link
