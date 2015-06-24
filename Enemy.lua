local Linkable = require("Linkable")

local Enemy = class("Enemy", Linkable)

function Enemy:onRemove()
	self.scene:find("controller"):addKill(self)
end

function Enemy:countsInWave()
	return true
end

function Enemy:onCollide(o, dt)
	if o:getName() == "playerbullet" then
		self:stun()
	elseif o:getName() == "kick" and self:isStunned() then
		self:destroy()
	else
		Linkable.onCollide(self, o, dt)
	end
end

return Enemy
