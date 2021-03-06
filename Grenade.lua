local tween = require("tween.tween")
local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")
local BigExplosion = require("BigExplosion")

local Grenade = class("Grenade", Enemy)

Grenade.static.MASS = 20
Grenade.static.SOLID = false
Grenade.static.MAX_HP = 1

Grenade.static.TIME = 1.5
Grenade.static.SPEED = 250

function Grenade:initialize(x, y, targetx, targety)
	Enemy.initialize(self, x, y, 0, Grenade.static.MASS, Grenade.static.SOLID, 0, Grenade.static.MAX_HP)
	self:setName("grenade")

	self.height = 19

	self.time = Grenade.static.TIME*1.5

	self.xtween = tween.new(Grenade.static.TIME/2, self, {x=targetx}, tween.easing.cubic)
	self.ytween = tween.new(Grenade.static.TIME/2, self, {y=targety}, tween.easing.cubic)
	self.heighttween = tween.new(Grenade.static.TIME/2, self, {height = 0}, tween.easing.outBounce)

	self.animator = Animator(Resources.getAnimator("grenade.lua"))
	self.collider = BoxCollider(32, 32, 0, 0)
end

function Grenade:update(dt)
	Enemy.update(self, dt)
	self.animator:update(dt)
	self.time = self.time - dt

	if self:isStunned() == false then
		self.xtween:update(dt)
		self.ytween:update(dt)
		self.heighttween:update(dt)
	end

	if self.time <= 0 and self:isStunned() == false then
		self.scene:add(BigExplosion(self.x, self.y, true))
		self:kill()
	end

	if self.time < 0.75 then
		self.animator:setProperty("state", 1)
	end
end

function Grenade:draw()
	love.graphics.setColor(0, 0, 0, 128)
	love.graphics.circle("fill", self.x, self.y, 4, 8)
	love.graphics.setColor(255, 255, 255, 255)

	if self:isStunned() then
		self.animator:draw(self.x, self.y, 0, 1, 1)
	else
		self.animator:draw(self.x, self.y-self.height, 0, 1, 1)
	end

	self:drawLink()
end

function Grenade:destroy()
	self.scene:add(BigExplosion(self.x, self.y, true))
	self:kill()
end

function Grenade:countsInWave()
	return false
end

return Grenade
