local LinkJoint = class("LinkJoint")

LinkJoint.static.MIN_SPEED = 64

function LinkJoint:initialize(e1, e2)
	self.e1, self.e2 = e1, e2
	self.active = true

	local x1, y1 = self.e1.x, self.e1.y
	local x2, y2 = self.e2.x, self.e2.y

	self.dist = math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

function LinkJoint:update(dt)
	if self.e1:isSolid() and self.e2:isSolid() then
		self.active = false
		return
	end

	local x1, y1 = self.e1.x, self.e1.y
	local x2, y2 = self.e2.x, self.e2.y

	self.dist = math.sqrt((x1 - x2)^2 + (y1 - y2)^2)

	local speed = math.max(0.1 * self.dist, LinkJoint.static.MIN_SPEED*dt)

	self.dist = math.movetowards(self.dist, 0, speed)

	self.active = self.dist > 1
end

function LinkJoint:isActive()
	return self.active
end

return LinkJoint
