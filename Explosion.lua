local Explosion = class("Explosion", Entity)

function Explosion:initialize(x, y)
	Entity.initialize(self, x, y, 0)

	self.animation = Animation(Resources.getImage("explosion.png"), 46, 44, 0.1)
	self.time = 0.7
	camera:setScreenShake(4, 0.5)
end

function Explosion:update(dt)
	self.animation:update(dt)

	self.time = self.time - dt
	if self.time <= 0 then
		self:kill()
	end
end

function Explosion:draw()
	self.animation:draw(self.x, self.y-14, 0, 1, 1, 23, 22)
end

return Explosion
