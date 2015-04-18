local Enemy = require("Enemy")
local Rock = class("Rock", Enemy)

Rock.static.MASS = 10000
Rock.static.SOLID = true

function Rock:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Rock.static.MASS, Rock.static.SOLID)

	self.animator = Animator(Resources.getAnimator("rock.lua"))
end

function Rock:update(dt)
	self.animator:update(dt)

	if self:isLinked() == false and Mouse.wasPressed("l") then
		local mx, my = Mouse.getPositionCamera()
		if mx >= self.x - 16 and mx <= self.x + 16
		and my >= self.y - 32 and my <= self.y then
			self:setLinked()
			local link = self.scene:find("link")
			link:addLink(self)
		end
	end
end

function Rock:draw()
	self.animator:draw(self.x, self.y, 0, 1, 1, 16, 32)
end

return Rock
