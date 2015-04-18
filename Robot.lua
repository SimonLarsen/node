local Enemy = require("Enemy")

local Robot = class("Robot", Enemy)

Robot.static.MASS = 200
Robot.static.SOLID = false

function Robot:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Robot.static.MASS, Robot.static.SOLID)
	
	self.sprite = Resources.getImage("robot.png")
end

function Robot:update(dt)
	if self:isLinked() == false and Mouse.wasPressed("l") then
		local mx, my = Mouse.getPositionCamera()
		if mx >= self.x - 16 and mx <= self.x + 16
		and my >= self.y - 48 and my <= self.y then
			self:setLinked()
			local link = self.scene:find("link")
			link:addLink(self)
		end
	end
end

function Robot:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, 16, 48)
end

return Robot
