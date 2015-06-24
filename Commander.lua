local Enemy = require("Enemy")
local Robot = require("Robot")
local Bullet = require("Bullet")
local BoxCollider = require("BoxCollider")

local Commander = class("Commander", Robot)

Commander.static.MAX_HP = 2
Commander.static.RANGE = 230

function Commander:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Robot.static.MASS, Robot.static.SOLID, -17, Commander.static.MAX_HP)
	self:setName("commander")
	
	self.animator = Animator(Resources.getAnimator("commander.lua"))
	self.collider = BoxCollider(20, 20, 0, 0)

	self.state = Robot.static.STATE_IDLE
	self.time = love.math.random() * 2
	self.range = Commander.static.RANGE

	self.cooldown = Robot.static.COOLDOWN
end

function Commander:shoot(targetx, targety)
	local dir = math.atan2(targety - self.y, targetx - self.x)
	self.scene:add(Bullet(self.x, self.y+0.01, dir-0.2))
	self.scene:add(Bullet(self.x, self.y+0.01, dir))
	self.scene:add(Bullet(self.x, self.y+0.01, dir+0.2))
end

return Commander
