local CollisionHandler = require("CollisionHandler")
local Explosion = require("Explosion")

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
	if  Mouse.isDown("l")
	and CollisionHandler.checkMouseHover(self) then
		local link = self.scene:find("link")
		link:addLink(self)
	end
end

function Enemy:destroy()
	self.scene:add(Explosion(self.x, self.y))
	self:kill()
end

function Enemy:onCollide(o)
	if self:isLinked() == false
	and o.isLinked and o:isLinked() and o:isSolid() == false then
		self:destroy()
	end

	if o:getName() == "kick"
	or o:getName() == "bigexplosion" then
		self:destroy()
	end
end

return Enemy
