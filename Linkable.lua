local CollisionHandler = require("CollisionHandler")
local Explosion = require("Explosion")

local Linkable = class("Linkable", Entity)

Linkable.static.HP_INCREASE = 0.5
Linkable.static.LINK_DECREASE = 4

function Linkable:initialize(x, y, z, mass, solid, linkz, max_hp)
	Entity.initialize(self, x, y, z)

	self.mass = mass
	self.solid = solid
	self.linkz = linkz or 0
	self.max_hp = max_hp
	self.hp = self.max_hp
	self.increase_cooldown = 0

	self.stunned = false
	self.linked = false
	self.triggered = false
end

function Linkable:enter()
	self.player = self.scene:find("player")
end

function Linkable:update(dt)
	if self:isStunned() then
		self.hp = self.hp + Linkable.static.HP_INCREASE * dt
		if self.hp >= self.max_hp then
			self.hp = self.max_hp
			self.stunned = false
		end
	end
end

function Linkable:isLinked()
	return self.linked
end

function Linkable:setLinked(state)
	self.linked = state
end

function Linkable:stun()
	self.hp = self.hp - 1
	if self.hp <= 0 then
		self.hp = 0
		self.stunned = true
	end
end

function Linkable:isStunned()
	return self.stunned
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

function Linkable:destroy()
	self.scene:add(Explosion(self.x, self.y))
	self:kill()
end

function Linkable:onCollide(o, dt)
	if self:isTriggered() == false
	and o.isTriggered and o:isTriggered() and o:isSolid() == false then
		self:destroy()
	end

	if o:getName() == "link" and self.player:isLinking()
	and self:isStunned() then
		self.scene:find("link"):addLink(self)
	end
end

function Linkable:drawLink()
	if self:isStunned() then
		love.graphics.arc("fill", self.x, self.y+self.linkz, 10, 0, (1 - self.hp/self.max_hp)*2*math.pi, 32)
	end
end

return Linkable
