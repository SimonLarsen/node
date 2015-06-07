local LinkChain = class("LinkChain", Entity)

LinkChain.static.STEPTIME = 1/60
LinkChain.static.STEPSIZE = 16
LinkChain.static.RESTLENGTH = 12
LinkChain.static.GRAVITY = 150

function LinkChain:initialize(x1, y1, x2, y2, count)
	Entity.initialize(self, (x1+x2)/2, (y1+y2)/2, -1)

	local dx = x2 - x1
	local dy = y2 - y1
	local dist = vector.length(dx, dy)

	local count = count or math.ceil(dist / LinkChain.static.STEPSIZE) + 1

	self.timeacc = 0

	self.points = {}

	for i=0, count do
		local p = {}
		p.x = x1 + i / count * dx
		p.y = y1 + i / count * dy
		p.lastx = p.x
		p.lasty = p.y
		if i == 0 or i == count then
			p.fixed = true
			p.accx = 0
			p.accy = 0
		else
			p.fixed = false
			p.accx = 0
			p.accy = LinkChain.static.GRAVITY
		end

		table.insert(self.points, p)
	end
end

function LinkChain:update(dt)
	self.timeacc = self.timeacc + dt
	while self.timeacc > LinkChain.static.STEPTIME do
		self:step(LinkChain.static.STEPTIME)
		self.timeacc = self.timeacc - LinkChain.static.STEPTIME
	end
end

function LinkChain:step(dt)
	-- Update positions
	for i,p in ipairs(self.points) do
		if not p.fixed then
			local velx = p.x - p.lastx
			local vely = p.y - p.lasty

			local nextx = p.x + velx + p.accx * dt^2
			local nexty = p.y + vely + p.accy * dt^2

			p.lastx, p.lasty = p.x, p.y
			p.x, p.y = nextx, nexty
		end
	end

	-- Resolve link constraints
	for i=1, #self.points-1 do
		local p1 = self.points[i]
		local p2 = self.points[i+1]

		local diffx = p1.x - p2.x
		local diffy = p1.y - p2.y
		local d = vector.length(diffx, diffy)

		if d > LinkChain.static.RESTLENGTH then
			local difference = (LinkChain.static.RESTLENGTH - d) / d

			local translatex = diffx * 0.5 * difference
			local translatey = diffy * 0.5 * difference

			if not p1.fixed then
				p1.x = p1.x + translatex
				p1.y = p1.y + translatey
			end

			if not p2.fixed then
				p2.x = p2.x - translatex
				p2.y = p2.y - translatey
			end
		end
	end
end

function LinkChain:draw()
	love.graphics.setLineWidth(2)
	love.graphics.setColor(255, 128, 248)

	for i=1, #self.points-1 do
		local p1 = self.points[i]
		local p2 = self.points[i+1]
		love.graphics.line(p1.x, p1.y, p2.x, p2.y)
	end
end

return LinkChain
