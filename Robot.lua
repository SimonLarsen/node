local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")

local Robot = class("Robot", Enemy)

Robot.static.MASS = 200
Robot.static.SOLID = false

function Robot:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Robot.static.MASS, Robot.static.SOLID)
	
	self.sprite = Resources.getImage("robot.png")
	self.collider = BoxCollider(32, 48, -16, -48)
end

function Robot:update(dt)

end

function Robot:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, 16, 48)
end

return Robot
