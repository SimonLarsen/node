local Enemy = require("Enemy")
local Robot = require("Robot")
local BoxCollider = require("BoxCollider")
local Grenade = require("Grenade")

local Demobot = class("Demobot", Robot)

Demobot.static.RANGE = 170

function Demobot:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Robot.static.MASS, Robot.static.SOLID, -17, 0.4)
	self:setName("demobot")
	
	self.animator = Animator(Resources.getAnimator("demobot.lua"))
	self.collider = BoxCollider(24, 24, 0, 0)

	self.state = Robot.static.STATE_IDLE
	self.time = love.math.random() * 2
	self.range = Demobot.static.RANGE

	self.cooldown = Robot.static.COOLDOWN
end

function Demobot:shoot(targetx, targety)
	self.scene:add(Grenade(self.x, self.y+0.01, targetx, targety))
	self.animator:setProperty("fire", true)
end

return Demobot
