local Enemy = class("Enemy", Entity)

function Enemy:initialize(x, y, z, mass, solid)
	Entity.initialize(self, x, y, z)

	self.mass = mass
	self.solid = solid

	self.linked = false
end

function Enemy:isLinked()
	return self.linked
end

function Enemy:setLinked()
	self.linked = true
end

function Enemy:isSolid()
	return self.solid
end

return Enemy
