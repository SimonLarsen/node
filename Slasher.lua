local BoxCollider = require("BoxCollider")
local Enemy = require("Enemy")
local CollisionHandler = require("CollisionHandler")

local Slasher = class("Slasher", Enemy)

Slasher.static.MASS = 170
Slasher.static.SOLID = false

Slasher.static.STATE_IDLE = 0
Slasher.static.STATE_DASH = 1
Slasher.static.STATE_SLASH = 2
Slasher.static.STATE_LINKED = 3

Slasher.static.SLASH_SPEED = 600
Slasher.static.RANGE = 150
Slasher.static.IDLE_TIME = 1.5
Slasher.static.SLASH_TIME = 0.2

function Slasher:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Slasher.static.MASS, Slasher.static.SOLID, -32, 0.15)

	self.state = Slasher.static.STATE_IDLE
	self.dir = 1
	self.time = 0.5

	self.xspeed = 0
	self.yspeed = 0

	self.animator = Animator(Resources.getAnimator("slasher.lua"))
	self.collider = BoxCollider(26, 26, 0, 0)
end

function Slasher:enter()
	Enemy.enter(self)
	self.map = self.scene:find("map")
end

function Slasher:update(dt)
	Enemy.update(self, dt)
	self.animator:update(dt)

	local animstate = self.state

	self.time = self.time - dt
	if self:isLinked() then
		animstate = Slasher.static.STATE_LINKED
	
	elseif self.state == Slasher.static.STATE_IDLE then
		local dx = self.player.x - self.x
		local dy = self.player.y - self.y

		if self.time <= 0 and vector.length(dx, dy) < Slasher.static.RANGE
		and self.map:canSee(self, self.player) then
			self:slash()
		end
	elseif self.state == Slasher.static.STATE_SLASH then
		local oldx, oldy = self.x, self.y
		self.x = self.x + self.xspeed * dt
		self.y = self.y + self.yspeed * dt
		
		local collision = CollisionHandler.checkMapBox(self.map, self)
		if self.time <= 0 or collision then
			self.x, self.y = oldx, oldy
			self.state = Slasher.static.STATE_IDLE
			self.time = Slasher.static.IDLE_TIME
		end
	end

	self.animator:setProperty("state", animstate)
end

function Slasher:slash()
	self.state = Slasher.static.STATE_SLASH
	self.time = Slasher.static.SLASH_TIME
	
	local dx = self.player.x - self.x
	local dy = self.player.y - self.y
	local dist = vector.length(dx, dy)

	self.xspeed = dx / dist * Slasher.static.SLASH_SPEED
	self.yspeed = dy / dist * Slasher.static.SLASH_SPEED
	self.dir = math.sign(self.xspeed)
end

function Slasher:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1)

	self:drawLink()
end

return Slasher
