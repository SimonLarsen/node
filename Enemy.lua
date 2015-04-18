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

function Enemy:setLinked(state)
	self.linked = state
end

function Enemy:isSolid()
	return self.solid
end

function Enemy:onClick(x, y)
	if self:isLinked() == false then
		local link = self.scene:find("link")
		self:setLinked(link:addLink(self))
	end

	return true
end

return Enemy
