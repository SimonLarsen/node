local BoxCollider = require("BoxCollider")

local Kick = class("Kick", Entity)

Kick.static.TIME = 0.4

function Kick:initialize(x, y)
	Entity.initialize(self, x, y, 0)
	self:setName("kick")

	self.image = Resources.getImage("kick.png")
	self.time = Kick.static.TIME

	self.collider = BoxCollider(96, 48, 0, 0)
end

function Kick:update(dt)
	self.time = self.time - dt

	if self.time <= 0 then
		self:kill()
	end
end

function Kick:draw()
	--love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 48, 24)
end

return Kick
