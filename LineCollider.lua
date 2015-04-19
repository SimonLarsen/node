local Collider = require("Collider")

local LineCollider = class("LineCollider", Collider)

function LineCollider:initialize(x1, y1, x2, y2)
	self.x1 = x1
	self.y1 = y1
	self.x2 = x2
	self.y2 = y2
end

function LineCollider:getType()
	return "line"
end

return LineCollider
