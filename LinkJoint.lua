local LinkJoint = class("LinkJoint")

function LinkJoint:initialize(e1, e2)
	self.e1, self.t2 = e1, e2

	local x1, y1 = self.e1.x, self.e1.y
	local x2, y2 = self.e2.x, self.e2.y

	self.dist = math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

function LinkJoint:update()
	
end

return LinkJoint
