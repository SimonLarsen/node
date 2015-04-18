local Enemy = class("Enemy", Entity)

function Enemy:initialize(...)
	Entity.initialize(self, ...)

	self.linked = false
end

function Enemy:isLinked()
	return self.linked
end

function Enemy:setLinked()
	self.linked = true
end

return Enemy
