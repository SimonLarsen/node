local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")
local BigExplosion = require("BigExplosion")

local Spider = class("Spider", Enemy)

Spider.static.MASS = 50
Spider.static.SOLID = false

Spider.static.WALK_SPEED = 60
Spider.static.CHARGE_SPEED = 200
Spider.static.DETONATE_DIST = 16

Spider.static.STATE_IDLE = 0
Spider.static.STATE_WALK = 1
Spider.static.STATE_ALERT = 2
Spider.static.STATE_CHARGE = 3
Spider.static.STATE_LINKED = 4

function Spider:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Spider.static.MASS, Spider.static.SOLID, -12, 0.15)
	self:setName("spider")

	self.xspeed = 0
	self.yspeed = 0
	self.dir = -1 + love.math.random(0, 1) * 2

	self.animator = Animator(Resources.getAnimator("spider.lua"))
	self.collider = BoxCollider(32, 32, 0, 0)

	self.state = Spider.static.STATE_IDLE
	self.time = love.math.random() * 2
end

function Spider:enter()
	Enemy.enter(self)

	self.map = self.scene:find("map")
end

function Spider:update(dt)
	Enemy.update(self, dt)
	self.animator:update(dt)

	local xdist = self.player.x - self.x
	local ydist = self.player.y - self.y

	local animstate = self.state

	if self.state == Spider.static.STATE_IDLE
	or self.state == Spider.static.STATE_WALK then
		if xdist^2+ydist^2 < 80^2 then
			self.state = Spider.static.STATE_ALERT
			self.time = 1
		end
	end

	self.time = self.time - dt
	if self:isLinked() then
		animstate = Spider.static.STATE_LINKED

	elseif self.state == Spider.static.STATE_IDLE then
		if self.time <= 0 then
			self.state = Spider.static.STATE_WALK
			local dir = love.math.random() * 2 * math.pi
			self.xspeed = math.cos(dir) * Spider.static.WALK_SPEED
			self.yspeed = math.sin(dir) * Spider.static.WALK_SPEED
			self.dir = math.sign(self.xspeed)
			self.time = love.math.random() * 2
		end

	elseif self.state == Spider.static.STATE_WALK then
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
		self.dir = math.sign(xdist)
		if self.time <= 0 then
			self.state = Spider.static.STATE_CHARGE
			local dist = math.sqrt(xdist^2 + ydist^2)
			self.xspeed = xdist / dist * Spider.static.CHARGE_SPEED
			self.yspeed = ydist / dist * Spider.static.CHARGE_SPEED
			self.time = 1.3
		end

	elseif self.state == Spider.static.STATE_CHARGE then
		self.x = self.x + self.xspeed * dt
		self.y = self.y + self.yspeed * dt
		self.dir = math.sign(self.xspeed)

		local xdist = self.x - self.player.x
		local ydist = self.y - self.player.y

		if self.time <= 0 then
			self.state = Spider.static.STATE_IDLE
			self.time = 1
		end

		local collision = CollisionHandler.checkMapBox(self.map, self)
		if xdist^2+ydist^2 < Spider.static.DETONATE_DIST^2
		or collision then
			self:explode()
		end
	end

	self.animator:setProperty("state", animstate)
end

function Spider:explode()
	self.scene:add(BigExplosion(self.x, self.y, true))
	self:kill()
end

function Spider:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1)

	self:drawLink()
end

return Spider
