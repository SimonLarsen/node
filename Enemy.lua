local CollisionHandler = require("CollisionHandler")

local Enemy = class("Enemy", Entity)

function Enemy:initialize(x, y, z, mass, solid, linkz)
	Entity.initialize(self, x, y, z)

	self.mass = mass
	self.solid = solid
	self.linkz = linkz or 0

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

function Enemy:checkLinked()
	if self:isLinked() == false and Mouse.isDown("l")
	and CollisionHandler.checkMouseHover(self) then
		local link = self.scene:find("link")
		self:setLinked(link:addLink(self))
	end
end

return Enemy
