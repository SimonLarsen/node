local LineCollider = require("LineCollider")

local Laser = class("Laser", Entity)

Laser.static.LIFETIME = 0.4

function Laser:initialize(x1, y1, x2, y2)
	Entity.initialize(self, (x1+x2)/2, (y1+y2)/2)
	self:setName("laser")

	self.x1 = x1
	self.y1 = y1
	self.x2 = x2
	self.y2 = y2

	self.time = Laser.static.LIFETIME

	self.collider = LineCollider(x1, y1, x2, y2)
end

function Laser:update(dt)
	self.time = self.time - dt
	if self.time <= 0 then
		self:kill()
	end
end

function Laser:draw()
	local w = 2 + math.abs(math.cos(love.timer.getTime() * 32))

	love.graphics.setColor(0, 255, 148)
	love.graphics.setLineWidth(w + 2)
	love.graphics.line(self.x1, self.y1-13, self.x2, self.y2-13)

	love.graphics.setColor(255, 255, 255)
	love.graphics.setLineWidth(w)
	love.graphics.line(self.x1, self.y1-13, self.x2, self.y2-13)
end

return Laser
