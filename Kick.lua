local BoxCollider = require("BoxCollider")

local Kick = class("Kick", Entity)

Kick.static.TIME = 0.3

function Kick:initialize(x, y, xspeed, yspeed)
	Entity.initialize(self, x, y, 0)
	self:setName("kick")

	self.xspeed = xspeed or 0
	self.yspeed = yspeed or 0

	self.image = Resources.getImage("kick.png")
	self.time = Kick.static.TIME

	self.collider = BoxCollider(96, 96, 0, 0)
end

function Kick:update(dt)
	self.time = self.time - dt

	self.xspeed = math.movetowards(self.xspeed, 0, 1000*dt)
	self.yspeed = math.movetowards(self.yspeed, 0, 1000*dt)

	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt

	if self.time <= 0 then
		self:kill()
	end
end

return Kick
