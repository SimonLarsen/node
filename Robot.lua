local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")
local Bullet = require("Bullet")
local CollisionHandler = require("CollisionHandler")
local Explosion = require("Explosion")

local Robot = class("Robot", Enemy)

Robot.static.MASS = 200
Robot.static.SOLID = false

Robot.static.WALK_SPEED = 40

Robot.static.STATE_IDLE = 0
Robot.static.STATE_RUN = 1

Robot.static.COOLDOWN = 1.0

function Robot:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Robot.static.MASS, Robot.static.SOLID, -17)
	self:setName("robot")
	
	self.animator = Animator(Resources.getAnimator("robot.lua"))
	self.collider = BoxCollider(20, 32, 0, -16)

	self.state = Robot.static.STATE_IDLE
	self.time = love.math.random() * 2

	self.cooldown = 2
end

function Robot:enter()
	self.player = self.scene:find("player")
	self.map = self.scene:find("map")
end

function Robot:update(dt)
	self.animator:update(dt)
	self:checkLinked()

	if self.state == Robot.static.STATE_IDLE then
		self.time = self.time - dt
		if self.time <= 0 then
			self.state = Robot.static.STATE_RUN
			
			local dir = love.math.random() * 2 * math.pi
			self.xspeed = math.cos(dir) * Robot.static.WALK_SPEED
			self.yspeed = math.sin(dir) * Robot.static.WALK_SPEED
			self.dir = math.sign(self.xspeed)
			self.time = love.math.random() * 2
		end

		self.cooldown = self.cooldown - dt
		if self.cooldown <= 0 then
			self.cooldown = Robot.static.COOLDOWN

			local dx = self.player.x - self.x
			local dy = self.player.y - self.y

			local len = math.sqrt(dx^2 + dy^2)

			if len < 200 then
				local dir = math.atan2(dy, dx)
				self.scene:add(Bullet(self.x, self.y+0.01, dir-0.2))
				self.scene:add(Bullet(self.x, self.y+0.01, dir))
				self.scene:add(Bullet(self.x, self.y+0.01, dir+0.2))
				self.dir = math.sign(dx)
				self.animator:setProperty("fire", true)
			end
		end
	elseif self.state == Robot.static.STATE_RUN then
		self.time = self.time - dt

		local oldx, oldy = self.x, self.y
		self.x = self.x + self.xspeed * dt
		self.y = self.y + self.yspeed * dt

		local collision = CollisionHandler.checkMapBox(self.map, self)
		if collision then
			self.x, self.y = oldx, oldy
		end

		if self.time <= 0 or collision then
			self.state = Robot.static.STATE_IDLE
			self.time = love.math.random() * 1.5
		end
	end

	self.animator:setProperty("state", self.state)
end

function Robot:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1, nil, 40)
end

return Robot
