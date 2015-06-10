local CollisionHandler = require("CollisionHandler")
local Explosion = require("Explosion")

local Enemy = class("Enemy", Entity)

Enemy.static.LINK_DECREASE = 5

function Enemy:initialize(x, y, z, mass, solid, linkz, link_time)
	Entity.initialize(self, x, y, z)

	self.mass = mass
	self.solid = solid
	self.linkz = linkz or 0
	self.link_time = link_time

	self.linked = false
	self.triggered = false
	self.link_progress = 0
end

function Enemy:enter()
	self.player = self.scene:find("player")
end

function Enemy:update(dt)
	self.link_progress = math.movetowards(self.link_progress, 0, Enemy.static.LINK_DECREASE*dt)
end

function Enemy:isLinked()
	return self.linked
end

function Enemy:setLinked(state)
	self.linked = state
end

function Enemy:isTriggered()
	return self.triggered
end

function Enemy:setTriggered(state)
	self.triggered = state
end

function Enemy:isSolid()
	return self.solid
end

function Enemy:destroy(playSound)
	if playSound == nil then playSound = true end

	if playSound then
		Resources.playSound("explosion_light.wav")
	end

	self.scene:add(Explosion(self.x, self.y))
	self:kill()
end

function Enemy:onCollide(o, dt)
	if self:isTriggered() == false
	and o.isTriggered and o:isTriggered() and o:isSolid() == false then
		self:destroy()
	end

	if o:getName() == "link" and self.player:isLinking() then
		self.link_progress = self.link_progress + (1 / self.link_time + Enemy.static.LINK_DECREASE) * dt
		if self.link_progress >= 1 then
			self.scene:find("link"):addLink(self)
		end
	end

	if o:getName() == "kick"
	or o:getName() == "bigexplosion" then
		self:destroy()
	end
end

function Enemy:onRemove()
	self.scene:find("controller"):addKill(self)
end

function Enemy:drawLink()
	if self.link_progress > 0 and self.link_progress < 1 then
		love.graphics.arc("fill", self.x, self.y+self.linkz, 10, 0, self.link_progress*2*math.pi, 32)
	end
end

function Enemy:countsInWave()
	return true
end

return Enemy
