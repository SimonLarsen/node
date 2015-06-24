local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")
local Bullet = require("Bullet")
local CollisionHandler = require("CollisionHandler")
local Explosion = require("Explosion")

local Robot = class("Robot", Enemy)

Robot.static.MASS = 200
Robot.static.SOLID = false
Robot.static.MAX_HP = 2

Robot.static.WALK_SPEED = 40

Robot.static.STATE_IDLE = 0
Robot.static.STATE_RUN = 1
Robot.static.STATE_SHOOT = 2
Robot.static.STATE_LINKED = 3

Robot.static.RANGE = 220
Robot.static.COOLDOWN = 0.3
Robot.static.SHOOT_TIME = 0.3

function Robot:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Robot.static.MASS, Robot.static.SOLID, -17, Robot.static.MAX_HP)
	self:setName("robot")
	
	self.animator = Animator(Resources.getAnimator("robot.lua"))
	self.collider = BoxCollider(20, 20, 0, 0)

	self.state = Robot.static.STATE_IDLE
	self.time = love.math.random()
	self.cooldown = love.math.random()
	self.range = Robot.static.RANGE
end

function Robot:enter()
	Enemy.enter(self)
	self.map = self.scene:find("map")
end

function Robot:update(dt)
	Enemy.update(self, dt)
	self.animator:update(dt)

	local animstate = self.state
	self.time = self.time - dt

	if self:isStunned() then
		animstate = Robot.static.STATE_LINKED
	elseif self.state == Robot.static.STATE_IDLE then
		if self.time <= 0 then
			self:run()
		end

		self.cooldown = self.cooldown - dt
		if self.cooldown <= 0 then
			local dx = self.player.x - self.x
			local dy = self.player.y - self.y
			local len = vector.length(dx, dy)
			if len < self.range and self.map:canSee(self, self.player) then
				self.state = Robot.static.STATE_SHOOT
				self.time = Robot.static.SHOOT_TIME
			end
		end
	elseif self.state == Robot.static.STATE_RUN then
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

	elseif self.state == Robot.static.STATE_SHOOT then
		self.cooldown = self.cooldown - dt
		if self.cooldown <= 0 then
			self.cooldown = Robot.static.COOLDOWN
			self:shoot(self.player.x, self.player.y)
			self.dir = math.sign(self.player.x - self.x)
		end

		if self.time <= 0 then
			self:run()
		end
	end

	self.animator:setProperty("state", animstate)
end

function Robot:run()
	self.state = Robot.static.STATE_RUN

	local dx = self.player.x - self.x
	local dy = self.player.y - self.y

	local player_dir = math.atan2(dy, dx)
	local dir = love.math.randomNormal(math.pi/2, player_dir)
	self.xspeed = math.cos(dir) * Robot.static.WALK_SPEED
	self.yspeed = math.sin(dir) * Robot.static.WALK_SPEED
	self.dir = math.sign(self.xspeed)
	self.time = 1.0 + love.math.random() * 1.5
end

function Robot:shoot(targetx, targety)
	local dir = math.atan2(targety - self.y, targetx - self.x)
	self.scene:add(Bullet(self.x, self.y+0.01, dir))
end

function Robot:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1)

	self:drawLink()
end

return Robot
