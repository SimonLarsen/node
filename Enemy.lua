local Linkable = require("Linkable")
local BulletExplosion = require("BulletExplosion")

local Enemy = class("Enemy", Linkable)

function Enemy:initialize(x, y, z, mass, solid, linkz, max_hp, lives)
	Linkable.initialize(self, x, y, z, mass, solid, linkz, max_hp, lives)

	self.lives = lives or 1
end

function Enemy:onRemove()
	self.scene:find("controller"):addKill(self)
end

function Enemy:countsInWave()
	return true
end

function Enemy:onCollide(o, dt)
	if o:getName() == "playerbullet" then
		if self:isStunned() == false then
			self:stun()
			self.scene:add(BulletExplosion(o.x, o.y))
			o:kill()
		end
	elseif o:getName() == "kick" and self:isStunned() then
		self:destroy()
	else
		Linkable.onCollide(self, o, dt)
	end
end

function Enemy:destroy()
	self.lives = self.lives - 1
	if self.lives == 0 then
		Linkable.destroy(self)
	else
		self.hp = self.max_hp
	end
end

return Enemy
