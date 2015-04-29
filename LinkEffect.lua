local LinkEffect = class("LinkEffect", Entity)

LinkEffect.static.TIME = 0.3

function LinkEffect:initialize(enemy)
	Entity.initialize(self, enemy.x, enemy.y, 0)

	self.enemy = enemy

	self.time = LinkEffect.static.TIME
	self.anim = Animation(Resources.getImage("link_effect.png"), 32, 32, LinkEffect.static.TIME/11)
end

function LinkEffect:update(dt)
	self.anim:update(dt)

	self.x = self.enemy.x
	self.y = self.enemy.y

	self.time = self.time - dt
	if self.time <= 0 then
		self:kill()
	end
end

function LinkEffect:draw()
	self.anim:draw(self.x, self.y+self.enemy.linkz)
end

return LinkEffect
