local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")
local Laser = require("Laser")

local Sniper = class("Sniper", Enemy)

Sniper.static.MASS = 50
Sniper.static.SOLID = false
Sniper.static.AIM_DIST = 200

Sniper.static.WALK_SPEED = 60
Sniper.static.COOLDOWN = 1.5
Sniper.static.CHARGE_TIME = 1.2

Sniper.static.STATE_IDLE = 0
Sniper.static.STATE_WALK = 1
Sniper.static.STATE_CHARGE = 2

function Sniper:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Sniper.static.MASS, Sniper.static.SOLID, -12)

	self.xspeed = 0
	self.yspeed = 0
	self.dir = -1 + love.math.random(0, 1) * 2

	self.animator = Animator(Resources.getAnimator("sniper.lua"))
	self.collider = BoxCollider(32, 32, 0, -16)

	self.state = Sniper.static.STATE_IDLE
	self.time = love.math.random() * 2

	self.cooldown = 2
end

function Sniper:enter()
	self.map = self.scene:find("map")
	self.player = self.scene:find("player")
end

function Sniper:update(dt)
	self.animator:update(dt)
	self:checkLinked()

	self.time = self.time - dt
	if self.state == Sniper.static.STATE_IDLE then
		if self.time <= 0 then
			self.state = Sniper.static.STATE_WALK
			local dir = love.math.random() * 2 * math.pi
			self.xspeed = math.cos(dir) * Sniper.static.WALK_SPEED
			self.yspeed = math.sin(dir) * Sniper.static.WALK_SPEED
			self.dir = math.sign(self.xspeed)
			self.time = love.math.random() * 2
		end

		self.cooldown = self.cooldown - dt
		if self.cooldown <= 0 then
			local xdist = self.player.x - self.x
			local ydist = self.player.y - self.y
			if xdist^2+ydist^2 < Sniper.static.AIM_DIST^2
			and self.map:canSee(self, self.player) then
				Resources.playSound("charge.wav")
				self.state = Sniper.static.STATE_CHARGE
				self.time = Sniper.static.CHARGE_TIME
				self.aimx = self.player.x
				self.aimy = self.player.y
			end
		end

	elseif self.state == Sniper.static.STATE_WALK then
		local oldx, oldy = self.x, self.y
		self.x = self.x + self.xspeed * dt
		self.y = self.y + self.yspeed * dt

		local collision = CollisionHandler.checkMapBox(self.map, self)
		if collision then
			self.x, self.y = oldx, oldy
		end

		if self.time <= 0 or collision then
			self.state = Sniper.static.STATE_IDLE
			self.time = love.math.random() * 2
		end
	
	elseif self.state == Sniper.static.STATE_CHARGE then
		if self.time <= Sniper.static.CHARGE_TIME/2
		and self.time > Sniper.static.CHARGE_TIME/3 then
			local xdist = self.player.x - self.x
			local ydist = self.player.y - self.y
			local aimx = self.x + 5*xdist
			local aimy = self.y + 5*ydist

			local cells, view = self.map:canSeeLine(self, {x=aimx, y=aimy})

			self.aimx = cells[#cells][1]*32 + 16
			self.aimy = cells[#cells][2]*32 + 16
			self.dir = math.sign(xdist)
		end

		if self.time <= 0 and self:isLinked() == false then
			self.state = Sniper.static.STATE_IDLE
			self.time = 1
			self.cooldown = Sniper.static.COOLDOWN
			Resources.playSound("laser.wav")
			self.scene:add(Laser(self.x+2*self.dir, self.y, self.aimx, self.aimy))
		end
	end

	self.animator:setProperty("state", self.state)
end

function Sniper:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1, 16, 32)
	if self.state == Sniper.static.STATE_CHARGE
	and self.time <= Sniper.static.CHARGE_TIME/2 then
		love.graphics.setColor(234, 45, 45)
		love.graphics.setLineWidth(1)
		love.graphics.line(self.x+2*self.dir, self.y-12, self.aimx, self.aimy-12)
		love.graphics.setColor(255, 255, 255)
	end
end

return Sniper
