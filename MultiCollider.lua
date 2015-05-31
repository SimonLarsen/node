local Collider = require("Collider")

local MultiCollider = class("MultiCollider", Collider)

function MultiCollider:initialize(colliders)
	self.colliders = colliders or {}
end

function MultiCollier:getType()
	return "multi"
end

function MultiCollider:add(c)
	table.insert(self.colliders, c)
end

function MultiCollider:getColliders()
	return self.colliders
end

return MultiCollider
