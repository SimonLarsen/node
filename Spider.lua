local Enemy = require("Enemy")
local Animator = require("Animator")

local Spider = class("Spider", Enemy)

function Spider:initialize(x, y)
	Enemy.initialize(self, x, y, 0)

	self.animator = Animator(Resources.getAnimator("spider.lua"))
end

function Spider:update(dt)
	self.animator:update(dt)

	if self:isLinked() == false and Mouse.wasPressed("l") then
		local mx, my = Mouse.getPositionCamera()
		if mx >= self.x - 16 and mx <= self.x + 16
		and my >= self.y - 16 and my <= self.y + 16 then
			self:setLinked()
			local link = self.scene:find("link")
			link:addLink(self)
		end
	end
end

function Spider:draw()
	self.animator:draw(self.x, self.y, 0, 1, 1, 16, 32)
end

return Spider
