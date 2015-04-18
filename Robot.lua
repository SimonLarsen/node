local Robot = class("Robot", Entity)

function Robot:initialize(x, y)
	Entity.initialize(self, x, y, 0)
	
	self.sprite = Resources.getImage("images/robot.png")
end

function Robot:update()
	
end

function Robot:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, 16, 48)
end

return Robot
