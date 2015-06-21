local CollisionHandler = require("CollisionHandler")
local Explosion = require("Explosion")

local Linkable = class("Linkable", Entity)

Linkable.static.LINK_DECREASE = 4

function Linkable:initialize(x, y, z, mass, solid, linkz, link_time)
	Entity.initialize(self, x, y, z)

	self.mass = mass
	self.solid = solid
	self.linkz = linkz or 0
	self.link_time = link_time

	self.linked = false
	self.triggered = false
	self.link_progress = 0
end

function Linkable:enter()
	self.player = self.scene:find("player")
end

function Linkable:update(dt)
	self.link_progress = math.movetowards(self.link_progress, 0, Linkable.static.LINK_DECREASE*dt)
end

function Linkable:isLinked()
	return self.linked
end

function Linkable:setLinked(state)
	self.linked = state
end

function Linkable:isTriggered()
	return self.triggered
end

function Linkable:setTriggered(state)
	self.triggered = state
end

function Linkable:isSolid()
	return self.solid
end

function Linkable:destroy(playSound)
	if playSound == nil then playSound = true end

	if playSound then
		Resources.playSound("explosion_light.wav")
	end

	self.scene:add(Explosion(self.x, self.y))
	self:kill()
end

function Linkable:onCollide(o, dt)
	if self:isTriggered() == false
	and o.isTriggered and o:isTriggered() and o:isSolid() == false then
		self:destroy()
	end

	if o:getName() == "link" and self.player:isLinking() then
		self.link_progress = self.link_progress + (1 / self.link_time + Linkable.static.LINK_DECREASE) * dt
		if self.link_progress >= 1 then
			self.scene:find("link"):addLink(self)
		end
	end

	if o:getName() == "kick"
	or o:getName() == "bigexplosion" then
		self:destroy()
	end
end

function Linkable:drawLink()
	if self.link_progress > 0 and self.link_progress < 1 then
		love.graphics.arc("fill", self.x, self.y+self.linkz, 10, 0, self.link_progress*2*math.pi, 32)
	end
end

return Linkable
