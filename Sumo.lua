local BoxCollider = require("BoxCollider")
local Enemy = require("Enemy")
local CollisionHandler = require("CollisionHandler")
local Bullet = require("Bullet")

local Sumo = class("Sumo", Enemy)

Sumo.static.MASS = 300
Sumo.static.SOLID = false
Sumo.static.MAX_HP = 5
Sumo.static.LIVES = 2

Sumo.static.WALK_SPEED = 30

Sumo.static.STATE_IDLE = 0
Sumo.static.STATE_RUN = 1
Sumo.static.STATE_SHOOT = 2
Sumo.static.STATE_LINKED = 3

Sumo.static.RANGE = 220
Sumo.static.COOLDOWN = 0.15
Sumo.static.SHOOT_TIME = 1.0

function Sumo:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Sumo.static.MASS, Sumo.static.SOLID, -20, Sumo.static.MAX_HP, Sumo.static.LIVES)
	self:setName("sumo")

	self.shoot_dir = 0

	self:run()

	self.animator = Animator(Resources.getAnimator("sumo.lua"))
	self.collider = BoxCollider(44, 44, 0, 0)
	self.cooldown = Sumo.static.COOLDOWN
end

function Sumo:enter()
	Enemy.enter(self)

	self.map = self.scene:find("map")
end

function Sumo:update(dt)
	Enemy.update(self, dt)
	self.animator:update(dt)

	local animstate = self.state

	if self:isStunned() then
		animstate = Sumo.static.STATE_LINKED

	elseif self.state == Sumo.static.STATE_RUN then
		self.time = self.time - dt

		local oldx, oldy = self.x, self.y
		self.x = self.x + self.xspeed * dt
		self.y = self.y + self.yspeed * dt

		local collision = CollisionHandler.checkMapBox(self.map, self)
		if collision then
			self.x, self.y = oldx, oldy
			self:run()
		end
		
		if self.time <= 0
		and vector.length(self.x-self.player.x, self.y-self.player.y) < Sumo.static.RANGE then
			self.state = Sumo.static.STATE_SHOOT
			self.time = Sumo.static.SHOOT_TIME
			self.cooldown = Sumo.static.COOLDOWN
		end

	elseif self.state == Sumo.static.STATE_SHOOT then
		self.time = self.time - dt
		self.cooldown = self.cooldown - dt

		if self.cooldown <= 0 then
			self:shoot()
			self.cooldown = Sumo.static.COOLDOWN
		end

		if self.time <= 0 then
			self:run()
		end
	end

	self.animator:setProperty("state", animstate)
end

function Sumo:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1)

	self:drawLink()
end

function Sumo:run()
	self.state = Sumo.static.STATE_RUN
	self.time = 2 + love.math.random()
	local dir = love.math.random() * math.pi * 2
	self.xspeed = math.cos(dir) * Sumo.static.WALK_SPEED
	self.yspeed = math.sin(dir) * Sumo.static.WALK_SPEED
	self.dir = math.sign(self.xspeed)
end

function Sumo:shoot()
	for i=0,3 do
		local dir = i * math.pi / 2 + self.shoot_dir
		self.scene:add(Bullet(self.x, self.y+0.01, dir))
	end

	self.shoot_dir = self.shoot_dir + 0.25
	self.cooldown = Sumo.static.COOLDOWN
end

return Sumo
