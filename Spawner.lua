local Spawner = class("Spawner", Entity)

Spawner.static.DEFAULT_TIME = 1.2

function Spawner:initialize(x, y, entity, time)
	Entity.initialize(self, x, y)

	self.entity = entity
	self.time = time or Spawner.static.DEFAULT_TIME
	self.animation = Animation(Resources.getImage("spawner.png"), 73, 82, self.time / 12)
end

function Spawner:update(dt)
	self.animation:update(dt)

	self.time = self.time - dt
	if self.time <= 0 then
		self.scene:add(self.entity)
		self:kill()
	end
end

function Spawner:draw()
	self.animation:draw(self.x, self.y, 0, 1, 1, 36, 70)
end

function Spawner:progress()
	return 1 - (self.time / Spawner.static.DEFAULT_TIME)
end

return Spawner
