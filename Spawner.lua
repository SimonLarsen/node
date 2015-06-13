local Spawner = class("Spawner", Entity)

Spawner.static.DEFAULT_TIME = 1.2

function Spawner:initialize(x, y, entity, time)
	Entity.initialize(self, x, y-0.01)

	self.hasSpawned = false
	self.entity = entity
	self.time = time or Spawner.static.DEFAULT_TIME
	self.animation = Animation(Resources.getImage("spawner.png"), 48, 49, self.time / 13)
end

function Spawner:update(dt)
	self.animation:update(dt)

	self.time = self.time - dt

	if self.hasSpawned == false and self:progress() > 0.8 then
		self:spawn()
	end

	if self.time <= 0 then
		self:kill()
	end
end

function Spawner:spawn()
	self.scene:add(self.entity)
	self.hasSpawned = true
end

function Spawner:draw()
	self.animation:draw(self.x, self.y, 0, 1, 1, 24, 37)
end

function Spawner:progress()
	return 1 - (self.time / Spawner.static.DEFAULT_TIME)
end

return Spawner
