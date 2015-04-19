local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")

local Spider = class("Spider", Enemy)

Spider.static.MASS = 50
Spider.static.SOLID = false

Spider.static.WALK_SPEED = 60
Spider.static.CHARGE_SPEED = 200

Spider.static.STATE_IDLE = 0
Spider.static.STATE_WALK = 1
Spider.static.STATE_ALERT = 2
Spider.static.STATE_CHARGE = 3

function Spider:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Spider.static.MASS, Spider.static.SOLID, -12)

	self.xspeed = 0
	self.yspeed = 0
	self.dir = -1 + love.math.random(0, 1) * 2

	self.animator = Animator(Resources.getAnimator("spider.lua"))
	self.collider = BoxCollider(32, 32, 0, -16)

	self.state = Spider.static.STATE_IDLE
	self.time = love.math.random() * 2
end

function Spider:enter()
	self.map = self.scene:find("map")
	self.player = self.scene:find("player")
end

function Spider:update(dt)
	self.animator:update(dt)
	self:checkLinked()

	local xdist = self.player.x - self.x
	local ydist = self.player.y - self.y


	if self.state == Spider.static.STATE_IDLE
	or self.state == Spider.static.STATE_WALK then
		if xdist^2+ydist^2 < 80^2 then
			self.state = Spider.static.STATE_ALERT
			self.time = 1
		end
	end

	if self.state == Spider.static.STATE_IDLE then
		self.time = self.time - dt
		if self.time <= 0 then
			self.state = Spider.static.STATE_WALK
			local dir = love.math.random() * 2 * math.pi
			self.xspeed = math.cos(dir) * Spider.static.WALK_SPEED
			self.yspeed = math.sin(dir) * Spider.static.WALK_SPEED
			self.dir = math.sign(self.xspeed)
			self.time = love.math.random() * 2
		end

	elseif self.state == Spider.static.STATE_WALK then
		self.time = self.time - dt

		local oldx, oldy = self.x, self.y
		self.x = self.x + self.xspeed * dt
		self.y = self.y + self.yspeed * dt

		local collision = CollisionHandler.checkMapBox(self.map, self)
		if collision then
			self.x, self.y = oldx, oldy
		end

		if self.time <= 0 or collision then
			self.state = Spider.static.STATE_IDLE
			self.time = love.math.random() * 2
		end

	elseif self.state == Spider.static.STATE_ALERT then
		self.time = self.time - dt
		self.dir = math.sign(xdist)
		if self.time <= 0 then
			self.state = Spider.static.STATE_CHARGE
			local dist = math.sqrt(xdist^2 + ydist^2)
			self.xspeed = xdist / dist * Spider.static.CHARGE_SPEED
			self.yspeed = ydist / dist * Spider.static.CHARGE_SPEED
			self.time = 2
		end

	elseif self.state == Spider.static.STATE_CHARGE then
		self.time = self.time - dt

		self.x = self.x + self.xspeed * dt
		self.y = self.y + self.yspeed * dt
		self.dir = math.sign(self.xspeed)

		if self.time <= 0 then
			self.state = Spider.static.STATE_IDLE
			self.time = 1
		end

		local collision = CollisionHandler.checkMapBox(self.map, self)
		if collision then
			self:destroy()
		end
	end

	self.animator:setProperty("state", self.state)
end

function Spider:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1, 16, 32)
end

return Spider
